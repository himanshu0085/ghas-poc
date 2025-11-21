#!/bin/bash

REPO_URL=$1
BRANCH=${2:-main}

if [ -z "$REPO_URL" ]; then
    echo "❌ Provide GitHub repo URL"
    exit 1
fi

git clone -b "$BRANCH" "$REPO_URL" repo
cd repo

codeql database create db --language=javascript --source-root=.

codeql database analyze db \
  /opt/codeql/javascript/ql/src/codeql-suites/javascript-code-scanning.qls \
  --format=sarifv2.1.0 --output=results.sarif

echo "📌 Scan complete! Results saved to results.sarif"
