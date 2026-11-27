-- The student kit in REAPER on a CI Mac (run by .github/workflows/kit-test.yml), after install-mac.sh and the
-- course configuration: which extensions REAPER loaded, which scripts are registered, then each script is run and the
-- workflow takes a screenshot (phase files $TMPDIR/kit_phase_<n>, acknowledged by $TMPDIR/kit_ack_<n>).
-- Post-production kit: the course's project template is opened (as File > Project templates does) and every FX in it
-- must load; before it, every plugin of the kit is put on a track by name and must load.
-- Log in $TMPDIR/kit_test.txt. Quits REAPER at the end.
local tmp = (os.getenv("TMPDIR") or "/tmp"):gsub("/$", "")
local f = io.open(tmp .. "/kit_test.txt", "w")
local function log(s) f:write(os.date("%H:%M:%S ") .. tostring(s) .. "\n") f:flush() end
local function exists(p) local h = io.open(p, "r") if h then h:close() return true end return false end
local res = reaper.GetResourcePath()
log("REAPER " .. reaper.GetAppVersion() .. ", resource " .. res)
for _, k in ipairs({ "env_reduce", "splitautoxfade", "itemicons", "itemvolmode", "labelitems2", "video_decprio" }) do
  local ok, v = reaper.get_config_var_string(k)
  log("config " .. k .. " = " .. tostring(ok and v or "?"))
end
do
  local h = io.open(res .. "/REAPER.ini", "r")
  if h then
    local sec
    for line in h:lines() do
      local s = line:match("^%[(.+)%]") if s then sec = s end
      if line:find("^fx_mode") or line:find("^video_decprio") then log("ini [" .. tostring(sec) .. "] " .. line) end
    end
    h:close()
  end
end

local function api(name) local ok = reaper.APIExists(name) log((ok and "ok   " or "FAIL ") .. "API " .. name) return ok end
api("CF_GetSWSVersion")              -- SWS
api("JS_ReaScriptAPI_Version")       -- js_ReaScriptAPI
api("ImGui_GetBuiltinPath")          -- ReaImGui
api("ReaPack_BrowsePackages")        -- ReaPack
if reaper.CF_GetSWSVersion then log("SWS " .. reaper.CF_GetSWSVersion()) end
if reaper.JS_ReaScriptAPI_Version then log("js " .. reaper.JS_ReaScriptAPI_Version()) end
if reaper.ImGui_GetVersion then log("ImGui " .. tostring(select(1, reaper.ImGui_GetVersion()))) end
for _, p in ipairs({ "Scripts/ReaTeam Extensions/API/imgui.lua", "Scripts/Sexan_Scripts/Pie3000/Sexan_Pie3000.lua",
                     "Scripts/nvk-ReaScripts/SEARCH/nvk_SEARCH.lua",
                     "Scripts/nvk-ReaScripts/SHARED/nvk_SHARED.lua", "Scripts/Polywav Manager/Polywav Manager.lua",
                     "Scripts/Sexan_Scripts/Pie3000/pie_file.txt" }) do
  log((exists(res .. "/" .. p) and "ok   " or "FAIL ") .. p)
end

local function cmd(id, name)
  local c = reaper.NamedCommandLookup(id)
  log((c ~= 0 and "ok   " or "FAIL ") .. "action " .. name .. " (" .. id .. ") = " .. c)
  return c
end
local pie = cmd("_RS2039f6a463e791b26b83664161168a2f34203c16", "Pie3000 (key C)")
local nvk = cmd("_RS42ab70fd2ac65e9a003787709bb85f18c36dee52", "nvk_SEARCH (key *)")
local pw = cmd("_RSe58199659d1dd72df9f3454fa92592fb6411358d", "Polywav Manager (from the course configuration)")
cmd("_S&M_TAKEENVSHOW1", "SWS take envelope (key T)")
cmd("_XENAKIOS_SELFIRSTITEMSOFTRACKS", "SWS Xenakios (in Tab)")

-- an FX loaded when REAPER found the plugin: a missing one stays in the chain as an offline placeholder, no parameters
local function fx_check(tr, i, where)
  local _, name = reaper.TrackFX_GetFXName(tr, i, "")
  local np, off = reaper.TrackFX_GetNumParams(tr, i), reaper.TrackFX_GetOffline(tr, i)
  log(((np > 0 and not off) and "ok   " or "FAIL ") .. "FX " .. name .. " (" .. where .. ", " .. np .. " parameters" .. (off and ", offline" or "") .. ")")
end
local TEMPLATE = res .. "/ProjectTemplates/Template_ProduzioneCinematografica.rpp"
local KIT_FX = { "Objet a Loudness", "ZL Equalizer 2", "ZL Compressor", "ZL Limiter", "Dragonfly Hall Reverb",
                 "Dragonfly Room Reverb", "Dragonfly Plate Reverb", "Dragonfly Early Reflections" }
local function template_check()
  if not exists(TEMPLATE) then log("no project template (not the post kit, or not in this release)") return end
  -- first every plugin of the kit, by name, on a track of the test project (saved: no "save changes?" question)
  reaper.InsertTrackAtIndex(reaper.CountTracks(0), false)
  local kt = reaper.GetTrack(0, reaper.CountTracks(0) - 1)
  for _, p in ipairs(KIT_FX) do
    local i = reaper.TrackFX_AddByName(kt, "VST3:" .. p, false, -1)
    if i < 0 then log("FAIL FX " .. p .. " (not found by REAPER)") else fx_check(kt, i, "kit check track") end
  end
  reaper.Main_SaveProject(0, false)
  -- then the template, as File > Project templates opens it (a "Project Load Warning" waits for OK: the workflow
  -- takes its screenshot, then presses OK)
  reaper.Main_openProject("template:" .. TEMPLATE)
  log("template: " .. reaper.CountTracks(0) .. " tracks")
  for t = -1, reaper.CountTracks(0) - 1 do
    local tr = t < 0 and reaper.GetMasterTrack(0) or reaper.GetTrack(0, t)
    local _, tn = reaper.GetTrackName(tr)
    for i = 0, reaper.TrackFX_GetCount(tr) - 1 do fx_check(tr, i, "track " .. (t + 1) .. " " .. tn) end
  end
  reaper.Main_SaveProjectEx(0, tmp .. "/kit_template_check.rpp", 0)   -- saved: no "save changes?" question at the end
end

local phases = {
  { "start", function() end },
  { "pie3000", function() if pie ~= 0 then reaper.Main_OnCommand(pie, 0) end end },
  { "polywav-manager", function() if pw ~= 0 then reaper.Main_OnCommand(pw, 0) end end },
  { "project-template", template_check },
  { "nvk-search", function() if nvk ~= 0 then reaper.Main_OnCommand(nvk, 0) end end },   -- last: its licence windows
  { "later", function() end },
}

local n, t0, waiting = 0, reaper.time_precise(), false
local function step()
  if waiting then
    if exists(tmp .. "/kit_ack_" .. n) or reaper.time_precise() - t0 > 60 then waiting = false; t0 = reaper.time_precise() end
  elseif reaper.time_precise() - t0 > 6 then
    n = n + 1
    if n > #phases then log("done") f:close() reaper.Main_OnCommand(40004, 0) return end   -- File: Quit
    log("phase " .. n .. " " .. phases[n][1])
    local h = io.open(tmp .. "/kit_phase_" .. n, "w") h:write(phases[n][1]) h:close()   -- first: a script can block here
    phases[n][2]()
    waiting = true; t0 = reaper.time_precise()
  end
  reaper.defer(step)
end
reaper.defer(step)
