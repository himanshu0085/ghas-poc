#!/bin/bash
set -e

REPO_URL="$1"

if [ -z "$REPO_URL" ]; then
  echo "Usage: ./run-codeql.sh <repo_url>"
  exit 1
fi

SCAN_DIR="/scan/repo"
RESULT_SARIF="$SCAN_DIR/results.sarif"
RESULT_HTML="$SCAN_DIR/report.html"
RESULT_CSV="$SCAN_DIR/report.csv"

# Remove previous repo if exists
if [ -d "$SCAN_DIR" ]; then
  echo "Removing previous repository folder..."
  rm -rf "$SCAN_DIR"
fi

echo "Cloning repository..."
git clone "$REPO_URL" "$SCAN_DIR"

# -----------------------------------------
# AUTO-DETECT LANGUAGES
# -----------------------------------------
echo "Detecting programming languages in repo..."

LANGUAGES=()

grep -R --include='*.js' --include='*.jsx' --include='*.ts' --include='*.tsx' -q . "$SCAN_DIR" && LANGUAGES+=("javascript")
grep -R --include='*.py'  -q . "$SCAN_DIR" && LANGUAGES+=("python")
grep -R --include='*.java' -q . "$SCAN_DIR" && LANGUAGES+=("java")
grep -R --include='*.go'  -q . "$SCAN_DIR" && LANGUAGES+=("go")

if [ ${#LANGUAGES[@]} -eq 0 ]; then
  echo "No supported languages detected (JS / Python / Java / Go)."
  exit 1
fi

echo "Detected languages: ${LANGUAGES[*]}"

DB_LIST=()
TMP_SARIFS=()

# -----------------------------------------
# CREATE DATABASES
# -----------------------------------------
for LANG in "${LANGUAGES[@]}"; do
  DB_PATH="$SCAN_DIR/db-$LANG"

  echo "Creating CodeQL database for: $LANG"
  if codeql database create "$DB_PATH" --language="$LANG" --source-root "$SCAN_DIR"; then
    DB_LIST+=("$DB_PATH")
  else
    echo "DB creation failed for $LANG — skipping"
  fi
done

if [ ${#DB_LIST[@]} -eq 0 ]; then
  echo "No valid CodeQL databases created — terminating scan"
  exit 1
fi

# -----------------------------------------
# ANALYZE EACH DB
# -----------------------------------------
for DB in "${DB_LIST[@]}"; do
  [[ ! -d "$DB" ]] && continue

  case "$DB" in
    *javascript*) QUERY="codeql/javascript-queries" ;;
    *python*)     QUERY="codeql/python-queries" ;;
    *java*)       QUERY="codeql/java-queries" ;;
    *go*)         QUERY="codeql/go-queries" ;;
  esac

  OUT="$DB-results.sarif"
  TMP_SARIFS+=("$OUT")

  echo "Running $QUERY on $DB"
  if ! codeql database analyze "$DB" "$QUERY" --format=sarifv2.1.0 --output "$OUT"; then
    echo "Analysis failed for $DB"
  fi
done

# -----------------------------------------
# MERGE SARIF (manual append — no merge-results)
# -----------------------------------------
echo "Combining SARIF results..."

echo '{"version":"2.1.0","$schema":"https://json.schemastore.org/sarif-2.1.0.json","runs":[' > "$RESULT_SARIF"
FIRST=true
for F in "${TMP_SARIFS[@]}"; do
  [[ ! -f "$F" ]] && continue
  if [ "$FIRST" = true ]; then
    jq '.runs[]' "$F" >> "$RESULT_SARIF"
    FIRST=false
  else
    echo "," >> "$RESULT_SARIF"
    jq '.runs[]' "$F" >> "$RESULT_SARIF"
  fi
done
echo "]}" >> "$RESULT_SARIF"

# -----------------------------------------
# TERMINAL SUMMARY
# -----------------------------------------
echo ""
echo "Terminal Summary of Findings:"
if command -v jq >/dev/null 2>&1; then
  jq -r '
    .runs[].results[] |
    {
      ruleId,
      message: .message.text,
      file: .locations[0].physicalLocation.artifactLocation.uri,
      line: .locations[0].physicalLocation.region.startLine,
      severity: (.properties["security-severity"] // .level // "info")
    }
  ' "$RESULT_SARIF" |
  jq -s 'unique_by(.ruleId + .message + .file + (.line|tostring))[]' |
  jq .
else
  echo "jq not installed — skipping formatted findings"
fi

# -----------------------------------------
# CSV REPORT
# -----------------------------------------
echo "Generating CSV report at $RESULT_CSV..."
echo "Rule ID,Severity,Message,File,Line" > "$RESULT_CSV"

jq -r '
  .runs[].results[] |
  {
    ruleId,
    message: .message.text,
    file: .locations[0].physicalLocation.artifactLocation.uri,
    line: .locations[0].physicalLocation.region.startLine,
    severity: (.properties["security-severity"] // .level // "info")
  }
' "$RESULT_SARIF" |
jq -s 'unique_by(.ruleId + .message + .file + (.line|tostring))[]' |
jq -r '
  "\"" + .ruleId + "\"," +
  "\"" + (.severity|tostring) + "\"," +
  "\"" + (.message|gsub("\"";"\"\"")) + "\"," +
  "\"" + .file + "\"," +
  "\"" + (.line|tostring) + "\""
' >> "$RESULT_CSV"

# -----------------------------------------
# HTML REPORT
# -----------------------------------------
echo "Generating HTML report..."

cat <<EOF > "$RESULT_HTML"
<html>
<head>
<title>CodeQL Security Report</title>
<style>
body { font-family: Arial; background: #fafafa; }
table { border-collapse: collapse; width: 100%; margin-top: 12px; }
th, td { border: 1px solid #888; padding: 6px; font-size: 14px; }
th { background: #333; color: white; }
.sev-high { background: #ffb3b3; }
.sev-medium { background: #ffe8a1; }
.sev-low { background: #c8f5b8; }
</style>
</head>
<body>
<h2>CodeQL Security & Quality Findings</h2>
<table>
<tr><th>Rule ID</th><th>Severity</th><th>Message</th><th>File</th><th>Line</th></tr>
EOF

jq -r '
  .runs[].results[] |
  {
    ruleId,
    message: .message.text,
    file: .locations[0].physicalLocation.artifactLocation.uri,
    line: .locations[0].physicalLocation.region.startLine,
    severity: (.properties["security-severity"] // .level // "info")
  }
' "$RESULT_SARIF" |
jq -s 'unique_by(.ruleId + .message + .file + (.line|tostring))[]' |
jq -r '
  .sevScore =
    if (.severity | type) == "number" then .severity
    elif .severity == "error" then 9
    elif .severity == "warning" then 6
    else 2 end
  |
  "<tr class=\"" +
    (if .sevScore >= 8 then "sev-high"
     elif .sevScore >= 4 then "sev-medium"
     else "sev-low" end) +
  "\"><td>" + .ruleId +
  "</td><td>" + (.sevScore|tostring) +
  "</td><td>" + .message +
  "</td><td>" + .file +
  "</td><td>" + (.line|tostring) +
  "</td></tr>"
' >> "$RESULT_HTML"

echo "</table></body></html>" >> "$RESULT_HTML"

# -----------------------------------------
# DONE
# -----------------------------------------
echo ""
echo "Scan completed successfully!"
echo "SARIF report :  $RESULT_SARIF"
echo "HTML report  :  $RESULT_HTML"
echo "CSV report   :  $RESULT_CSV"
echo ""
echo "Open report.html in browser OR report.csv in Excel"
