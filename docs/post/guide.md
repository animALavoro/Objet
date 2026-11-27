# Objet, post-production course: guide for students

*Italiano: [guida.md](guida.md)*

The kit of the short-film post-production course: the tools to bring into REAPER the edit made in Resolve, sort out the recorder's files and measure the loudness of the mix, with the course's REAPER configuration.

**Contents**
1. [What is in the kit](#1-what-is-in-the-kit)
2. [What you need](#2-what-you-need)
3. [Installing REAPER](#3-installing-reaper)
4. [Installing the kit](#4-installing-the-kit)
5. [The course's REAPER configuration and extensions](#5-the-courses-reaper-configuration-and-extensions)
6. [From the Resolve timeline to REAPER (OTIO to RPP)](#6-from-the-resolve-timeline-to-reaper-otio-to-rpp)
7. [Splitting the recorder's polywav files (Polywav Manager)](#7-splitting-the-recorders-polywav-files-polywav-manager)
8. [Measuring loudness (Objet a Loudness)](#8-measuring-loudness-objet-a-loudness)
9. [Updating and uninstalling](#9-updating-and-uninstalling)
10. [Common problems](#10-common-problems)

---

## 1. What is in the kit

| Tool | What it is | Where it goes |
|---|---|---|
| **OTIO to RPP** | An app that converts a timeline exported from Resolve (`.otio`) into a REAPER project (`.rpp`). | A separate app |
| **Polywav Manager** | A REAPER script: puts the mono file of each channel of the recorder's polywav files on its own track. | REAPER's action list |
| **Objet a Loudness** | A loudness meter (VST3). | On the master |
| **ZL Equalizer 2, ZL Compressor, ZL Limiter** | Equalizer, compressor and limiter (VST3, free, by ZL Audio). | On tracks and the master |
| **Dragonfly Reverb** | Hall, Room, Plate and Early Reflections reverbs (VST3, free). | On tracks or buses |
| **Project template** | The short film's mix tracks, buses and routing, ready. | *File > Project templates* |
| **The course configuration** | Shortcuts, pie menu, project settings, ReaPack repositories. | Imported into REAPER once |

## 2. What you need

- A computer with **Windows 10 / 11 (64-bit)** or **macOS 11 or later** (Apple silicon or Intel; the OTIO to RPP app for Mac needs Apple silicon).
- **REAPER 7** (chapter 3).
- **Headphones** or speakers to listen.

## 3. Installing REAPER

1. Download REAPER from **reaper.fm** → *Download* (Windows 64-bit, or the universal macOS version).
2. Install it like any program (on a Mac: open the `.dmg` and drag REAPER to Applications).
3. REAPER can be evaluated for 60 days with every function. After that it needs a licence; there is a discounted licence for personal use and students (see reaper.fm).
4. Open it once and quit (*File > Quit* on Windows, *REAPER > Quit REAPER* on a Mac): REAPER then creates its folders.

## 4. Installing the kit

One line installs everything, always with **REAPER closed**. The same line also updates.

### macOS
1. Open **Terminal** (Applications > Utilities > Terminal).
2. Paste this line and press Return:
   ```
   curl -fsSL https://github.com/animALavoro/Objet/releases/download/post/install-mac.sh | bash
   ```
3. It installs the *OTIO to RPP* app in your own Applications folder (Finder > Go > Home > Applications), the *Polywav Manager* script in REAPER's Scripts folder, *Objet a Loudness*, ZL Equalizer 2, ZL Compressor, ZL Limiter and Dragonfly Reverb in `~/Library/Audio/Plug-Ins/VST3` and the course's REAPER extensions and scripts (**ReaPack**, **SWS**, **js_ReaScriptAPI**, **ReaImGui**, pie menu, nvk_SEARCH, chapter 5). No password needed.

**Why the Terminal?** The kit's app and plugin have no Apple developer signature: downloaded with a browser, macOS blocks them. Downloaded from the Terminal, they open normally.

### Windows
1. Open **PowerShell** (Windows key, type *PowerShell*, Enter).
2. Paste this line and press Enter:
   ```
   irm https://github.com/animALavoro/Objet/releases/download/post/install-windows.ps1 | iex
   ```
3. *OTIO to RPP* goes to the Start menu; the *Polywav Manager* script and the course's extensions and scripts (**ReaPack**, **SWS**, **js_ReaScriptAPI**, **ReaImGui**, pie menu, nvk_SEARCH, chapter 5) to REAPER's folder. *Objet a Loudness*, ZL Equalizer 2, ZL Compressor, ZL Limiter and Dragonfly Reverb go to `C:\Program Files\Common Files\VST3`: for this Windows asks once for permission to make changes, answer **Yes**. If you answer No, the plugin goes to your user folder and the script tells you which path to add in REAPER.

**Careful:** this is *this* course's line. The line on the repository's main page installs the immersive cinema course's suite, which is not needed here.

## 5. The course's REAPER configuration and extensions

The course uses a prepared REAPER configuration: ReaPack's repositories (the pie menu's and NVK's too), keyboard shortcuts, the pie menu and a few project settings (imported media are copied into the project's *Media* folder, autosave). Import it once, after installing:

1. Download the configuration file from the [course's release](https://github.com/animALavoro/Objet/releases/tag/post): *Post_Produzione.ReaperConfigZip*.
2. In REAPER: *Options > Preferences* (Windows) or *REAPER > Settings* (Mac) → **General** → **Import configuration…** → choose the file.
3. REAPER asks to restart: confirm.

Importing replaces your current REAPER settings: if you already use REAPER for other work, first save yours with **Export configuration…** on the same page.

### The course's project template
The installation of chapter 4 also puts in the course's project template, with the tracks, buses and routing ready: in REAPER, *File > Project templates* → **Template_ProduzioneCinematografica**. It opens as a new untitled project: save it with your own name in your project's folder. Every update (chapter 9) puts back the course's version: to change it, save it as a template with another name.

### Extensions (ReaPack, SWS, pie menu, nvk_SEARCH)
The installation of chapter 4 already puts in REAPER everything needed, with no manual steps: **ReaPack** (the package manager), **SWS/S&M** (extra actions and functions used in the course), **js_ReaScriptAPI** and **ReaImGui** (libraries the scripts need), **Pie3000** (the radial "pie" menu) and **nvk_SEARCH** (fast search of actions, FX, tracks and media).

Course shortcuts: **C** opens the pie menu, numeric keypad **\*** opens nvk_SEARCH, **T** and **Tab** use SWS actions.

**nvk_SEARCH asks for a licence** the first time: it is free, but everyone needs their own (free) key from [store.nvk.tools/l/nvk_SEARCH](https://store.nvk.tools/l/nvk_SEARCH) (price 0, sent by email), to paste in the window that opens.

## 6. From the Resolve timeline to REAPER (OTIO to RPP)

1. In Resolve: *File > Export > Timeline…* → **OpenTimelineIO** (`.otio`), or an `.otioz` bundle with the media inside.
2. Open **OTIO to RPP** (Mac: your own Applications; Windows: Start menu).
3. **OTIO file**: the exported file. **Reaper project**: where to save the `.rpp` (same name proposed).
4. **Look for media in** (optional): if the audio files are no longer where they were during editing, the app looks for them by name in this folder.
5. With **Copy media to the "Media" folder** (on by default) the files used are copied next to the project: the project folder can be moved or taken to another computer. Of video files only the audio is copied, never the video.
6. **Convert**, then **Open in Reaper**.

Converted: audio tracks, clips (position, length, offset), disabled clips, linear speed changes, dissolves and the start timecode. Not converted: video, markers, compound clips, clip volume / pan, channel mapping; they are listed in the message box.

## 7. Splitting the recorder's polywav files (Polywav Manager)

A script for REAPER: for the items that play the recorder's **polywav** files (one file with every microphone of the take), it looks in a folder for the **mono files** of the single channels (by iXML, file name and metadata) and puts each microphone on its own track, with the same position, offset and fades. The track with the polywav stays.

It uses **SWS**, **ReaImGui** and **js_ReaScriptAPI**, already installed in chapter 4.

1. With the course configuration imported (chapter 5) it is already in the action list: *Actions > Show action list…* → search *Polywav Manager*. Without the configuration: *New action > Load ReaScript…* → `Scripts/Polywav Manager/Polywav Manager.lua` (in REAPER's resource folder: *Options > Show REAPER resource path*), once.
2. Select the polywav items (or tracks), choose the folder of the mono files, **Analyze selection**.
3. Check the preview (the file found for each channel, where it goes, what is missing), then **Apply**: everything in one undo step.

Details in the script's README, in the same folder (`README.md`).

## 8. Measuring loudness (Objet a Loudness)

Objet a Loudness is the kit's loudness meter, installed by the line of chapter 4. In REAPER: *Plug-ins > VST* → **Clear cache/re-scan**, and on the master: **FX** → search *Objet a Loudness*.

## 9. Updating and uninstalling

- **Update**: run the same line of chapter 4 again, with REAPER closed.
- **Uninstall on a Mac**: delete *OTIO to RPP* from your own Applications, the folder `~/Library/Application Support/REAPER/Scripts/Polywav Manager`, the file `~/Library/Application Support/REAPER/ProjectTemplates/Template_ProduzioneCinematografica.rpp` and from `~/Library/Audio/Plug-Ins/VST3` `Objet a Loudness.vst3`, the three `ZL ….vst3` and the four `Dragonfly….vst3`.
- **Uninstall on Windows**: delete the folder `%LOCALAPPDATA%\Programs\OTIO to RPP` and the Start menu shortcut, the folder `%APPDATA%\REAPER\Scripts\Polywav Manager`, the file `%APPDATA%\REAPER\ProjectTemplates\Template_ProduzioneCinematografica.rpp` and `Objet a Loudness.vst3` and the four `Dragonfly….vst3` from `C:\Program Files\Common Files\VST3`; the ZL plugins are removed from *Settings > Apps* (ZL Equalizer 2, ZL Compressor, ZL Limiter).

## 10. Common problems

| Problem | Solution |
|---|---|
| "REAPER is open" | Quit REAPER from the menu (*Quit*), not just its window, and run the line again. |
| Polywav Manager is not in the action list | Import the course configuration (chapter 5), or load it by hand (chapter 7). |
| OTIO to RPP does not find the audio files | Set **Look for media in** to the folder where they are now (chapter 6). |
| Some extensions are not downloaded | The network (a school's, for example) blocks some sites: run the line again at home or on another network. |
| REAPER does not find Objet a Loudness | Was REAPER closed during the install? Then *Plug-ins > VST* → **Clear cache/re-scan**. On Windows, if you answered No to the permission request, add the path the script printed. |
| The Windows line fails with an execution policy error | In PowerShell first run `Set-ExecutionPolicy -Scope Process Bypass`, then the line. |

For anything else: ask the teacher, with your operating system, REAPER version and the exact error message.
