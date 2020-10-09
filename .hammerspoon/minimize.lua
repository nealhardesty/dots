-- https://github.com/rkalis/dotfiles/blob/master/hammerspoon/minimising.lua

hs.hotkey.bind({"cmd", "alt"}, "m", function()
  --print("starting")

  for _, win in ipairs(hs.window.minimizedWindows()) do
      print("unminimizing ")
      win:unminimize()
      print("unminimize done ")
      break
  end
end)