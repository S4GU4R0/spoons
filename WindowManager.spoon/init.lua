--- === WindowManager ===
---
--- Snaps windows to common screen positions.
--- Supports: left half, right half, top half, bottom half,
---           fullscreen, center, left/center/right thirds.
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

-- ─── Helper ──────────────────────────────────────────────────────────────────

local function setFrame(unit)
    local win = hs.window.focusedWindow()
    if not win then return end
    local max = win:screen():frame() -- usable area (excludes menu bar / dock)

    local f = {}
    f.x = max.x + (unit.x * max.w)
    f.y = max.y + (unit.y * max.h)
    f.w = unit.w * max.w
    f.h = unit.h * max.h

    win:setFrame(f, 0) -- 0 = no animation
end

-- ─── Positions ───────────────────────────────────────────────────────────────

function obj:snapLeft()
    setFrame({ x = 0, y = 0, w = 0.5, h = 1 })
end

function obj:snapRight()
    setFrame({ x = 0.5, y = 0, w = 0.5, h = 1 })
end

function obj:snapTop()
    setFrame({ x = 0, y = 0, w = 1, h = 0.5 })
end

function obj:snapBottom()
    setFrame({ x = 0, y = 0.5, w = 1, h = 0.5 })
end

function obj:snapFull()
    setFrame({ x = 0, y = 0, w = 1, h = 1 })
end

function obj:snapCenter()
    setFrame({ x = 0.1, y = 0.1, w = 0.8, h = 0.8 })
end

function obj:snapLeftThird()
    setFrame({ x = 0, y = 0, w = 1 / 3, h = 1 })
end

function obj:snapCenterThird()
    setFrame({ x = 1 / 3, y = 0, w = 1 / 3, h = 1 })
end

function obj:snapRightThird()
    setFrame({ x = 2 / 3, y = 0, w = 1 / 3, h = 1 })
end

-- ─── Hotkey Binding ──────────────────────────────────────────────────────────

--- WindowManager:bindHotkeys(mapping)
--- Binds hotkeys for WindowManager actions.
---
--- Example mapping:
---   {
---     left        = { {"ctrl","alt"}, "left"  },
---     right       = { {"ctrl","alt"}, "right" },
---     top         = { {"ctrl","alt"}, "up"    },
---     bottom      = { {"ctrl","alt"}, "down"  },
---     full        = { {"ctrl","alt"}, "f"     },
---     center      = { {"ctrl","alt"}, "c"     },
---     leftThird   = { {"ctrl","alt"}, "1"     },
---     centerThird = { {"ctrl","alt"}, "2"     },
---     rightThird  = { {"ctrl","alt"}, "3"     },
---   }
function obj:bindHotkeys(mapping)
    local spec = {
        left        = hs.fnutils.partial(self.snapLeft, self),
        right       = hs.fnutils.partial(self.snapRight, self),
        top         = hs.fnutils.partial(self.snapTop, self),
        bottom      = hs.fnutils.partial(self.snapBottom, self),
        full        = hs.fnutils.partial(self.snapFull, self),
        center      = hs.fnutils.partial(self.snapCenter, self),
        leftThird   = hs.fnutils.partial(self.snapLeftThird, self),
        centerThird = hs.fnutils.partial(self.snapCenterThird, self),
        rightThird  = hs.fnutils.partial(self.snapRightThird, self),
    }
    hs.spoons.bindHotkeysToSpec(spec, mapping)
    return self
end

function obj:start() return self end

function obj:stop() return self end

return obj
