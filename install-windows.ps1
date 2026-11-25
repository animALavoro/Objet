# Objet suite - installer for Windows.
#   irm https://github.com/animALavoro/Objet/releases/latest/download/install-windows.ps1 | iex
#   & ([scriptblock]::Create((irm https://github.com/animALavoro/Objet/releases/latest/download/install-windows.ps1))) pa
#        only Objet Pa (also: plugins = the three plugins, scene, monitor, otio, polywav = Polywav Manager script, ext = ReaPack, SWS, js_ReaScriptAPI, ReaImGui, pie menu, nvk_SEARCH); a second argument is a version (tag <part>-<version>, or suite-<version>)
#   post = the post-production course kit: OTIO to RPP, Polywav Manager, Objet a Loudness (when the release has it) and ext;
#   loudness = Objet a Loudness only. The post-production course's own line (its release, tag "post", where this file
#   defaults to the post kit):
#   irm https://github.com/animALavoro/Objet/releases/download/post/install-windows.ps1 | iex
# The plugins go to C:\Program Files\Common Files\VST3 (the standard VST3 folder: Windows asks once for permission),
# the OTIO to RPP app to your own programs folder with a Start menu shortcut.
param([string]$What = "", [string]$Version = "")
$ErrorActionPreference = "Stop"
$script:ExtFailed = $false
$ProgressPreference = "SilentlyContinue"            # Invoke-WebRequest is much faster without the progress bar

$Repo = "animALavoro/Objet"
# what this file installs without arguments, and from which release (empty = latest): the Release workflow changes
# these two lines in the copy it puts in the post-production course's release
$DefaultPart = "all"
$DefaultTag = ""
if (-not $What) { $What = $DefaultPart }
if ($What -notin @("all", "plugins", "pa", "scene", "monitor", "otio", "polywav", "ext", "post", "loudness", "thirdparty")) { Write-Host "Unknown part '$What': use all, plugins, pa, scene, monitor, otio, polywav, ext, post, loudness or thirdparty."; return }
if ($Version -ne "") {
    $tag = if ($What -in @("all", "plugins")) { "suite-$Version" } else { "$What-$Version" }
    $Base = "https://github.com/$Repo/releases/download/$tag"
} elseif ($DefaultTag -ne "") { $Base = "https://github.com/$Repo/releases/download/$DefaultTag"
} else { $Base = "https://github.com/$Repo/releases/latest/download" }
# this same installer's address, for the message at the end
$Self = if ($DefaultTag -ne "") { "https://github.com/$Repo/releases/download/$DefaultTag/install-windows.ps1" } else { "https://github.com/$Repo/releases/latest/download/install-windows.ps1" }

if (Get-Process -Name "reaper" -ErrorAction SilentlyContinue) {
    Write-Host "REAPER is open: close it (File > Quit) and run this line again."; return
}

