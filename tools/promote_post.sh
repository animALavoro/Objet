#!/bin/bash
# Makes the post-production release SRC_TAG (e.g. post-2026.12.01) the one students get: its files go to the
# release "post" (always a pre-release, so that the suite stays GitHub's latest), files no longer in SRC_TAG are removed.
#   GH_TOKEN=... GITHUB_REPOSITORY=owner/repo tools/promote_post.sh SRC_TAG [DIR with SRC_TAG's files]
set -euo pipefail
SRC="$1"
DIR="${2:-}"
R="$GITHUB_REPOSITORY"
[ "$SRC" != post ] || { echo "give the release to copy, e.g. post-2026.12.01"; exit 1; }
if [ -z "$DIR" ]; then
  DIR="$(mktemp -d)"
  gh release download "$SRC" --dir "$DIR" --repo "$R"
fi
NOTES="$(dirname "$0")/../NOTES-post.md"
TITLE="Post produzione (${SRC#post-})"
if gh release view post --repo "$R" > /dev/null 2>&1; then
  gh release upload post "$DIR"/* --clobber --repo "$R"
  gh release view post --repo "$R" --json assets --jq '.assets[].name' | while IFS= read -r a; do
    [ -e "$DIR/$a" ] || gh release delete-asset post "$a" --yes --repo "$R"
  done
  gh release edit post --title "$TITLE" --notes-file "$NOTES" --prerelease --latest=false --repo "$R"
else
  gh release create post "$DIR"/* --title "$TITLE" --notes-file "$NOTES" --prerelease --latest=false --repo "$R"
fi
echo "release post = $SRC"
