-- ==========================================
-- Rabbit Log: Documenting the rabbit hole
-- ==========================================

local obj = {}

function obj:init()
end

local logFilePath = "/Volumes/HD/AI/Main_Street/Ira/Office/FrontDoor/Desk/Desktop/rabbit_log.csv"

local cmdWHotkey

-- 1. Create the Chooser
local chooser
chooser = hs.chooser.new(function(result)
  -- Always re-enable hotkey first
  if cmdWHotkey then cmdWHotkey:enable() end

  -- Get the state of the app we were closing
  local savedState = hs.settings.get("rabbitLogState")
  if not savedState or not savedState.bundleID then
    chooser:hide()
    return
  end

  local targetApp = hs.application.get(savedState.bundleID)
  local title = savedState.title

  -- Helper to perform the final close operation
  local function closeTab()
    if targetApp then
      targetApp:activate()
      hs.timer.doAfter(0.1, function()
        hs.eventtap.keyStroke({ "cmd" }, "w", targetApp)
      end)
    end
  end

  -- 1. If result is nil, user hit ESC (Cancel)
  if not result then
    chooser:hide()
    closeTab() -- Close it anyway as requested
    return
  end

  -- 2. Safe Execution Wrapper for Logging
  local status, err = pcall(function()
    if not targetApp then return end

    -- 3. Log Data
    local reason = chooser:query() or ""
    local file = io.open(logFilePath, "a")
    if file then
      local function esc(t)
        t = t or ""; return "\"" .. t:gsub("\"", "\"\"") .. "\""
      end
      local timestamp = os.date("%Y-%m-%d %H:%M:%S")
      local line = string.format("%s,%s,%s,%s\n", esc(timestamp), esc(targetApp:name()), esc(title), esc(reason))
      file:write(line)
      file:close()
    end

    -- 4. Focus & Close
    closeTab()

    -- Visual Feedback
    hs.alert.show("Logged!")
  end)

  -- Ensure chooser closes even if error occurred
  chooser:hide()

  -- Log error to console if it happened
  if not status then print("Error in callback: " .. err) end
end)

-- Helper to get URL or File Path
local function getResource(win)
  local app = win:application()
  local bundleID = app:bundleID()
  local name = app:name()

  -- Chromium-based browsers (Chrome, BrowserOS, Brave, Edge)
  if bundleID == "com.google.Chrome" or bundleID == "com.browseros.BrowserOS" or bundleID == "com.brave.Browser" or bundleID == "com.microsoft.edgemac" then
    local script = 'tell application id "' .. bundleID .. '" to get URL of active tab of front window'
    local status, result = hs.osascript.applescript(script)
    if status then return result end

    -- Safari
  elseif bundleID == "com.apple.Safari" then
    local script = 'tell application "Safari" to get URL of front document'
    local status, result = hs.osascript.applescript(script)
    if status then return result end

    -- Finder
  elseif bundleID == "com.apple.finder" then
    local script = 'tell application "Finder" to get POSIX path of ((target of front window) as alias)'
    local status, result = hs.osascript.applescript(script)
    if status then return "file://" .. result end
  end

  return win:title()
end

-- Configure Chooser
chooser:width(40)
chooser:rows(1)
chooser:searchSubText(true)

-- THE FIX: Update choices dynamically so the button NEVER disappears
chooser:queryChangedCallback(function(query)
  chooser:choices({
    {
      text = "Log",
      subText = "Save: " .. (query or "Empty entry")
    }
  })
end)

-- 2. The Main Hotkey Logic
cmdWHotkey = hs.hotkey.bind({ "cmd" }, "w", function()
  local win = hs.window.focusedWindow()

  if not win then
    cmdWHotkey:disable()
    hs.eventtap.keyStroke({ "cmd" }, "w")
    hs.timer.doAfter(0.1, function() cmdWHotkey:enable() end)
    return
  end

  local app = win:application()
  local resource = getResource(win)

  local state = {
    bundleID = app:bundleID(),
    title = resource
  }

  hs.settings.set("rabbitLogState", state)

  cmdWHotkey:disable()

  -- Show the chooser (the queryChangedCallback will populate the list immediately)
  chooser:show()
end)

return obj
