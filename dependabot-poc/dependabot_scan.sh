#!/usr/bin/env bash
set -euo pipefail

# dependabot_scan.sh
# Generates:
# - dependabot_results.json
# - dependabot_report.md
# - dependabot_summary.csv

if [ -z "${GH_TOKEN:-}" ] || [ -z "${REPO:-}" ]; then
  echo "❌ Error: GH_TOKEN and REPO must be provided."
  echo "Usage: docker run -e GH_TOKEN=... -e REPO=owner/repo -v \$(pwd):/app dependabot-scan"
  exit 1
fi

# Export GH_TOKEN for GitHub CLI (no interactive login needed)
export GH_TOKEN="$GH_TOKEN"

OUT_JSON="/app/dependabot_results.json"
OUT_MD="/app/dependabot_report.md"
OUT_CSV="/app/dependabot_summary.csv"

echo "🔍 Fetching Dependabot alerts for repo: $REPO ..."
gh api -H "Accept: application/vnd.github+json" \
  "/repos/$REPO/dependabot/alerts" > "$OUT_JSON" || {
    echo "❌ API call failed — check token permissions and repo name."
    exit 2
}

echo "📄 Raw JSON saved to: $OUT_JSON"

# No alerts case
if [ "$(jq 'length' "$OUT_JSON")" -eq 0 ]; then
  echo "ℹ️ No Dependabot alerts found."

  cat > "$OUT_MD" <<EOF
# Dependabot Report — $REPO

_No Dependabot alerts found._
EOF

  echo "alert_number,package,severity,state,manifest_path,summary" > "$OUT_CSV"
  exit 0
fi

# CSV header
echo "alert_number,package,severity,state,manifest_path,summary" > "$OUT_CSV"

# Markdown header
cat > "$OUT_MD" <<EOF
# Dependabot Full Report — $REPO

Generated: $(date -u +"%Y-%m-%d %H:%M:%SZ")
Repository: **$REPO**

---

## Summary Table

| Alert # | Package | Severity | State | Manifest Path |
|--------:|:-------:|:--------:|:-----:|:-------------:|
EOF

# Loop through alerts
jq -c '.[]' "$OUT_JSON" | while read -r alert; do

  number=$(jq -r '.number' <<<"$alert")
  state=$(jq -r '.state' <<<"$alert")
  pkg=$(jq -r '(.dependency.package.name // .security_vulnerability.package.name)' <<<"$alert")
  manifest=$(jq -r '.dependency.manifest_path // "n/a"' <<<"$alert")
  severity=$(jq -r '(.security_advisory.severity // .security_vulnerability.severity)' <<<"$alert")
  title=$(jq -r '(.security_advisory.summary // "n/a")' <<<"$alert")
  summary_text=$(jq -r '(.security_advisory.description // .security_advisory.summary // "n/a")' <<<"$alert")

  # Markdown summary row
  printf "| %s | %s | %s | %s | %s |\n" \
    "$number" "$pkg" "$severity" "$state" "$manifest" >> "$OUT_MD"

  # Detailed alert section
  cat >> "$OUT_MD" <<DETAIL

---

### Alert #$number — $pkg

- **State:** $state
- **Severity:** $severity
- **Package:** $pkg
- **Manifest:** $manifest
- **Title:** $title

**Summary:**  
$summary_text

DETAIL

  # CSV row
  echo "$number,\"$pkg\",$severity,$state,\"$manifest\",\"$title\"" >> "$OUT_CSV"

done

echo "✅ Report generated:"
echo " - $OUT_JSON"
echo " - $OUT_MD"
echo " - $OUT_CSV"

# Pretty terminal output
echo
echo "🔁 Top alerts:"
jq -r '.[] | "Alert #" + (.number|tostring) + " | " +
       (.dependency.package.name // .security_vulnerability.package.name) +
       " | " +
       (.security_advisory.severity // .security_vulnerability.severity) +
       " | " +
       .state' "$OUT_JSON" | sed -n '1,20p'
