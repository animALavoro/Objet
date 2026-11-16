#!/usr/bin/env python3
"""Builds reaper-packages.txt: the files of some ReaPack packages, where ReaPack would put them.

Run by the Release workflow. The installers read the list and download each file from its original source
(nothing is redistributed here), into REAPER's resource folder, for the student's platform.
Line format:  platform <TAB> path in REAPER's resource folder <TAB> URL
platform: win64, darwin-arm64, darwin64, or * (all).
"""
import sys
import urllib.request
import xml.etree.ElementTree as ET

# (index URL, package name, skip data files of the package)
PACKAGES = [
    ("https://raw.githubusercontent.com/ReaTeam/Extensions/master/index.xml", "reaper-oss_SWS.ext", True),
    ("https://raw.githubusercontent.com/ReaTeam/Extensions/master/index.xml", "js_ReaScriptAPI.ext", True),
    ("https://raw.githubusercontent.com/ReaTeam/Extensions/master/index.xml", "reaper_imgui.ext", False),
    ("https://raw.githubusercontent.com/GoranKovac/ReaScripts/master/index.xml", "Sexan_Pie3000.lua", False),
    ("https://nvk.tools/index.xml", "nvk_SEARCH.lua", False),
]
PLATFORMS = ["win64", "darwin-arm64", "darwin64"]
GENERIC = {"all": PLATFORMS, "windows": ["win64"], "win64": ["win64"], "darwin": ["darwin-arm64", "darwin64"],
           "darwin64": ["darwin64"], "darwin-arm64": ["darwin-arm64"]}
TYPE_DIR = {"script": "Scripts", "effect": "Effects", "data": "Data", "theme": "ColorThemes",
            "langpack": "LangPack", "webinterface": "reaper_www_root", "projecttpl": "ProjectTemplates",
            "tracktpl": "TrackTemplates", "midinotenames": "MIDINoteNames", "autoitem": "AutomationItems"}


def norm(path):
    out = []
    for part in path.replace("\\", "/").split("/"):
        if part in ("", "."):
            continue
        if part == "..":
            if out:
                out.pop()
        else:
            out.append(part)
    return "/".join(out)


def files_of(index_url, name, skip_data, cache):
    if index_url not in cache:
        with urllib.request.urlopen(index_url, timeout=60) as r:
            cache[index_url] = ET.fromstring(r.read())
    root = cache[index_url]
    index_name = root.get("name")
    for cat in root.iter("category"):
        for pkg in cat.findall("reapack"):
            if pkg.get("name") != name:
                continue
            versions = pkg.findall("version")
            version = versions[-1]
            ptype = pkg.get("type")
            print(f"{name} {version.get('name')} ({index_name} / {cat.get('name')})", file=sys.stderr)
            for src in version.findall("source"):
                stype = src.get("type") or ptype
                if stype == "data" and skip_data:
                    continue
                plats = GENERIC.get(src.get("platform") or "all")
                if plats is None:            # linux, 32-bit
                    continue
                url = (src.text or "").strip()
                file = src.get("file") or url.rsplit("/", 1)[-1]
                if stype == "extension":
                    path = "UserPlugins/" + norm(file)
                elif stype == "script" or stype == "effect":
                    path = norm(f"{TYPE_DIR[stype]}/{index_name}/{cat.get('name')}/{file}")
                elif stype in TYPE_DIR:
                    path = norm(f"{TYPE_DIR[stype]}/{file}")
                else:
                    raise SystemExit(f"{name}: unknown type {stype}")
                for p in (["*"] if plats == PLATFORMS else plats):
                    yield p, path, url
            return
    raise SystemExit(f"package {name} not found in {index_url}")


def main():
    cache, lines = {}, []
    for index_url, name, skip in PACKAGES:
        lines += ["\t".join(f) for f in files_of(index_url, name, skip, cache)]
    out = sys.argv[1] if len(sys.argv) > 1 else "reaper-packages.txt"
    with open(out, "w", newline="\n") as f:
        f.write("\n".join(lines) + "\n")
    print(open(out).read(), file=sys.stderr)


if __name__ == "__main__":
    main()
