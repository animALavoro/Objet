# Objet

Spatial audio plugins for REAPER, by Luca Bagetto: **Objet Pa** (multichannel and Ambisonics panner), **Objet a Scene** (the whole mix in one room, loudness), **Objet a Monitor** (binaural monitor, 360 view, headset) and **Objet a Master** (a script to manage every panner of a project). VST3, Windows and macOS (universal: Apple silicon and Intel, macOS 11 or later), REAPER 7.

This repository holds only the downloads: [Releases](https://github.com/animALavoro/Objet/releases). Italiano: [README.it.md](README.it.md).

## Install on macOS
Close REAPER, open the Terminal (Applications > Utilities > Terminal), paste this line and press Return:

```
curl -fsSL https://github.com/animALavoro/Objet/releases/latest/download/install-mac.sh | bash
```

It installs the three plugins in your own VST3 folder (`~/Library/Audio/Plug-Ins/VST3`) and the Objet a Master script in REAPER's Scripts folder. No administrator password; older copies are replaced, so the same line also updates. Then open REAPER: *REAPER > Settings > Plug-ins > VST > Clear cache/re-scan*.

- One plugin only: end the line with `bash -s -- pa` (or `scene`, `monitor`, `master`) instead of `bash`.
- A given version: `bash -s -- all 2026.11.10`, or `bash -s -- pa v0.2.0` for a release of one plugin.
- Objet a Master, once: *Actions > Show action list > New action > Load ReaScript*, choose `LB_Objet_Master.lua` (it needs ReaImGui, from ReaPack).

**Why the Terminal**: the plugins have no Apple developer signature (an ad-hoc one), so macOS blocks them if they were downloaded with a browser. Files downloaded by the Terminal are not blocked. If you did download a zip with the browser, copy the `.vst3` to `~/Library/Audio/Plug-Ins/VST3/` and unblock it before the re-scan, for example:

```
xattr -dr com.apple.quarantine ~/Library/Audio/Plug-Ins/VST3/"LB Spanner.vst3"
```

(`Objet a Scene.vst3`, `Objet a Monitor.vst3` for the others).

If REAPER is already stuck at startup on *"LB Spanner.vst3" Not Opened. Apple could not verify "LB Spanner.vst3" is free of malware…*, the message comes back every time you press **Done** and REAPER does not open. Leave it there, run the line above in the Terminal, then press **Done** once: REAPER opens and loads the plugin.

## Install on Windows
From the latest release, unzip each `*-Windows.zip` and copy the `.vst3` folder to `C:\Program Files\Common Files\VST3\`. For Objet a Master, load `LB_Objet_Master.lua` from `Objet-a-Master.zip` as above. Then *Clear cache/re-scan* in REAPER.

Objet Pa's file is `LB Spanner.vst3` (REAPER lists it as *Objet Pa*): the old name stays so that saved projects find it.

## Making a release (maintainer)
*Actions > Release > Run workflow*: choose `all` (the suite) or one plugin, a version and, if needed, the branch or tag of each source repository. The workflow builds Windows and macOS from the private repositories, signs the macOS bundles ad hoc and publishes the release. Leave *latest* off to try it first:

```
curl -fsSL https://github.com/animALavoro/Objet/releases/download/suite-VERSION/install-mac.sh | bash -s -- all VERSION
```

then *Edit release > Set as latest release*: from then on the install line above gives it to everyone. The source is read with the `SOURCE_TOKEN` secret (fine-grained token, contents read-only on the four source repositories, to renew before it expires).
