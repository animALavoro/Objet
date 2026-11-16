#!/bin/bash
# Objet suite - installer for macOS.
#   curl -fsSL https://github.com/animALavoro/Objet/releases/latest/download/install-mac.sh | bash
#   ... | bash -s -- plugins       only the three plugins (Objet Pa, Objet a Scene, Objet a Monitor)
#   ... | bash -s -- pa            only Objet Pa (also: scene, monitor, otio, polywav = Polywav Manager script,
#                                  ext = ReaPack, SWS, js_ReaScriptAPI, ReaImGui, pie menu, nvk_SEARCH)
#   ... | bash -s -- pa v0.2.0     a release of one plugin (tag pa-v0.2.0)
# Downloads with curl (no quarantine flag), installs in the user's own folders: no administrator password.
set -euo pipefail

REPO="animALavoro/Objet"
WHAT="${1:-all}"
VERSION="${2:-}"
VST3="$HOME/Library/Audio/Plug-Ins/VST3"
APPS="$HOME/Applications"
RESOURCE="$HOME/Library/Application Support/REAPER"
SCRIPTS="$RESOURCE/Scripts"

[ "$(uname -s)" = "Darwin" ] || { echo "This installer is for macOS."; exit 1; }

case "$WHAT" in
  all|plugins|pa|scene|monitor|otio|polywav|ext) ;;
  *) echo "Unknown part '$WHAT': use all, plugins, pa, scene, monitor, otio, polywav or ext."; exit 1 ;;
esac

if [ -n "$VERSION" ]; then
  if [ "$WHAT" = all ] || [ "$WHAT" = plugins ]; then TAG="suite-$VERSION"; else TAG="$WHAT-$VERSION"; fi
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

otio() {
  echo "- OTIO to RPP (app)"
  curl -fL --retry 3 --progress-bar -o "$TMP/otio.zip" "$BASE/OTIO-to-RPP-macOS.zip" || { echo "  download failed: $BASE/OTIO-to-RPP-macOS.zip"; exit 1; }
  rm -rf "$TMP/o" && mkdir "$TMP/o"
  ditto -x -k "$TMP/otio.zip" "$TMP/o"
  mkdir -p "$APPS"
  rm -rf "$APPS/OTIO to RPP.app"
  ditto "$TMP/o/OTIO to RPP.app" "$APPS/OTIO to RPP.app"
  xattr -dr com.apple.quarantine "$APPS/OTIO to RPP.app" 2>/dev/null || true
  echo "  installed in $APPS/OTIO to RPP.app (Finder > Go > Home > Applications)"
}

# the Polywav Manager script, in REAPER's Scripts folder (registered as an action by the course configuration)
polywav() {
  echo "- Polywav Manager (script)"
  curl -fL --retry 3 --progress-bar -o "$TMP/polywav.zip" "$BASE/Polywav-Manager.zip" || { echo "  download failed: $BASE/Polywav-Manager.zip"; exit 1; }
  rm -rf "$TMP/p" && mkdir "$TMP/p"
  ditto -x -k "$TMP/polywav.zip" "$TMP/p"
  [ -f "$TMP/p/Polywav Manager/Polywav Manager.lua" ] || { echo "  Polywav Manager.lua not found in the zip"; exit 1; }
  mkdir -p "$SCRIPTS"
  rm -rf "$SCRIPTS/Polywav Manager"
  ditto "$TMP/p/Polywav Manager" "$SCRIPTS/Polywav Manager"
  echo "  installed in $SCRIPTS/Polywav Manager (action list: Polywav Manager)"
}

# REAPER extensions and scripts, from their own sources (not from this repository): ReaPack (from its releases), then
# the files listed in reaper-packages.txt (made at release time from the ReaPack indexes: SWS, js_ReaScriptAPI,
# ReaImGui, the pie menu, nvk_SEARCH), in the same places where ReaPack puts them
ext() {
  local arch plat; arch=$(uname -m)
  if [ "$arch" = arm64 ]; then plat=darwin-arm64; else arch=x86_64; plat=darwin64; fi
  mkdir -p "$RESOURCE/UserPlugins"
  local rp="$RESOURCE/UserPlugins/reaper_reapack-$arch.dylib"
  echo "- ReaPack ($arch)"
  curl -fsSL --retry 3 -o "$rp.part" "https://github.com/cfillion/reapack/releases/latest/download/reaper_reapack-$arch.dylib" \
    && mv "$rp.part" "$rp" || { rm -f "$rp.part"; echo "  download failed: ReaPack"; exit 1; }
  curl -fsSL --retry 3 -o "$TMP/packages.txt" "$BASE/reaper-packages.txt" || { echo "  download failed: $BASE/reaper-packages.txt"; exit 1; }
  echo "- SWS, js_ReaScriptAPI, ReaImGui, pie menu (Pie3000), nvk_SEARCH"
  local p path url n=0
  while IFS=$'\t' read -r p path url; do
    [ -n "$url" ] || continue
    [ "$p" = "*" ] || [ "$p" = "$plat" ] || continue
    mkdir -p "$(dirname "$RESOURCE/$path")"
    curl -fsSL --retry 3 -o "$RESOURCE/$path.part" "$url" && mv "$RESOURCE/$path.part" "$RESOURCE/$path" \
      || { rm -f "$RESOURCE/$path.part"; echo "  download failed: $url"; exit 1; }
    xattr -d com.apple.quarantine "$RESOURCE/$path" 2>/dev/null || true
    n=$((n + 1))
  done < "$TMP/packages.txt"
  echo "  $n files installed in $RESOURCE"
}

echo "Objet suite: installing from $BASE"
case "$WHAT" in
  all)     plugin Objet-Pa-macOS.zip "LB Spanner.vst3" "Objet Pa"
           plugin Objet-a-Scene-macOS.zip "Objet a Scene.vst3" "Objet a Scene"
           plugin Objet-a-Monitor-macOS.zip "Objet a Monitor.vst3" "Objet a Monitor"
           otio
           polywav
           ext ;;
  plugins) plugin Objet-Pa-macOS.zip "LB Spanner.vst3" "Objet Pa"
           plugin Objet-a-Scene-macOS.zip "Objet a Scene.vst3" "Objet a Scene"
           plugin Objet-a-Monitor-macOS.zip "Objet a Monitor.vst3" "Objet a Monitor" ;;
  pa)      plugin Objet-Pa-macOS.zip "LB Spanner.vst3" "Objet Pa" ;;
  scene)   plugin Objet-a-Scene-macOS.zip "Objet a Scene.vst3" "Objet a Scene" ;;
  monitor) plugin Objet-a-Monitor-macOS.zip "Objet a Monitor.vst3" "Objet a Monitor" ;;
  otio)    otio ;;
  polywav) polywav ;;
  ext)     ext ;;
esac

echo
echo "Done. Open REAPER: REAPER > Settings > Plug-ins > VST > Clear cache/re-scan."
