# Objet

Spatial audio tools for REAPER, by Luca Bagetto: **Objet Pa** (multichannel and Ambisonics panner, with pucks on the video), **Objet a Scene** (the whole mix in one room or globe, loudness, changes on many panners at once), **Objet a Monitor** (binaural monitor, 360 view, headset) and **OTIO to RPP** (an app that turns a Resolve timeline into a REAPER project) and **Polywav Manager** (a REAPER script that puts the mono files of the recorder's polywav files each on its own track). VST3 for REAPER 7 on Windows and macOS (universal: Apple silicon and Intel, macOS 11 or later).

**Guide for students: [English](docs/guide.md) · [Italiano](docs/guida.md)**

This repository holds only the downloads: [Releases](https://github.com/animALavoro/Objet/releases). Italiano: [README.it.md](README.it.md).

## Install
Close REAPER first. The same line also updates.

**macOS** (Terminal: Applications > Utilities > Terminal):
```
curl -fsSL https://github.com/animALavoro/Objet/releases/latest/download/install-mac.sh | bash
```
**Windows** (PowerShell):
```
irm https://github.com/animALavoro/Objet/releases/latest/download/install-windows.ps1 | iex
```
Both install the three plugins, the OTIO to RPP app, the Polywav Manager script and the course's REAPER extensions and scripts (ReaPack, SWS, js_ReaScriptAPI, ReaImGui, Pie3000, nvk_SEARCH, downloaded from their own sources), from the latest release. On Windows, Windows asks once for permission (the plugins go to `C:\Program Files\Common Files\VST3`). Then in REAPER: *Plug-ins > VST > Clear cache/re-scan*. The guide has the details and the course's REAPER configuration.

- **Only the three plugins** (no app, no extensions):
  - macOS: `curl -fsSL https://github.com/animALavoro/Objet/releases/latest/download/install-mac.sh | bash -s -- plugins`
  - Windows: `& ([scriptblock]::Create((irm https://github.com/animALavoro/Objet/releases/latest/download/install-windows.ps1))) plugins`
- One part only: `pa`, `scene`, `monitor`, `otio`, `polywav` or `ext` (REAPER extensions and scripts) in place of `plugins`.
- A given version: add it after the part, e.g. `bash -s -- all 2026.11.12-mac3`.

**macOS, downloaded with a browser**: the plugins have an ad-hoc signature (no Apple developer account), so macOS blocks a downloaded copy. Copy the `.vst3` to `~/Library/Audio/Plug-Ins/VST3/` and unblock it in the Terminal, e.g. `xattr -dr com.apple.quarantine ~/Library/Audio/Plug-Ins/VST3/"LB Spanner.vst3"`. If REAPER is already stuck at startup on *"… Not Opened. Apple could not verify …"* (the message comes back at every **Done**), run that line while it is showing, then press **Done** once.

Objet Pa's file is `LB Spanner.vst3` (REAPER lists it as *Objet Pa*): the old name stays so that saved projects find it.

## Post-production course
The short-film post-production course has its own kit: OTIO to RPP, Polywav Manager, the Objet a Loudness meter, some free plugins by other authors (ZL Equalizer 2, ZL Compressor, ZL Limiter, Dragonfly Reverb: downloaded from their authors' releases, the right build for the processor; on a Mac the ZL plugins need macOS 12 or later), the REAPER extensions and scripts above and its REAPER configuration (*Post_Produzione.ReaperConfigZip*, for now the same as the immersive course's), none of the three spatial plugins. Its own line, REAPER closed:

- **macOS**: `curl -fsSL https://github.com/animALavoro/Objet/releases/download/post/install-mac.sh | bash`
- **Windows**: `irm https://github.com/animALavoro/Objet/releases/download/post/install-windows.ps1 | iex`

**Guide: [English](docs/post/guide.md) · [Italiano](docs/post/guida.md)**. The kit is in the release [post](https://github.com/animALavoro/Objet/releases/tag/post), always a pre-release, so that the suite stays the latest release.

## Making a release (maintainer)
*Actions > Release > Run workflow*: choose `all` (the suite) or one part, a version and, if needed, the branch or tag of each source repository. The workflow builds Windows and macOS from the private repositories, signs the macOS bundles ad hoc and publishes the release. Leave *latest* off to try it first (it comes out as a pre-release, which the install line does not pick):

```
curl -fsSL https://github.com/animALavoro/Objet/releases/download/suite-VERSION/install-mac.sh | bash -s -- all VERSION
```

then *Edit release*: untick *Set as a pre-release*, tick *Set as the latest release*, *Update release*: from then on the install line gives it to everyone. *publish* off builds and tests only. The source is read with the `SOURCE_TOKEN` secret (fine-grained token, contents read-only on the source repositories, to renew before it expires). *Actions > Mac overlay test* checks Objet Pa's video overlay in REAPER on a CI Mac (screenshots on the `ci-shots` branch).

**Post-production kit**: *Actions > Release* with `post` makes the pre-release `post-VERSION` (Objet a Loudness only with `loudness_ref` set, otherwise the kit goes without it; the links to the latest releases of the plugins by other authors go in `third-party-plugins.txt`, made by `tools/third_party_plugins.py` and remade by the Refresh too); with *latest* ticked its files also go to the release `post`, the one the course's line uses. To try it first, leave *latest* off: `curl -fsSL https://github.com/animALavoro/Objet/releases/download/post-VERSION/install-mac.sh | bash -s -- post VERSION`, then *Actions > Refresh REAPER packages list* with `tag` = `post-VERSION` and *promote_post* on. The kit's REAPER configuration is `kit/post/` (for now a copy of the immersive course's). *Kit test (Mac)* and *Kit test (Windows)* take `kit` = `post`.
