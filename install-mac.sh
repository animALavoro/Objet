#!/bin/bash
# Objet suite - installer for macOS.
#   curl -fsSL https://github.com/animALavoro/Objet/releases/latest/download/install-mac.sh | bash
#   ... | bash -s -- pa            only Objet Pa (also: scene, monitor, master)
#   ... | bash -s -- pa v0.2.0     a release of one plugin (tag pa-v0.2.0)
# Downloads with curl (no quarantine flag), installs in the user's own folders: no administrator password.
set -euo pipefail

REPO="animALavoro/Objet"
WHAT="${1:-all}"
VERSION="${2:-}"
VST3="$HOME/Library/Audio/Plug-Ins/VST3"
SCRIPTS="$HOME/Library/Application Support/REAPER/Scripts/Objet a Master"

[ "$(uname -s)" = "Darwin" ] || { echo "This installer is for macOS."; exit 1; }

case "$WHAT" in
  all|pa|scene|monitor|master) ;;
  *) echo "Unknown plugin '$WHAT': use all, pa, scene, monitor or master."; exit 1 ;;
esac

if [ -n "$VERSION" ]; then
  if [ "$WHAT" = all ]; then TAG="suite-$VERSION"; else TAG="$WHAT-$VERSION"; fi
  BASE="https://github.com/$REPO/releases/download/$TAG"
else
  BASE="https://github.com/$REPO/releases/latest/download"
fi

if pgrep -xq REAPER; then
  echo "REAPER is open: close it (REAPER > Quit REAPER) and run this line again."
  exit 1
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$VST3"

# zip name, bundle inside the zip, name shown
plugin() {
  local zip="$1" bundle="$2" name="$3"
  echo "- $name"
  curl -fL --retry 3 --progress-bar -o "$TMP/$zip" "$BASE/$zip" || { echo "  download failed: $BASE/$zip"; exit 1; }
  rm -rf "$TMP/x" && mkdir "$TMP/x"
  ditto -x -k "$TMP/$zip" "$TMP/x"
  [ -d "$TMP/x/$bundle" ] || { echo "  $bundle not found in $zip"; exit 1; }
  rm -rf "$VST3/$bundle"
  ditto "$TMP/x/$bundle" "$VST3/$bundle"
  xattr -dr com.apple.quarantine "$VST3/$bundle" 2>/dev/null || true
  echo "  installed in $VST3/$bundle"
}

master() {
  echo "- Objet a Master (script)"
  curl -fL --retry 3 --progress-bar -o "$TMP/master.zip" "$BASE/Objet-a-Master.zip" || { echo "  download failed: $BASE/Objet-a-Master.zip"; exit 1; }
  mkdir -p "$SCRIPTS"
  ditto -x -k "$TMP/master.zip" "$SCRIPTS"
  xattr -dr com.apple.quarantine "$SCRIPTS" 2>/dev/null || true
  echo "  installed in $SCRIPTS"
  echo "  once: REAPER > Actions > Show action list > New action > Load ReaScript > LB_Objet_Master.lua (needs ReaImGui from ReaPack)"
}

echo "Objet suite: installing from $BASE"
case "$WHAT" in
  all)     plugin Objet-Pa-macOS.zip "LB Spanner.vst3" "Objet Pa"
           plugin Objet-a-Scene-macOS.zip "Objet a Scene.vst3" "Objet a Scene"
           plugin Objet-a-Monitor-macOS.zip "Objet a Monitor.vst3" "Objet a Monitor"
           master ;;
  pa)      plugin Objet-Pa-macOS.zip "LB Spanner.vst3" "Objet Pa" ;;
  scene)   plugin Objet-a-Scene-macOS.zip "Objet a Scene.vst3" "Objet a Scene" ;;
  monitor) plugin Objet-a-Monitor-macOS.zip "Objet a Monitor.vst3" "Objet a Monitor" ;;
  master)  master ;;
esac

echo
echo "Done. Open REAPER: Preferences > Plug-ins > VST > Clear cache/re-scan."
