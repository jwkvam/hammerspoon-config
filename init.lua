-- hs.hotkey.bind({'cmd', 'alt', 'ctrl'}, 'W', function()
--     hs.alert.show('Hello World!')
-- end)

-- local grid = require "hs.grid"
--
-- require "keyboard_grid"

configFileWatcher = nil

function move_left()
    local win = hs.window.focusedWindow()
    if win == nil then
        return
    end
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
    redrawBorder()
end

function move_right()
    local win = hs.window.focusedWindow()
    if win == nil then
        return
    end
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 2)
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
    redrawBorder()
end

function move_topleft()
    local win = hs.window.focusedWindow()
    if win == nil then
        return
    end
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
    redrawBorder()
end

function move_topright()
    local win = hs.window.focusedWindow()
    if win == nil then
        return
    end
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 2)
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
    redrawBorder()
end

function move_botleft()
    local win = hs.window.focusedWindow()
    if win == nil then
        return
    end
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y + (max.h / 2)
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
    redrawBorder()
end

function move_botright()
    local win = hs.window.focusedWindow()
    if win == nil then
        return
    end
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 2)
    f.y = max.y + (max.h / 2)
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
    redrawBorder()
end

function maximize_window()
    local win = hs.window.focusedWindow()
    if win == nil then
        return
    end
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h
    win:setFrame(f)
    redrawBorder()
end

function focus_left()
    local win = hs.window.filter.new():setCurrentSpace(true)
    -- local win = hs.window.focusedWindow()
    if win == nil then
        return
    end
    win:focusWindowWest(nil, false, true)
    -- win:focusWindowWest(nil, nil, True)
end

function focus_right()
    local win = hs.window.filter.new():setCurrentSpace(true)
    if win == nil then
        return
    end
    win:focusWindowEast(nil, false, true)
end

function focus_north()
    local win = hs.window.filter.new():setCurrentSpace(true)
    if win == nil then
        return
    end
    win:focusWindowNorth(nil, false, true)
end

function focus_south()
    local win = hs.window.filter.new():setCurrentSpace(true)
    if win == nil then
        return
    end
    win:focusWindowSouth(nil, false, true)
end

-- I always end up losing my mouse pointer, particularly if it's on a monitor full of terminals.
-- This draws a bright red circle around the pointer for a few seconds
function mouseHighlight()
    if mouseCircle then
        mouseCircle:delete()
        if mouseCircleTimer then
            mouseCircleTimer:stop()
        end
    end
    mousepoint = hs.mouse.get()
    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 80, 80))
    mouseCircle:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1})
    mouseCircle:setFill(false)
    mouseCircle:setStrokeWidth(5)
    mouseCircle:show()

    mouseCircleTimer = hs.timer.doAfter(3, function() mouseCircle:delete() end)
end

global_border = nil

function redrawBorder()
    win = hs.window.focusedWindow()
    if win ~= nil then
        top_left = win:topLeft()
        size = win:size()
        if global_border ~= nil then
            global_border:delete()
        end
        global_border = hs.drawing.rectangle(hs.geometry.rect(top_left['x'], top_left['y'], size['w'], size['h']))
        global_border:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=0.8})
        global_border:setFill(false)
        global_border:setStrokeWidth(8)
        global_border:show()
    end
end

redrawBorder()

allwindows = hs.window.filter.new(nil)
allwindows:subscribe(hs.window.filter.windowCreated, function () redrawBorder() end)
allwindows:subscribe(hs.window.filter.windowFocused, function () redrawBorder() end)
allwindows:subscribe(hs.window.filter.windowMoved, function () redrawBorder() end)
allwindows:subscribe(hs.window.filter.windowUnfocused, function () redrawBorder() end)

hs.hotkey.bind({'cmd', 'alt'}, 'i', function()
    -- hs.alert.show('launching iterm')
    ret = hs.application.launchOrFocus('iTerm')
    -- ret = hs.application.launchOrFocus('iTerm2')
    -- ret = hs.application.launchOrFocus('iTerm 2')
    -- hs.alert.show(ret)
    -- local iterm = hs.appfinder.appFromName('Safari')
    -- local iterm = hs.appfinder.appFromName('iTerm')
    -- hs.application.launchOrFocus(iterm)
    -- hs.alert.show(iterm:title())
end)

-- hs.hotkey.bind({'cmd', 'ctrl'}, 'h', move_focused_window_left)
-- hs.hotkey.bind({'cmd', 'ctrl'}, 'l', move_focused_window_right)
-- hs.hotkey.bind({'cmd', 'alt'}, 'h', move_left)
-- hs.hotkey.bind({'cmd', 'alt'}, 'l', move_right)

-- hs.hotkey.bind({}, 'F12', function() hs.osascript.applescript('set curVolume to get volume settings if output muted of curVolume is false then set volume with output muted else set volume without output muted end if') end)
-- hs.hotkey.bind({}, 'F11', function() hs.osascript.applescript("set volume output volume (output volume of (get volume settings) + 1) --100%") end)
--
-- hs.hotkey.bind({}, 'F12', function() hs.osascript.applescript('set curVolume to get volume settings if output muted of curVolume is false then set volume with output muted else set volume without output muted end if') end)
-- hs.hotkey.bind({}, 'F11', function() hs.osascript.applescript("set volume output volume (output volume of (get volume settings) + 1) --100%") end)
-- hs.hotkey.bind({}, 'F10', function() hs.osascript.applescript("set volume output volume (output volume of (get volume settings) + 1) --100%") end)
--
-- -- hs.hotkey.bind({'cmd', 'alt'}, 'Left', function() hs.osascript.applescript("set volume output volume (output volume of (get volume settings) + 1) --100%") end)
-- hs.hotkey.bind({}, 'f10', function() hs.osascript.applescript("set volume output volume (output volume of (get volume settings) + 1) --100%") end)
-- hs.hotkey.bind({}, 'F12', move_left)

