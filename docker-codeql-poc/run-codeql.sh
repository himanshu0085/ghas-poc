#!/bin/bash
set -e

REPO_URL=$1
BRANCH=${2:-main}

if [ -z "$REPO_URL" ]; then
    echo "❌ Provide GitHub repo URL"
    exit 1
fi

git clone -b "$BRANCH" "$REPO_URL" repo
cd repo

echo "⚙️ Creating CodeQL DB..."
codeql database create db --language=javascript --source-root=.

echo "🔍 Running CodeQL JS Security + Quality..."
codeql database analyze db \
  /opt/codeql/packs/codeql/javascript/ql/src/codeql-suites/javascript-security-and-quality.qls \
  --threads=0 \
  --format=sarifv2.1.0 \
  --output=results.sarif

echo "📌 Scan complete: /scan/repo/results.sarif"
