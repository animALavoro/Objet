# Objet suite - installer for Windows.
#   irm https://github.com/animALavoro/Objet/releases/latest/download/install-windows.ps1 | iex
#   & ([scriptblock]::Create((irm https://github.com/animALavoro/Objet/releases/latest/download/install-windows.ps1))) pa
#        only Objet Pa (also: plugins = the three plugins, scene, monitor, otio, ext = ReaPack + ReaImGui); a second argument is a version (tag <part>-<version>, or suite-<version>)
# The plugins go to C:\Program Files\Common Files\VST3 (the standard VST3 folder: Windows asks once for permission),
# the OTIO to RPP app to your own programs folder with a Start menu shortcut.
param([string]$What = "all", [string]$Version = "")
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"            # Invoke-WebRequest is much faster without the progress bar

$Repo = "animALavoro/Objet"
if ($What -notin @("all", "plugins", "pa", "scene", "monitor", "otio", "ext")) { Write-Host "Unknown part '$What': use all, plugins, pa, scene, monitor, otio or ext."; return }
if ($Version -ne "") {
    $tag = if ($What -in @("all", "plugins")) { "suite-$Version" } else { "$What-$Version" }
    $Base = "https://github.com/$Repo/releases/download/$tag"
} else { $Base = "https://github.com/$Repo/releases/latest/download" }

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

# REAPER extensions from their own releases (not from this repository): ReaPack (packages: SWS, scripts) and ReaImGui
function Install-Ext {
    $up = Join-Path $env:APPDATA "REAPER\UserPlugins"
    New-Item -ItemType Directory -Force $up | Out-Null
    foreach ($f in @(@("cfillion/reapack", "reaper_reapack-x64.dll"), @("cfillion/reaimgui", "reaper_imgui-x64.dll"))) {
        Write-Host "- $($f[1])"
        $dest = Join-Path $up $f[1]
        Invoke-WebRequest -UseBasicParsing -Uri "https://github.com/$($f[0])/releases/latest/download/$($f[1])" -OutFile "$dest.part"
        Move-Item -Force "$dest.part" $dest
        Unblock-File $dest
    }
    Write-Host "  installed in $up (REAPER: Extensions > ReaPack)"
}

Write-Host "Objet suite: installing from $Base"
if ($What -in @("all", "plugins", "pa"))      { Stage-Plugin "Objet-Pa-Windows.zip" "LB Spanner.vst3" }
if ($What -in @("all", "plugins", "scene"))   { Stage-Plugin "Objet-a-Scene-Windows.zip" "Objet a Scene.vst3" }
if ($What -in @("all", "plugins", "monitor")) { Stage-Plugin "Objet-a-Monitor-Windows.zip" "Objet a Monitor.vst3" }

$plugins = @(Get-ChildItem $stage -Directory)
if ($plugins.Count -gt 0) {
    $vst3 = Join-Path $env:CommonProgramFiles "VST3"
    $names = ($plugins | ForEach-Object { $_.Name }) -join ", "
    Write-Host "- copying $names to $vst3 (Windows asks for permission)"
    $cmd = "New-Item -ItemType Directory -Force '$vst3' | Out-Null; " + (($plugins | ForEach-Object {
        "Remove-Item -Recurse -Force -ErrorAction SilentlyContinue '" + (Join-Path $vst3 $_.Name) + "'; Copy-Item -Recurse -Force '" + $_.FullName + "' '$vst3'"
    }) -join "; ")
    try {
        $p = Start-Process powershell -Verb RunAs -Wait -PassThru -WindowStyle Hidden -ArgumentList @("-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", $cmd)
        if ($p.ExitCode -ne 0) { throw "copy failed ($($p.ExitCode))" }
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
    }
}
if ($What -in @("all", "otio")) { Install-Otio }
if ($What -in @("all", "ext"))  { Install-Ext }

Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $tmp
Write-Host ""
Write-Host "Done. Open REAPER: Options > Preferences > Plug-ins > VST > Clear cache/re-scan."
