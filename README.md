# Objet

Spatial audio tools for REAPER, by Luca Bagetto: **Objet Pa** (multichannel and Ambisonics panner, with pucks on the video), **Objet a Scene** (the whole mix in one room or globe, loudness, changes on many panners at once), **Objet a Monitor** (binaural monitor, 360 view, headset) and **OTIO to RPP** (an app that turns a Resolve timeline into a REAPER project). VST3 for REAPER 7 on Windows and macOS (universal: Apple silicon and Intel, macOS 11 or later).

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
Both install the three plugins, the OTIO to RPP app and the REAPER extensions ReaPack and ReaImGui, from the latest release. On Windows, Windows asks once for permission (the plugins go to `C:\Program Files\Common Files\VST3`). Then in REAPER: *Plug-ins > VST > Clear cache/re-scan*. The guide has the details, the course's REAPER configuration and the extensions to add from ReaPack.

- **Only the three plugins** (no app, no extensions):
  - macOS: `curl -fsSL https://github.com/animALavoro/Objet/releases/latest/download/install-mac.sh | bash -s -- plugins`
  - Windows: `& ([scriptblock]::Create((irm https://github.com/animALavoro/Objet/releases/latest/download/install-windows.ps1))) plugins`
- One part only: `pa`, `scene`, `monitor`, `otio` or `ext` (ReaPack + ReaImGui) in place of `plugins`.
- A given version: add it after the part, e.g. `bash -s -- all 2026.11.12-mac3`.

**macOS, downloaded with a browser**: the plugins have an ad-hoc signature (no Apple developer account), so macOS blocks a downloaded copy. Copy the `.vst3` to `~/Library/Audio/Plug-Ins/VST3/` and unblock it in the Terminal, e.g. `xattr -dr com.apple.quarantine ~/Library/Audio/Plug-Ins/VST3/"LB Spanner.vst3"`. If REAPER is already stuck at startup on *"… Not Opened. Apple could not verify …"* (the message comes back at every **Done**), run that line while it is showing, then press **Done** once.

Objet Pa's file is `LB Spanner.vst3` (REAPER lists it as *Objet Pa*): the old name stays so that saved projects find it.

## Making a release (maintainer)
*Actions > Release > Run workflow*: choose `all` (the suite) or one part, a version and, if needed, the branch or tag of each source repository. The workflow builds Windows and macOS from the private repositories, signs the macOS bundles ad hoc and publishes the release. Leave *latest* off to try it first (it comes out as a pre-release, which the install line does not pick):

```
curl -fsSL https://github.com/animALavoro/Objet/releases/download/suite-VERSION/install-mac.sh | bash -s -- all VERSION
```

then *Edit release*: untick *Set as a pre-release*, tick *Set as the latest release*, *Update release*: from then on the install line gives it to everyone. *publish* off builds and tests only. The source is read with the `SOURCE_TOKEN` secret (fine-grained token, contents read-only on the source repositories, to renew before it expires). *Actions > Mac overlay test* checks Objet Pa's video overlay in REAPER on a CI Mac (screenshots on the `ci-shots` branch).
