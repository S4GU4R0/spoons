--- === WindowManager ===
---
--- Snaps windows to the left or right half of the screen.
---
--- Download: [https://github.com/Hammerspoon/Spoons](https://github.com/Hammerspoon/Spoons)

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "WindowManager"
obj.version = "1.0.0"
obj.author = "Ira Sanchez"
obj.homepage = "https://github.com/S4GU4R0/spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

-- Internal Storage
obj._hotkeys = {}

function obj:init()
    -- Nothing to initialize here
end

--- WindowManager:snapLeft()
--- Method
--- Snaps the focused window to the left half of the current screen.
function obj:snapLeft()
    local win = hs.window.focusedWindow()
    if not win then return end
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
end

--- WindowManager:snapRight()
--- Method
--- Snaps the focused window to the right half of the current screen.
function obj:snapRight()
    local win = hs.window.focusedWindow()
    if not win then return end
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 2)
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
end

--- WindowManager:bindHotkeys(mapping)
--- Method
--- Binds hotkeys for WindowManager actions.
---
--- Parameters:
---  * mapping - A table where keys are action names ("left", "right") and values are hotkey specs (e.g. `{"ctrl", "opt"}, "left"`)
function obj:bindHotkeys(mapping)
    local spec = {
        left = hs.fnutils.partial(self.snapLeft, self),
        right = hs.fnutils.partial(self.snapRight, self),
    }
    hs.spoons.bindHotkeysToSpec(spec, mapping)
    return self
end

--- WindowManager:start()
--- Method
--- Starts the Spoon (nothing to do as hotkeys are handled via bindHotkeys).
function obj:start()
    return self
end

--- WindowManager:stop()
--- Method
--- Stops the Spoon.
function obj:stop()
    return self
end

return obj
