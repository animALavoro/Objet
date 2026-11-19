-- The student kit in REAPER on a CI Mac (run by .github/workflows/kit-test.yml), after install-mac.sh and the
-- course configuration: which extensions REAPER loaded, which scripts are registered, then each script is run and the
-- workflow takes a screenshot (phase files $TMPDIR/kit_phase_<n>, acknowledged by $TMPDIR/kit_ack_<n>).
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

local phases = {
  { "start", function() end },
  { "pie3000", function() if pie ~= 0 then reaper.Main_OnCommand(pie, 0) end end },
  { "polywav-manager", function() if pw ~= 0 then reaper.Main_OnCommand(pw, 0) end end },
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
