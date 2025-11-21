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

echo "🔍 Running local JavaScript queries..."
codeql database analyze db \
  /opt/codeql/packs/javascript \
  --threads=0 \
  --format=sarifv2.1.0 \
  --output=results.sarif

echo "📌 Scan complete! Results saved to results.sarif"
