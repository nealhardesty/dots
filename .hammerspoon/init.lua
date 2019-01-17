-- Window manipulation hotkeys
hs.hotkey.bind({"ctrl", "alt"}, "Left", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind({"ctrl", "alt"}, "Right", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind({"ctrl", "alt"}, "Up", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h / 2
  win:setFrame(f)
end)

hs.hotkey.bind({"ctrl", "alt"}, "Down", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y + (max.h / 2)
  f.w = max.w
  f.h = max.h / 2
  win:setFrame(f)
end)

hs.hotkey.bind({"ctrl", "alt"}, "Return", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "Left", function()
  local win = hs.window.focusedWindow()
	win:moveOneScreenWest()
end)

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "Right", function()
  local win = hs.window.focusedWindow()
	win:moveOneScreenEast()
end)

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "Up", function()
  local win = hs.window.focusedWindow()
	win:moveOneScreenNorth()
end)

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "Down", function()
  local win = hs.window.focusedWindow()
	win:moveOneScreenSouth()
end)

