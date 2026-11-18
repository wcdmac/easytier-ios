#!/usr/bin/env bash
# Push the iOS 15 / unsigned-IPA adaptation to your own GitHub repo via SSH,
# which triggers the GitHub Actions build.
#
# Usage:
#   bash push-to-github.sh <github-user>/<repo-name>
# Example:
#   bash push-to-github.sh wcdmac/EasyTier-iOS-ios15
#
# Prerequisite: create an EMPTY repository on GitHub first (no README, no license).
# SSH key must be authorized for the account (already verified for wcdmac).

set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <github-user>/<repo-name>" >&2
  exit 1
fi

TARGET="$1"
if [[ "$TARGET" != */* ]]; then
  echo "Target must be in the form <user>/<repo>" >&2
  exit 1
fi

echo ">> Target repository: ${TARGET}"
echo ">> Verifying SSH authentication..."
ssh -T git@github.com 2>&1 | head -1 || true

# Verify remote is reachable and empty enough to receive our history.
if git ls-remote "git@github.com:${TARGET}.git" HEAD 2>/dev/null | grep -q .; then
  echo "!! WARNING: target repository is not empty. Force push will overwrite its main branch." >&2
  read -r -p "Type YES to continue: " CONFIRM
  if [ "$CONFIRM" != "YES" ]; then
    echo "Aborted." >&2
    exit 1
  fi
fi

git remote remove origin 2>/dev/null || true
git remote add origin "git@github.com:${TARGET}.git"
git branch -M main

echo ">> Pushing main branch..."
git push -u origin main

echo ">> Triggering workflow explicitly..."
if command -v gh >/dev/null 2>&1; then
  gh workflow run build-ios15-unsigned.yml --repo "$TARGET" || \
    echo "Note: workflow_dispatch via gh requires API token; push already triggered the workflow automatically."
else
  echo "Note: push to main already triggers the workflow (on.push.branches: main)."
fi

echo ">> Done. Monitor the build at:"
echo "   https://github.com/${TARGET}/actions"
echo ">> Unsigned IPA will be attached to the 'ios15-unsigned' release and the workflow artifact."
