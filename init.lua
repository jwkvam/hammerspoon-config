-- hs.hotkey.bind({'cmd', 'alt', 'ctrl'}, 'W', function()
--     hs.alert.show('Hello World!')
-- end)

configFileWatcher = nil
border = nil
border_drawer = nil

function move_left()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
end

function move_right()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 2)
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
end

function move_topleft()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end

function move_topright()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 2)
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end

function move_botleft()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y + (max.h / 2)
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end

function move_botright()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 2)
    f.y = max.y + (max.h / 2)
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end

function maximize_window()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h
    win:setFrame(f)
end

function focus_left()
    local win = hs.window.focusedWindow()
    win:focusWindowWest()
end

function focus_right()
    local win = hs.window.focusedWindow()
    win:focusWindowEast()
end

function focus_south()
    local win = hs.window.focusedWindow()
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

border_drawer = hs.application.watcher.new(function (name, event, app)
    -- TODO update when window events are hopefully added
    if event == hs.application.watcher.activated then
        win = app:focusedWindow()
        if win ~= nil then
            top_left = win:topLeft()
            size = win:size()
            if border ~= nil then
                border:delete()
            end
            border = hs.drawing.rectangle(hs.geometry.rect(top_left['x'], top_left['y'], size['w'], size['h']))
            border:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=0.8})
            border:setFill(false)
            border:setStrokeWidth(4)
            border:show()
        end
    end
end)

border_drawer:start()

hs.hotkey.bind({'cmd', 'alt'}, 'Left', move_left)
hs.hotkey.bind({'cmd', 'alt'}, 'Right', move_right)
hs.hotkey.bind({'cmd', 'alt'}, 'Up', maximize_window)

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
hs.hotkey.bind({'cmd', 'alt'}, 'h', move_left)
hs.hotkey.bind({'cmd', 'alt'}, 'l', move_right)

hs.hotkey.bind({'cmd', 'shift', 'alt'}, 'h', function() hs.window.focusedWindow():moveOneScreenWest() end)
hs.hotkey.bind({'cmd', 'shift', 'alt'}, 'l', function() hs.window.focusedWindow():moveOneScreenEast() end)

hs.hotkey.bind({'cmd', 'alt'}, 'y', move_topleft)
hs.hotkey.bind({'cmd', 'alt'}, 'o', move_topright)
hs.hotkey.bind({'cmd', 'alt'}, 'n', move_botleft)
hs.hotkey.bind({'cmd', 'alt'}, '.', move_botright)

hs.hotkey.bind({'cmd', 'ctrl'}, 'h', focus_left)
hs.hotkey.bind({'cmd', 'ctrl'}, 'l', focus_right)

-- hs.hints.style = 'vimperator'
hs.hotkey.bind({'cmd', 'alt'}, 'p', hs.hints.windowHints)
hs.hotkey.bind({'cmd'}, 'p', hs.hints.windowHints)

-- hs.hotkey.bind({'cmd', 'shift'}, 'd', mouseHighlight)


hs.window.animationDuration = 0
hs.alert.show('Config loaded!')

function reloadConfig()
    if configFileWatcher ~= nil then
        configFileWatcher:stop()
        configFileWatcher = nil
    end

    if border_drawer ~= nil then
        border_drawer:stop()
        border_drawer = nil
    end

    if border ~= nil then
        border:delete()
        border = nil
    end

    hs.reload()
end

configFileWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/init.lua", reloadConfig)
configFileWatcher:start()
