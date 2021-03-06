function getFocusedWindow()
  return hs.window.focusedWindow()
end

function getScreenFrame()
  return getFocusedWindow():screen():frame()
end

function setFocusedFrame(x, y, w, h)
  local f = getFocusedWindow():frame()

  f.x = x
  f.y = y
  f.w = w
  f.h = h

  hs.window.focusedWindow():setFrame(f)
end

hs.hotkey.bind({"ctrl", "alt"}, "Left", function()
  setFocusedFrame(getScreenFrame().x, getScreenFrame().y, getScreenFrame().w / 2, getScreenFrame().h)
end)
hs.hotkey.bind({"ctrl", "alt"}, "h", function()
  setFocusedFrame(getScreenFrame().x, getScreenFrame().y, getScreenFrame().w / 2, getScreenFrame().h)
end)
hs.hotkey.bind({"ctrl", "alt"}, "Right", function()
  setFocusedFrame(getScreenFrame().x + (getScreenFrame().w / 2), getScreenFrame().y, getScreenFrame().w / 2, getScreenFrame().h)
end)
hs.hotkey.bind({"ctrl", "alt"}, "l", function()
  setFocusedFrame(getScreenFrame().x + (getScreenFrame().w / 2), getScreenFrame().y, getScreenFrame().w, getScreenFrame().h)
end)
hs.hotkey.bind({"ctrl", "alt"}, "Up", function()
  setFocusedFrame(getScreenFrame().x, getScreenFrame().y, getScreenFrame().w, getScreenFrame().h / 2)
end)
hs.hotkey.bind({"ctrl", "alt"}, "Down", function()
  setFocusedFrame(getScreenFrame().x, getScreenFrame().y + (getScreenFrame().h / 2), getScreenFrame().w, getScreenFrame().h / 2)
end)
hs.hotkey.bind({"ctrl", "alt"}, "Return", function()
  setFocusedFrame(getScreenFrame().x, getScreenFrame().y, getScreenFrame().w, getScreenFrame().h)
end)
hs.hotkey.bind({"ctrl", "alt"}, "u", function()
  setFocusedFrame(getScreenFrame().x, getScreenFrame().y, getScreenFrame().w / 2, getScreenFrame().h / 2)
end)
hs.hotkey.bind({"ctrl", "alt"}, "i", function()
  setFocusedFrame(getScreenFrame().x + (getScreenFrame().w / 2), getScreenFrame().y, getScreenFrame().w / 2, getScreenFrame().h / 2)
end)
hs.hotkey.bind({"ctrl", "alt"}, "j", function()
  setFocusedFrame(getScreenFrame().x, getScreenFrame().y + (getScreenFrame().h / 2), getScreenFrame().w / 2, getScreenFrame().h / 2)
end)
hs.hotkey.bind({"ctrl", "alt"}, "k", function()
  setFocusedFrame(getScreenFrame().x + (getScreenFrame().w / 2), getScreenFrame().y + (getScreenFrame().h / 2), getScreenFrame().w / 2, getScreenFrame().h / 2)
end)
hs.hotkey.bind({"ctrl", "alt"}, "1", function()
  setFocusedFrame(getScreenFrame().x, getScreenFrame().y, getScreenFrame().w / 3, getScreenFrame().h)
end)
hs.hotkey.bind({"ctrl", "alt"}, "2", function()
  setFocusedFrame(getScreenFrame().x + (getScreenFrame().w / 3), getScreenFrame().y, getScreenFrame().w / 3, getScreenFrame().h)
end)
hs.hotkey.bind({"ctrl", "alt"}, "3", function()
  setFocusedFrame(getScreenFrame().x + ((getScreenFrame().w / 3) * 2), getScreenFrame().y, getScreenFrame().w / 3, getScreenFrame().h)
end)
hs.hotkey.bind({"ctrl", "alt"}, "4", function()
  setFocusedFrame(getScreenFrame().x, getScreenFrame().y, getScreenFrame().w / 4, getScreenFrame().h)
end)
hs.hotkey.bind({"ctrl", "alt"}, "5", function()
  setFocusedFrame(getScreenFrame().x + (getScreenFrame().w / 4), getScreenFrame().y, getScreenFrame().w / 4, getScreenFrame().h)
end)
hs.hotkey.bind({"ctrl", "alt"}, "6", function()
  setFocusedFrame(getScreenFrame().x + ((getScreenFrame().w / 4) * 2), getScreenFrame().y, getScreenFrame().w / 4, getScreenFrame().h)
end)
hs.hotkey.bind({"ctrl", "alt"}, "7", function()
  setFocusedFrame(getScreenFrame().x + ((getScreenFrame().w / 4) * 3), getScreenFrame().y, getScreenFrame().w / 4, getScreenFrame().h)
end)

hs.hotkey.bind({"ctrl", "alt"}, "f", function()
  if getFocusedWindow():isFullScreen() then
    getFocusedWindow():setFullScreen(false)
  else
    getFocusedWindow():setFullScreen(true)
  end
end)

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "Left", function()
  getFocusedWindow():moveOneScreenWest()
end)
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "Right", function()
  getFocusedWindow():moveOneScreenEast()
end)
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "Up", function()
  getFocusedWindow():moveOneScreenNorth()
end)
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "Down", function()
  getFocusedWindow():moveOneScreenSouth()
end)

