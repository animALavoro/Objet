-- Objet Pa video overlay on macOS, in REAPER on a CI Mac (run by .github/workflows/mac-overlay-test.yml).
-- Builds a project (a video item, a track with Objet Pa), shows REAPER's video window and goes through phases.
-- At each phase it writes $TMPDIR/objet_phase_<n> and waits for $TMPDIR/objet_ack_<n> (the workflow takes a
-- screenshot in between). Log in $TMPDIR/objet_overlay.txt. Quits REAPER at the end without a save dialog.
local tmp = (os.getenv("TMPDIR") or "/tmp"):gsub("/$", "")
local f = io.open(tmp .. "/objet_overlay.txt", "w")
local function log(s) f:write(os.date("%H:%M:%S ") .. tostring(s) .. "\n") f:flush() end
local function exists(p) local h = io.open(p, "r") if h then h:close() return true end return false end
log("REAPER " .. reaper.GetAppVersion())

local video = os.getenv("OBJET_VIDEO") or (tmp .. "/objet_test.mp4")
local tr
local fx = -1

local function setByLabel(label)
  for p = 0, math.min(16, reaper.TrackFX_GetNumParams(tr, fx) - 1) do
    for k = 0, 400 do
      local v = k / 400
      local _, txt = reaper.TrackFX_FormatParamValueNormalized(tr, fx, p, v, "")
      if txt == label then reaper.TrackFX_SetParamNormalized(tr, fx, p, v) log("param " .. p .. " = " .. label) return true end
    end
  end
  log("FAIL no parameter takes '" .. label .. "'")
  return false
end

local phases = {
  { "stereo", function() end },
  { "5.1", function()
      reaper.SetMediaTrackInfo_Value(tr, "I_NCHAN", 6)
      reaper.SetMediaTrackInfo_Value(reaper.GetMasterTrack(0), "I_NCHAN", 6)
      setByLabel("5.1")
    end },
  { "hoa3", function()
      reaper.SetMediaTrackInfo_Value(tr, "I_NCHAN", 16)
      reaper.SetMediaTrackInfo_Value(reaper.GetMasterTrack(0), "I_NCHAN", 16)
      setByLabel("HOA 3 (AmbiX)")
    end },
  { "hoa3-later", function() end },                 -- a few seconds more: the energy map (if audio runs)
  { "finder-in-front", function() end },            -- the workflow brings Finder to the front: the overlay must hide
  { "fullscreen", function() end },                 -- the workflow makes the video window full screen
}

local function start()
  reaper.InsertTrackAtIndex(0, false)
  tr = reaper.GetTrack(0, 0)
  reaper.SetOnlyTrackSelected(tr)
  reaper.SetEditCurPos(0, false, false)
  local ok = reaper.InsertMedia(video, 0)          -- on the selected track, at the cursor
  log("video inserted: " .. tostring(ok) .. " (" .. video .. ")")
  for _, name in ipairs({ "Objet Pa", "LB Spanner" }) do
    fx = reaper.TrackFX_AddByName(tr, name, false, -1)
    if fx >= 0 then break end
  end
  log("Objet Pa fx index " .. fx)
  if fx < 0 then log("FAIL Objet Pa not found") end
  reaper.TrackFX_Show(tr, fx, 2)                   -- no floating editor
  reaper.SetOnlyTrackSelected(tr)
  reaper.Main_OnCommand(50125, 0)                  -- Video: show video window
  reaper.OnPlayButton()
  log("audio running " .. tostring(reaper.Audio_IsRunning and reaper.Audio_IsRunning()) .. ", play state " .. reaper.GetPlayState())
end

local k, waitUntil, waiting = 0, reaper.time_precise() + 6, false
local function step()
  local now = reaper.time_precise()
  if not waiting and now >= waitUntil then
    k = k + 1
    if k > #phases then
      log("done")
      f:close()
      reaper.OnStopButton()
      reaper.Main_SaveProject(0, false)
      reaper.Main_OnCommand(40004, 0)
      return
    end
    phases[k][2]()
    reaper.SetOnlyTrackSelected(tr)
    waitUntil = now + 4                              -- let the overlay settle (30 Hz updates)
    waiting = "settle"
  elseif waiting == "settle" and now >= waitUntil then
    local m = io.open(tmp .. "/objet_phase_" .. k, "w") m:write(phases[k][1]) m:close()
    log("phase " .. k .. " " .. phases[k][1] .. ": play state " .. reaper.GetPlayState() .. ", position " .. string.format("%.2f", reaper.GetPlayPosition()))
    waiting = "ack"
  elseif waiting == "ack" and exists(tmp .. "/objet_ack_" .. k) then
    waiting = false
    waitUntil = now
  end
  reaper.defer(step)
end

start()
reaper.defer(step)
