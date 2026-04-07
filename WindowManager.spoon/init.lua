--- === WindowManager ===
---
--- Snaps windows to the left or right half of the screen.
---
--- Author: Saguaro Prole
--- License: MIT

local obj    = {}
obj.__index  = obj

-- Metadata
obj.name     = "WindowManager"
obj.version  = "1.1.0"
obj.author   = "Saguaro Prole"
obj.homepage = "https://github.com/S4GU4R0/spoons"
obj.license  = "MIT - https://opensource.org/licenses/MIT"

obj._hotkeys = {}

function obj:init()
end

--- WindowManager:snapLeft()
--- Snaps the focused window to the left half of the current screen.
function obj:snapLeft()
    local win = hs.window.focusedWindow()
    if not win then return end
    local max = win:screen():frame()
    win:setFrame({ x = max.x, y = max.y, w = max.w / 2, h = max.h }, 0)
end

--- WindowManager:snapRight()
--- Snaps the focused window to the right half of the current screen.
function obj:snapRight()
    local win = hs.window.focusedWindow()
    if not win then return end
    local max = win:screen():frame()
    win:setFrame({ x = max.x + max.w / 2, y = max.y, w = max.w / 2, h = max.h }, 0)
end

--- WindowManager:snapFull()
--- Snaps the focused window to fill the entire screen.
function obj:snapFull()
    local win = hs.window.focusedWindow()
    if not win then return end
    local max = win:screen():frame()
    win:setFrame({ x = max.x, y = max.y, w = max.w, h = max.h }, 0)
end

--- WindowManager:bindHotkeys(mapping)
--- Parameters:
---  * mapping - e.g. { left = {{"ctrl","alt"}, "left"}, right = {{"ctrl","alt"}, "right"} }
function obj:bindHotkeys(mapping)
    local spec = {
        left  = hs.fnutils.partial(self.snapLeft, self),
        right = hs.fnutils.partial(self.snapRight, self),
    }
    hs.spoons.bindHotkeysToSpec(spec, mapping)
    return self
end

function obj:start() return self end

function obj:stop() return self end

return obj
