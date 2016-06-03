-- hs.hotkey.bind({'cmd', 'alt', 'ctrl'}, 'W', function()
--     hs.alert.show('Hello World!')
-- end)

-- local grid = require "hs.grid"
--
-- require "keyboard_grid"

configFileWatcher = nil


---------------------------------------------------------
-- KEYBOARD-GRID WINDOW MANIPULATION
---------------------------------------------------------

-- # DEFINE A NEW GRID


-- local hyper = {'cmd', 'ctrl', 'alt', 'shift'}
-- local createNewGrid = hs.hotkey.modal.new(hyper, "W")
--
-- function createNewGridExit()
--   createNewGrid:exit()
--   mode.exit("keygrid", "newgrid")
-- end
--
-- createNewGrid:bind({}, 'escape', createNewGridExit)
--
-- function createNewGrid:entered()
--   mode.enter("keygrid", "newgrid")
--   hideGridfn = drawGrid()
--
--   local function hideGridAndExit()
--     if hideGridfn then hideGridfn() end
--     createNewGridExit()
--   end
--
--   newKeyboardGrid(hideGridAndExit)
-- end
--
-- -- # RESIZE
--
-- local resizeWithCell = hs.hotkey.modal.new(hyper, "Q")
--
-- function resizeWithCellExit()
--   resizeWithCell:exit()
--   mode.exit("keygrid", "resize")
-- end
-- createNewGrid:bind({}, 'escape', resizeWithCellExit)
--
-- function resizeWithCell:entered()
--   mode.enter("keygrid", "resize")
--   hideGridfn = drawGrid()
--
--   local function hideGridAndExit()
--     if hideGridfn then hideGridfn() end
--     resizeWithCellExit()
--   end
--
--   resizeGridWithCell(hideGridAndExit)
-- end

---------------------------------------------------------
-- KEYBOARD-GRID WINDOW MANIPULATION
---------------------------------------------------------

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

function focus_south()
    local win = hs.window.filter.new():setCurrentSpace(true)
    if win == nil then
        return
    end
    win:focusWindowEast()
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
    -- ret = hs.application.launchOrFocus('iTerm')
    -- ret = hs.application.launchOrFocus('iTerm2')
    ret = hs.application.launchOrFocus('iTerm 2')
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


hs.hotkey.bind({'cmd', 'alt'}, 'Left', move_left)
hs.hotkey.bind({'cmd', 'alt'}, 'Right', move_right)
hs.hotkey.bind({'cmd', 'alt'}, 'Up', maximize_window)


hs.hotkey.bind({'cmd', 'shift', 'alt'}, 'h', function() hs.window.focusedWindow():moveOneScreenWest() end)
hs.hotkey.bind({'cmd', 'shift', 'alt'}, 'l', function() hs.window.focusedWindow():moveOneScreenEast() end)
hs.hotkey.bind({'cmd', 'shift', 'alt'}, 'Left', function() hs.window.focusedWindow():moveOneScreenWest() end)
hs.hotkey.bind({'cmd', 'shift', 'alt'}, 'Right', function() hs.window.focusedWindow():moveOneScreenEast() end)

hs.hotkey.bind({'cmd', 'alt'}, 'y', move_topleft)
hs.hotkey.bind({'cmd', 'alt'}, 'o', move_topright)
hs.hotkey.bind({'cmd', 'alt'}, 'n', move_botleft)
hs.hotkey.bind({'cmd', 'alt'}, '.', move_botright)

hs.hotkey.bind({'cmd', 'alt'}, 'h', focus_left)
hs.hotkey.bind({'cmd', 'alt'}, 'l', focus_right)

-- hs.hints.style = 'vimperator'
hs.hotkey.bind({'cmd', 'alt'}, 'p', hs.hints.windowHints)
hs.hotkey.bind({'cmd'}, 'p', hs.hints.windowHints)

------------------------------------------------
-- GRID
------------------------------------------------
hs.grid.setGrid('4x4')
hs.grid.setMargins('0x0')
hs.hotkey.bind({'cmd'}, 'g', hs.grid.show)
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
