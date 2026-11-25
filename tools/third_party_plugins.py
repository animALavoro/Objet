#!/usr/bin/env python3
"""Builds third-party-plugins.txt: free plugins by other authors, downloaded from their own GitHub releases.

Run by the Release workflow (post-production kit) with GH_TOKEN set: it asks GitHub for each plugin's latest release
and writes the download URL of each platform's file. Nothing is redistributed here: the installers download the
author's own file and install it. The installers choose the line for the computer they run on.
Line format:  platform <TAB> name <TAB> kind <TAB> URL <TAB> minimum macOS major version (0 = any)
platform: win64 (x86-64), win64-avx2 (x86-64 with AVX2: preferred when the processor has it), winarm64,
          darwin-arm64 (Apple silicon), darwin64 (Intel Mac)
kind:     msi (Windows installer, run silently), zip (Windows, .vst3 folders inside), dmg (macOS, .vst3 bundles or a
          .pkg with them inside: the bundles are copied to the user's VST3 folder, no password)
"""
import json
import os
import re
import sys
import urllib.request

ZL = [("win64", r"-Windows-x86-64\.msi$", "msi"), ("win64-avx2", r"-Windows-x86-64-AVX2\.msi$", "msi"),
      ("winarm64", r"-Windows-arm64\.msi$", "msi"),
      ("darwin-arm64", r"-macOS-arm64\.dmg$", "dmg"), ("darwin64", r"-macOS-x86-64\.dmg$", "dmg")]
# (GitHub repository, name shown, files, minimum macOS major version)
PLUGINS = [
    ("ZL-Audio/ZLEqualizer", "ZL Equalizer 2", ZL, 12),
    ("ZL-Audio/ZLCompressor", "ZL Compressor", ZL, 12),
    ("ZL-Audio/ZLLimiter", "ZL Limiter", ZL, 12),
    ("michaelwillis/dragonfly-reverb", "Dragonfly Reverb",
     [("win64", r"-win64\.zip$", "zip"), ("darwin-arm64", r"-macos-universal\.dmg$", "dmg"),
      ("darwin64", r"-macos-universal\.dmg$", "dmg")], 0),
]
REQUIRED = {"win64", "darwin-arm64", "darwin64"}     # every plugin must have these


def latest(repo):
    req = urllib.request.Request(f"https://api.github.com/repos/{repo}/releases/latest",
                                 headers={"Accept": "application/vnd.github+json", "User-Agent": "objet-release"})
    token = os.environ.get("GH_TOKEN") or os.environ.get("GITHUB_TOKEN")
    if token:
        req.add_header("Authorization", f"Bearer {token}")
    with urllib.request.urlopen(req, timeout=60) as r:
        return json.load(r)


def main():
    lines = []
    for repo, name, files, minmac in PLUGINS:
        rel = latest(repo)
        assets = {a["name"]: a["browser_download_url"] for a in rel.get("assets", [])}
        found = set()
        for plat, pattern, kind in files:
            hit = [u for n, u in assets.items() if re.search(pattern, n)]
            if len(hit) > 1:
                raise SystemExit(f"{name}: more than one file for {plat}: {hit}")
            if hit:
                found.add(plat)
                lines.append("\t".join([plat, name, kind, hit[0], str(minmac if plat.startswith("darwin") else 0)]))
        missing = REQUIRED - found
        if missing:
            raise SystemExit(f"{name} {rel.get('tag_name')}: no file for {sorted(missing)} in {sorted(assets)}")
        print(f"{name} {rel.get('tag_name')}: {sorted(found)}", file=sys.stderr)
    out = sys.argv[1] if len(sys.argv) > 1 else "third-party-plugins.txt"
    with open(out, "w", newline="\n") as f:
        f.write("\n".join(lines) + "\n")
    print(open(out).read(), file=sys.stderr)


if __name__ == "__main__":
    main()