$tmp = Join-Path $env:TEMP ("objet-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Force $tmp | Out-Null
$stage = Join-Path $tmp "VST3"
New-Item -ItemType Directory -Force $stage | Out-Null

function Get-Part([string]$zip) {
    $file = Join-Path $tmp $zip
    Write-Host "- downloading $zip"
    Invoke-WebRequest -UseBasicParsing -Uri "$Base/$zip" -OutFile $file
    Unblock-File $file
    $dir = Join-Path $tmp ([IO.Path]::GetFileNameWithoutExtension($zip))
    Expand-Archive -Force $file $dir
    Get-ChildItem -Recurse $dir | Unblock-File
    return $dir
}

function Stage-Plugin([string]$zip, [string]$bundle) {
    $dir = Get-Part $zip
    $src = Join-Path $dir $bundle
    if (-not (Test-Path $src)) { throw "$bundle not found in $zip" }
    Copy-Item -Recurse -Force $src $stage
}

# a plugin that a release may not have yet (Objet a Loudness in the post-production kit): skipped when it is not there
function Stage-OptionalPlugin([string]$zip, [string]$bundle, [string]$name) {
    $there = $true
    try { Invoke-WebRequest -UseBasicParsing -Method Head -Uri "$Base/$zip" | Out-Null } catch { $there = $false }
    if ($there) { Stage-Plugin $zip $bundle } else { Write-Host "- ${name}: not in this release yet" }
}

function Install-Otio {
    $dir = Get-Part "OTIO-to-RPP-Windows.zip"
    $dest = Join-Path $env:LOCALAPPDATA "Programs\OTIO to RPP"
    New-Item -ItemType Directory -Force $dest | Out-Null
    Copy-Item -Force (Join-Path $dir "OTIO to RPP.exe") $dest
    $lnk = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs\OTIO to RPP.lnk"
    $sh = New-Object -ComObject WScript.Shell
    $s = $sh.CreateShortcut($lnk); $s.TargetPath = (Join-Path $dest "OTIO to RPP.exe"); $s.Save()
    Write-Host "  OTIO to RPP installed: Start menu > OTIO to RPP"
}

# the Polywav Manager script, in REAPER's Scripts folder (registered as an action by the course configuration)
function Install-Polywav {
    $dir = Get-Part "Polywav-Manager.zip"
    $src = Join-Path $dir "Polywav Manager"
    if (-not (Test-Path (Join-Path $src "Polywav Manager.lua"))) { throw "Polywav Manager.lua not found in the zip" }
    $scripts = Join-Path $env:APPDATA "REAPER\Scripts"
    New-Item -ItemType Directory -Force $scripts | Out-Null
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue (Join-Path $scripts "Polywav Manager")
    Copy-Item -Recurse -Force $src $scripts
    Write-Host "  installed in $scripts\Polywav Manager (action list: Polywav Manager)"
}

# REAPER extensions and scripts, from their own sources (not from this repository): ReaPack (from its releases), then
# the files listed in reaper-packages.txt (made at release time from the ReaPack indexes: SWS, js_ReaScriptAPI,
# ReaImGui, the pie menu, nvk_SEARCH), in the same places where ReaPack puts them
function Install-Ext {
    $res = Join-Path $env:APPDATA "REAPER"
    $up = Join-Path $res "UserPlugins"
    New-Item -ItemType Directory -Force $up | Out-Null
    Write-Host "- ReaPack"
    $dest = Join-Path $up "reaper_reapack-x64.dll"
    Invoke-WebRequest -UseBasicParsing -Uri "https://github.com/cfillion/reapack/releases/latest/download/reaper_reapack-x64.dll" -OutFile "$dest.part"
    Move-Item -Force "$dest.part" $dest
    Unblock-File $dest
    $list = Join-Path $tmp "packages.txt"
    Invoke-WebRequest -UseBasicParsing -Uri "$Base/reaper-packages.txt" -OutFile $list
    Write-Host "- SWS, js_ReaScriptAPI, ReaImGui, pie menu (Pie3000), nvk_SEARCH"
    # each line: platform, path, one or more URLs (a mirror first); a file that no URL gives is reported at the end
    $n = 0
    $failed = @()
    foreach ($line in Get-Content $list) {
        $f = $line -split "`t"
        if ($f.Count -lt 3 -or ($f[0] -ne "*" -and $f[0] -ne "win64")) { continue }
        $dest = Join-Path $res ($f[1] -replace "/", "\")
        New-Item -ItemType Directory -Force (Split-Path $dest) | Out-Null
        $ok = $false
        foreach ($u in $f[2..($f.Count - 1)]) {
            if (-not $u) { continue }
            try {
                Invoke-WebRequest -UseBasicParsing -TimeoutSec 60 -Uri $u -OutFile "$dest.part"
                $ok = $true
                break
            } catch { }
        }
        if ($ok) {
            Move-Item -Force "$dest.part" $dest
            Unblock-File $dest
            $n++
        } else {
            Remove-Item -Force -ErrorAction SilentlyContinue "$dest.part"
            $failed += "    $($f[1]) ($($f[2]))"
        }
    }
    Write-Host "  $n files installed in $res"
    if ($failed.Count -gt 0) {
        $script:ExtFailed = $true
        Write-Host "  NOT downloaded (network?):"
        $failed | ForEach-Object { Write-Host $_ }
    }
}

# free plugins by other authors (post-production kit): third-party-plugins.txt (made at release time) gives each
# plugin's file on its author's own release page, per platform. The processor decides the version: ARM64, or x86-64
# with AVX2 when the processor has it (faster), else plain x86-64. A .zip's .vst3 folders are copied with our plugins;
# an .msi is run silently in the same administrator step.
$script:Msis = @()
$script:ThirdFailed = @()
function Get-Platform {
    $arch = if ($env:PROCESSOR_ARCHITEW6432) { $env:PROCESSOR_ARCHITEW6432 } else { $env:PROCESSOR_ARCHITECTURE }
    if ($arch -eq "ARM64") { return @("winarm64", "win64") }
    $avx2 = $false
    try {
        Add-Type -Namespace Objet -Name Cpu -MemberDefinition '[DllImport("kernel32.dll")] public static extern bool IsProcessorFeaturePresent(uint f);' -ErrorAction Stop
        $avx2 = [Objet.Cpu]::IsProcessorFeaturePresent(40)    # PF_AVX2_INSTRUCTIONS_AVAILABLE
    } catch { }
    if ($avx2) { return @("win64-avx2", "win64") } else { return @("win64") }
}
function Stage-ThirdParty {
    $list = Join-Path $tmp "thirdparty.txt"
    try { Invoke-WebRequest -UseBasicParsing -Uri "$Base/third-party-plugins.txt" -OutFile $list } catch { Write-Host "- other plugins: none in this release"; return }
    $prefs = Get-Platform
    $lines = @(Get-Content $list | ForEach-Object { ,($_ -split "`t") } | Where-Object { $_.Count -ge 4 })
    foreach ($name in ($lines | ForEach-Object { $_[1] } | Select-Object -Unique)) {
        $pick = $null
        foreach ($pf in $prefs) { $pick = $lines | Where-Object { $_[1] -eq $name -and $_[0] -eq $pf } | Select-Object -First 1; if ($pick) { break } }
        if (-not $pick) { continue }
        Write-Host "- $name ($($pick[0]))"
        $file = Join-Path $tmp ("tp-" + [guid]::NewGuid().ToString("N") + "." + $pick[2])
        try { Invoke-WebRequest -UseBasicParsing -TimeoutSec 300 -Uri $pick[3] -OutFile $file; Unblock-File $file }
        catch { Write-Host "  download failed: $($pick[3])"; $script:ThirdFailed += $name; continue }
        if ($pick[2] -eq "msi") {
            $script:Msis += $file
        } else {
            $dir = "$file.d"
            Expand-Archive -Force $file $dir
            Get-ChildItem -Recurse $dir | Unblock-File
            $found = @(Get-ChildItem -Recurse -Directory $dir -Filter *.vst3 | Where-Object { $_.Parent.Name -notlike "*.vst3" -and $_.FullName -notmatch '\.vst3\\.+\.vst3$' })
            foreach ($b in $found) { Copy-Item -Recurse -Force $b.FullName $stage }
            if ($found.Count -eq 0) { Write-Host "  no VST3 plugin found in the file"; $script:ThirdFailed += $name }
        }
    }
}

if ($What -eq "post") { Write-Host "Objet, post-production kit: installing from $Base" } else { Write-Host "Objet suite: installing from $Base" }
if ($What -in @("all", "plugins", "pa"))      { Stage-Plugin "Objet-Pa-Windows.zip" "LB Spanner.vst3" }
if ($What -in @("all", "plugins", "scene"))   { Stage-Plugin "Objet-a-Scene-Windows.zip" "Objet a Scene.vst3" }
if ($What -in @("all", "plugins", "monitor")) { Stage-Plugin "Objet-a-Monitor-Windows.zip" "Objet a Monitor.vst3" }
if ($What -eq "loudness")                     { Stage-Plugin "Objet-a-Loudness-Windows.zip" "Objet a Loudness.vst3" }
if ($What -eq "post")                         { Stage-OptionalPlugin "Objet-a-Loudness-Windows.zip" "Objet a Loudness.vst3" "Objet a Loudness" }
if ($What -in @("post", "thirdparty"))        { Stage-ThirdParty }

$plugins = @(Get-ChildItem $stage -Directory)
if ($plugins.Count -gt 0 -or $script:Msis.Count -gt 0) {
    $vst3 = Join-Path $env:CommonProgramFiles "VST3"
    $names = ($plugins | ForEach-Object { $_.Name }) -join ", "
    if ($plugins.Count -gt 0) { Write-Host "- copying $names to $vst3 (Windows asks for permission)" }
    $parts = @("New-Item -ItemType Directory -Force '$vst3' | Out-Null")
    $parts += @($plugins | ForEach-Object {
        "Remove-Item -Recurse -Force -ErrorAction SilentlyContinue '" + (Join-Path $vst3 $_.Name) + "'; Copy-Item -Recurse -Force '" + $_.FullName + "' '$vst3'"
    })
    # installers of other authors' plugins, silently, in the same administrator step; the exit code tells if one failed
    foreach ($m in $script:Msis) { $parts += "`$r = (Start-Process msiexec -Wait -PassThru -ArgumentList @('/i', '$m', '/qn', '/norestart')).ExitCode; if (`$r -ne 0 -and `$r -ne 3010) { exit 20 }" }
    $cmd = $parts -join "; "
    if ($script:Msis.Count -gt 0) { Write-Host "- installing $($script:Msis.Count) plugin(s) by other authors" }
    try {
        $p = Start-Process powershell -Verb RunAs -Wait -PassThru -WindowStyle Hidden -ArgumentList @("-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", $cmd)
        if ($p.ExitCode -eq 20) { Write-Host "  an installer of another author's plugin failed"; $script:ThirdFailed += "plugin installer (.msi)" }
        elseif ($p.ExitCode -ne 0) { throw "copy failed ($($p.ExitCode))" }
        Write-Host "  installed in $vst3"
    } catch {
        # no permission: the user's own VST3 folder, to add in REAPER
        $user = Join-Path $env:LOCALAPPDATA "Programs\Common\VST3"
        New-Item -ItemType Directory -Force $user | Out-Null
        foreach ($pl in $plugins) {
            Remove-Item -Recurse -Force -ErrorAction SilentlyContinue (Join-Path $user $pl.Name)
            Copy-Item -Recurse -Force $pl.FullName $user
        }
        Write-Host "  no permission: installed in $user"
        Write-Host "  add that folder in REAPER: Options > Preferences > Plug-ins > VST > VST plug-in paths > Add"
        if ($script:Msis.Count -gt 0) { Write-Host "  plugins by other authors that need an installer were not installed (no permission)"; $script:ThirdFailed += "plugin installers (.msi): need permission" }
    }
}
if ($What -in @("all", "post", "otio")) { Install-Otio }
if ($What -in @("all", "post", "polywav")) { Install-Polywav }
if ($What -in @("all", "post", "ext"))  { Install-Ext }

Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $tmp
Write-Host ""
if ($script:ExtFailed) {
    Write-Host "Some REAPER extensions or scripts could not be downloaded (listed above): on another network, run"
    Write-Host "  & ([scriptblock]::Create((irm $Self))) ext"
}
if ($script:ThirdFailed.Count -gt 0) {
    Write-Host "Some plugins by other authors were not installed: $($script:ThirdFailed -join ', ')"
    Write-Host "  run again: & ([scriptblock]::Create((irm $Self))) thirdparty"
}
Write-Host "Done. Open REAPER: Options > Preferences > Plug-ins > VST > Clear cache/re-scan."
