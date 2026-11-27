#!/bin/bash
# Puts a course kit's installers and REAPER configuration in a folder (Release and Refresh workflows).
#   tools/prepare_kit.sh suite DIR   install-mac.sh, install-windows.ps1 as they are (default: all, latest release)
#                                    and kit/*.ReaperConfigZip (the immersive course)
#   tools/prepare_kit.sh post DIR    the installers set to install the post-production kit from the release "post"
#                                    without arguments, and kit/post/* (the post-production course); for each
#                                    project template (.rpp, saved on Windows) also its macOS copy NAME-mac.rpp
#                                    (tools/mac_template.py: Dragonfly Reverb's macOS IDs)
set -euo pipefail
KIT="$1"
DIR="$2"
cd "$(dirname "$0")/.."
mkdir -p "$DIR"
cp install-mac.sh install-windows.ps1 "$DIR/"
case "$KIT" in
  suite) cp kit/*.ReaperConfigZip "$DIR/" ;;
  post)  cp kit/post/* "$DIR/"
         for t in kit/post/*.rpp; do
           [ -e "$t" ] || continue
           n="$(basename "$t" .rpp)"
           python3 tools/mac_template.py "$t" "$DIR/$n-mac.rpp"
         done
         sed -i -e 's/^DEFAULT_PART="all"$/DEFAULT_PART="post"/' -e 's/^DEFAULT_TAG=""$/DEFAULT_TAG="post"/' "$DIR/install-mac.sh"
         sed -i -e 's/^\$DefaultPart = "all"$/$DefaultPart = "post"/' -e 's/^\$DefaultTag = ""$/$DefaultTag = "post"/' "$DIR/install-windows.ps1"
         grep -qx 'DEFAULT_PART="post"' "$DIR/install-mac.sh" && grep -qx 'DEFAULT_TAG="post"' "$DIR/install-mac.sh" \
           && grep -qx '$DefaultPart = "post"' "$DIR/install-windows.ps1" && grep -qx '$DefaultTag = "post"' "$DIR/install-windows.ps1" \
           || { echo "the installers' default lines were not found"; exit 1; } ;;
  *) echo "kit: suite or post"; exit 1 ;;
esac
ls -l "$DIR"