toggle_vol = function() os.execute('./toggle.sh') end
lower_vol = function() os.execute('./lower.sh') end
raise_vol = function() os.execute('./raise.sh') end

hs.hotkey.bind({}, 'f12', toggle_vol, function() end, toggle_vol)
hs.hotkey.bind({}, 'f10', raise_vol, function() end, raise_vol)
hs.hotkey.bind({}, 'f9', lower_vol, function() end, lower_vol)

hs.hotkey.bind({'cmd', 'alt'}, 'Left', move_left)
hs.hotkey.bind({'cmd', 'alt'}, 'Right', move_right)
hs.hotkey.bind({'cmd', 'ctrl'}, 'h', move_left)
hs.hotkey.bind({'cmd', 'ctrl'}, 'l', move_right)
hs.hotkey.bind({'cmd', 'ctrl'}, 'k', maximize_window)
hs.hotkey.bind({'cmd', 'alt'}, 'Up', maximize_window)


hs.hotkey.bind({'cmd', 'shift', 'alt'}, 'h', function() hs.window.focusedWindow():moveOneScreenWest() end)
hs.hotkey.bind({'cmd', 'shift', 'alt'}, 'l', function() hs.window.focusedWindow():moveOneScreenEast() end)
hs.hotkey.bind({'cmd', 'shift', 'ctrl'}, 'h', function() hs.window.focusedWindow():moveOneScreenWest() end)
hs.hotkey.bind({'cmd', 'shift', 'ctrl'}, 'l', function() hs.window.focusedWindow():moveOneScreenEast() end)
hs.hotkey.bind({'cmd', 'shift', 'alt'}, 'Left', function() hs.window.focusedWindow():moveOneScreenWest() end)
hs.hotkey.bind({'cmd', 'shift', 'alt'}, 'Right', function() hs.window.focusedWindow():moveOneScreenEast() end)

hs.hotkey.bind({'cmd', 'alt'}, 'y', move_topleft)
hs.hotkey.bind({'cmd', 'alt'}, 'o', move_topright)
hs.hotkey.bind({'cmd', 'alt'}, 'n', move_botleft)
hs.hotkey.bind({'cmd', 'alt'}, '.', move_botright)

hs.hotkey.bind({'cmd', 'ctrl'}, 'y', move_topleft)
hs.hotkey.bind({'cmd', 'ctrl'}, 'o', move_topright)
hs.hotkey.bind({'cmd', 'ctrl'}, 'n', move_botleft)
hs.hotkey.bind({'cmd', 'ctrl'}, '.', move_botright)

hs.hotkey.bind({'cmd', 'alt'}, 'h', focus_left)
hs.hotkey.bind({'cmd', 'alt'}, 'l', focus_right)

hs.hotkey.bind({'cmd', 'shift'}, 'h', focus_left)
hs.hotkey.bind({'cmd', 'shift'}, 'l', focus_right)
hs.hotkey.bind({'cmd', 'shift'}, 'j', focus_south)
hs.hotkey.bind({'cmd', 'shift'}, 'k', focus_north)

-- hs.hints.style = 'vimperator'
hs.hints.showTitleThresh = 10
-- hs.hotkey.bind({'cmd', 'alt'}, 'p', hs.hints.windowHints)
hs.hotkey.bind({'cmd'}, 'p', hs.hints.windowHints)

------------------------------------------------
-- Expose
------------------------------------------------
-- set up your instance(s)
expose = hs.expose.new(nil,{showThumbnails=false}) -- default windowfilter, no thumbnails
expose_app = hs.expose.new(nil,{onlyActiveApplication=true}) -- show windows for the current application
expose_space = hs.expose.new(nil,{includeOtherSpaces=false}) -- only windows in the current Mission Control Space
expose_browsers = hs.expose.new{'Safari','Google Chrome'} -- specialized expose using a custom windowfilter
-- for your dozens of browser windows :)

-- then bind to a hotkey
hs.expose.ui.maxHintLetters = 1
hs.hotkey.bind('ctrl-cmd','e','Expose',function()expose:toggleShow()end)
hs.hotkey.bind('ctrl-cmd-shift','e','App Expose',function()expose_app:toggleShow()end)
hs.hotkey.bind('cmd','e','Expose',function()expose:toggleShow()end)


------------------------------------------------
-- TILE WINDOWS ON CURRENT SCREEN
------------------------------------------------
hs.hotkey.bind({'cmd', 'ctrl'}, 't', function()
    local wins = hs.window.filter.new():setCurrentSpace(true):getWindows()
    local screen = hs.screen.mainScreen():currentMode()
    local rect = hs.geometry(0, 0, screen['w'], screen['h'])
    hs.window.tiling.tileWindows(wins, rect)
end)

------------------------------------------------
-- GRID
------------------------------------------------
hs.grid.setGrid('6x6')
hs.grid.setMargins('0x0')
hs.hotkey.bind({'cmd'}, 'g', hs.grid.show)
hs.hotkey.bind({'cmd'}, 'h', hs.grid.show)
------------------------------------------------
-- GRID
------------------------------------------------


hs.window.animationDuration = 0
hs.alert.show('Config loaded!')

function reloadConfig()
    if configFileWatcher ~= nil then
        configFileWatcher:stop()
        configFileWatcher = nil
    end

    hs.reload()
end

configFileWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/init.lua", reloadConfig)
configFileWatcher:start()
-- hs.alert('reloaded')
