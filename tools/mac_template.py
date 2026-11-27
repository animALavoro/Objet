#!/usr/bin/env python3
"""Makes the macOS copy of a REAPER project template saved on Windows: tools/mac_template.py IN.rpp OUT.rpp

Dragonfly Reverb (DPF plugins) has a different VST3 class ID on Windows and on macOS: on macOS the first two groups
of four characters are reversed ("DPF ascl2rfd" on Windows, " FPDsalc2rfd" on macOS). REAPER finds a VST3 plugin by
its ID, so a project saved on Windows does not find Dragonfly on a Mac. This copies the template with the macOS IDs
(the number before the ID is REAPER's own for that ID: from REAPER's VST list on a Mac, Kit test (Mac) prints it in
vstplugins.txt). The plugins' settings are not touched. The template must be saved on Windows.
"""
import re
import sys

# Windows ID -> (REAPER's number on macOS, macOS ID); Dragonfly Reverb 3.2.10
MAC = {
    "445046206173636C3172666400000000": ("285855749", "2046504473616C633172666400000000"),   # Hall
    "445046206173636C3272666400000000": ("1799451474", "2046504473616C633272666400000000"),  # Room
    "445046206173636C3370666400000000": ("1064330909", "2046504473616C633370666400000000"),  # Plate
    "445046206173636C7265666400000000": ("1977795447", "2046504473616C637265666400000000"),  # Early Reflections
}


def main():
    src, out = sys.argv[1], sys.argv[2]
    data = open(src, "rb").read().decode("utf-8")
    n = 0

    def swap(m):
        nonlocal n
        num, guid = MAC[m.group(2).upper()]
        n += 1
        return f"{m.group(1)}{num}{{{guid}}}"

    data = re.sub(r'(<VST "VST3: [^"]*" \S+ \d+ "[^"]*" )-?\d+\{(' + "|".join(MAC) + r')\}', swap, data,
                  flags=re.IGNORECASE)
    if re.search(r"\{445046206173636C[0-9A-F]{16}\}", data, re.IGNORECASE):
        raise SystemExit(f"{src}: a DPF plugin with a Windows ID not in the table (another Dragonfly?)")
    if re.search(r"\{2046504473616C63[0-9A-F]{16}\}", data, re.IGNORECASE) and n == 0:
        raise SystemExit(f"{src}: already has macOS IDs: save the template on Windows")
    open(out, "wb").write(data.encode("utf-8"))
    print(f"{out}: {n} Dragonfly plugins with their macOS ID", file=sys.stderr)


if __name__ == "__main__":
    main()
