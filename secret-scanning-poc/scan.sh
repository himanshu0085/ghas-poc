#!/bin/bash

if [ -z "$GH_TOKEN" ] || [ -z "$REPO" ]; then
  echo "❌ Error: GH_TOKEN and REPO must be provided"
  exit 1
fi

gh auth login --with-token <<< "$GH_TOKEN"

echo "🔍 Fetching secret scanning alerts for $REPO ..."
gh api \
  -H "Accept: application/vnd.github+json" \
  /repos/$REPO/secret-scanning/alerts \
  > results.json

echo "📄 Results saved to results.json"
cat results.json | jq
