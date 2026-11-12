# Objet: a guide for students

*Italiano: [guida.md](guida.md)*

Objet is a set of tools for immersive sound in REAPER: a multichannel and Ambisonics panner that can also be controlled on the video, a view of the whole scene with loudness measurement, a binaural monitor for headphones, and an app that brings timelines edited in Resolve into REAPER.

**Contents**
1. [What is in the suite](#1-what-is-in-the-suite)
2. [What you need](#2-what-you-need)
3. [Installing REAPER](#3-installing-reaper)
4. [Installing Objet](#4-installing-objet)
5. [The course's REAPER configuration and extensions](#5-the-courses-reaper-configuration-and-extensions)
6. [First steps](#6-first-steps)
7. [From a Resolve timeline to REAPER (OTIO to RPP)](#7-from-a-resolve-timeline-to-reaper-otio-to-rpp)
8. [Updating and uninstalling](#8-updating-and-uninstalling)
9. [Common problems](#9-common-problems)

---

## 1. What is in the suite

| Tool | What it is | Where it goes |
|---|---|---|
| **Objet Pa** | Panner: places the channels of a track (mono to 9.1.6) in a speaker room up to 9.1.6 or in Ambisonics up to 5th order. Controlled with the mouse, from an iPad (built-in web app) and by dragging pucks right on the video. | On every track to place |
| **Objet a Scene** | Every panner of the project in one room or globe, loudness (EBU R 128), energy map, changes on many panners at once (PROJECT page). | Once, on the master |
| **Objet a Monitor** | Headphone (binaural) listening of what the master plays, 360 view of the video, headset. | Once, on the master (after Scene) |
| **OTIO to RPP** | An app that turns a timeline exported from Resolve (`.otio`) into a REAPER project (`.rpp`). | A separate app |

The three plugins are VST3 and run in REAPER on Windows and macOS.

## 2. What you need

- A computer with **Windows 10 / 11 (64-bit)** or **macOS 11 or later** (Apple silicon or Intel; the OTIO to RPP app for Mac needs Apple silicon).
- **REAPER 7** (see chapter 3).
- **Headphones** for binaural listening with Objet a Monitor.
- Optional: an **iPad** (or another tablet / phone) on the same Wi-Fi network to control the panner; a **headset** for Objet a Monitor (it also needs `adb`, see Monitor's README).

## 3. Installing REAPER

1. Download REAPER from **reaper.fm** → *Download* (Windows 64-bit, or the universal macOS version).
2. Install it like any program (on a Mac: open the `.dmg` and drag REAPER to Applications).
3. REAPER can be evaluated for 60 days with every function. After that it needs a licence; there is a discounted licence for personal use and students (see reaper.fm).
4. Open it once and quit (*File > Quit* on Windows, *REAPER > Quit REAPER* on a Mac): REAPER then creates its folders.

## 4. Installing Objet

One line installs everything, always with **REAPER closed**. The same line also updates.

### macOS
1. Open **Terminal** (Applications > Utilities > Terminal).
2. Paste this line and press Return:
   ```
   curl -fsSL https://github.com/animALavoro/Objet/releases/latest/download/install-mac.sh | bash
   ```
3. It installs the three plugins in `~/Library/Audio/Plug-Ins/VST3`, the *OTIO to RPP* app in your own Applications folder (Finder > Go > Home > Applications) and the REAPER extensions **ReaPack** and **ReaImGui**. No password needed.
4. Open REAPER: *REAPER > Settings > Plug-ins > VST* → **Clear cache/re-scan**.

**Why the Terminal?** The plugins have no Apple developer signature: if you download them with a browser, macOS blocks them. Files downloaded by the Terminal open normally. If you already downloaded a zip with a browser and REAPER shows *"… Not Opened. Apple could not verify …"* at startup (the message comes back every time you press **Done**), leave it there, open Terminal and run:
```
xattr -dr com.apple.quarantine ~/Library/Audio/Plug-Ins/VST3/"LB Spanner.vst3"
```
(for the others: `Objet a Scene.vst3`, `Objet a Monitor.vst3`), then press **Done** once.

### Windows
1. Open **PowerShell** (Windows key, type *PowerShell*, Enter).
2. Paste this line and press Enter:
   ```
   irm https://github.com/animALavoro/Objet/releases/latest/download/install-windows.ps1 | iex
   ```
3. Windows asks once for permission to make changes: answer **Yes**. The plugins go to `C:\Program Files\Common Files\VST3`, the *OTIO to RPP* app to the Start menu, the **ReaPack** and **ReaImGui** extensions to REAPER's folder.
   If you answer No, the plugins go to your user folder and the script tells you which path to add in REAPER.
4. Open REAPER: *Options > Preferences > Plug-ins > VST* → **Clear cache/re-scan**.

### Check
On a track: **FX** → search *Objet*. **Objet Pa**, **Objet a Scene** and **Objet a Monitor** must be there. Objet Pa's file is `LB Spanner.vst3` (its old name, kept so that saved projects find it).

## 5. The course's REAPER configuration and extensions

The course uses a prepared REAPER configuration (settings, shortcuts, look). Import it once, after installing:

1. Download the configuration file from the [releases page](https://github.com/animALavoro/Objet/releases/latest) (*Objet-REAPER-config.ReaperConfigZip*).
2. In REAPER: *Options > Preferences* (Windows) or *REAPER > Settings* (Mac) → **General** → **Import configuration…** → choose the file.
3. REAPER asks to restart: confirm.

Importing replaces your current REAPER settings: if you already use REAPER for other work, first save yours with **Export configuration…** on the same page.

The course's project templates are given to you separately by the teacher.

### Extensions (ReaPack, SWS, pie menu, NVK Search)
The installer already puts **ReaPack** (REAPER's package manager) and **ReaImGui** (needed by many scripts) in REAPER. The rest is installed from ReaPack, once:

1. In REAPER: *Extensions > ReaPack > Browse packages…*
2. Find and install (right-click the package → *Install*, then **Apply**):
   - **SWS/S&M extension** (extra actions and functions used in the course);
   - **Pie3000** (the radial "pie" menu);
   - **nvk_SEARCH** (fast search of actions, FX, tracks and media).
3. Restart REAPER.

If a package does not show up, its repository is not in ReaPack yet: *Extensions > ReaPack > Import repositories…* and paste the address given by the teacher.

## 6. First steps

### Track channels
A REAPER track has 2 channels unless you change it. Objet Pa needs as many channels as the larger of its input and output format: **6** for 5.1, **12** for 7.1.4, **16** for 9.1.6 or 3rd-order Ambisonics, **36** for 5th order. Set it with the track's **ROUTE** button (*Track channels*). The master needs the channels of the output format too.

### Objet Pa on a track
1. On the track: **FX** → **Objet Pa**.
2. At the top choose the **input** (the format of the track's sound: mono, stereo, 5.1…) and the **output** (the master's format: 5.1, 7.1.4, HOA…).
3. Drag the **pucks** in the field to move the channels; the **Bed** controls (Pan, Front-Back, Height, Width, Rotate…) move everything together.
4. Parameter automation is written as with any REAPER plugin; the **Paths** window draws movements and writes them as automation.

### Pucks on the video
1. Open REAPER's video window (*View > Video*).
2. In Objet Pa: **Setup** page → switch on **Video overlay** (or the **Video** button at the top).
3. The selected track's pucks appear on the video and can be dragged there: left to right in channel formats, over the whole 360 in Ambisonics (the video is taken as equirectangular).
4. In Ambisonics, Setup can also show the **energy map**: where the sound's energy is, under the pucks.

### Scene and Monitor on the master
1. On the master: **FX** → **Objet a Scene**, then **Objet a Monitor** (in this order).
2. **Scene** shows every panner of the project in the room (or the globe, in Ambisonics), measures loudness and, on the **PROJECT** page, changes formats and settings of many panners at once.
3. **Monitor** sends the output to headphones (*Output > Binaural*). With a 360 video: **Add 360 view** in Monitor, then drag on the video to look around (mouse wheel = zoom); the scene turns with you.

### From an iPad
In Objet Pa: **Setup** → **Web remote** → scan the **QR code** with the iPad (same Wi-Fi network as the computer). An app opens in the browser and follows the track selected in REAPER. The first time the computer may ask to let REAPER use the network: allow it for private networks.

## 7. From a Resolve timeline to REAPER (OTIO to RPP)

1. In Resolve: *File > Export > Timeline…* → **OpenTimelineIO** (`.otio`), or an `.otioz` bundle with the media inside.
2. Open **OTIO to RPP** (Mac: your own Applications; Windows: Start menu).
3. **OTIO file**: the exported file. **Reaper project**: where to save the `.rpp` (same name proposed).
4. **Look for media in** (optional): if the audio files are no longer where they were during editing, the app looks for them by name in this folder.
5. With **Copy media to the "Media" folder** (on by default) the files used are copied next to the project: the project folder can be moved or taken to another computer.
6. **Convert**, then **Open in Reaper**.

Converted: audio tracks, clips (position, length, offset), disabled clips, linear speed changes, dissolves and the start timecode. Not converted: video, markers, compound clips, clip volume / pan, channel mapping; they are listed in the message box.

## 8. Updating and uninstalling

- **Update**: run the same line of chapter 4 again, with REAPER closed.
- **Uninstall on a Mac**: delete `LB Spanner.vst3`, `Objet a Scene.vst3`, `Objet a Monitor.vst3` from `~/Library/Audio/Plug-Ins/VST3` and *OTIO to RPP* from your own Applications.
- **Uninstall on Windows**: delete the three `.vst3` folders from `C:\Program Files\Common Files\VST3`, the folder `%LOCALAPPDATA%\Programs\OTIO to RPP` and the Start menu shortcut.

## 9. Common problems

| Problem | Solution |
|---|---|
| REAPER does not find the plugins | Was REAPER closed during the install? Then *Plug-ins > VST* → **Clear cache/re-scan**. On Windows, if you answered No to the permission request, add the path the script printed. |
| "REAPER is open" | Quit REAPER from the menu (*Quit*), not just its window, and run the line again. |
| Mac: "… Not Opened. Apple could not verify …" | See chapter 4, macOS: the `xattr` command, then **Done**. |
| No sound or missing channels | Check the channels of the track and of the master (chapter 6). |
| No pucks on the video | Video window open (*View > Video*), **Video overlay** on in Setup, the track with Objet Pa selected, REAPER in front. Setup's status line says whether the video window was found. |
| The iPad does not connect | Same Wi-Fi network; network permission for REAPER; open the QR code again. |
| The Windows line fails with an execution policy error | In PowerShell first run `Set-ExecutionPolicy -Scope Process Bypass`, then the line. |

For anything else: ask the teacher, with your operating system, REAPER version and the exact error message.
