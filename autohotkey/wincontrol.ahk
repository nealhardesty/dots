/*
autohotkey key bindings, mostly window control stuff

Quickref -> https://www.autohotkey.com/docs/AutoHotkey.htm
Hotkeyref -> https://www.autohotkey.com/docs/Hotkeys.htm

icon -> https://iconarchive.com/show/meow-icons-by-iconka.html

^ -> Control
! -> Alt
+ -> Shift
# -> Command or WinKey
*/

; ***EXEC BINDINGS***
^!+b::Run https://google.com ; launch a web browser
^!t::
^!+t::WindowsTerminal( (Run_As_Administrator:=false) )

; ***WINDOW CONTROL BINDINGS***
^!1::
^!+1::MoveWindowByPercent(0, 0, 33.33, 100)
^!2::
^!+2::MoveWindowByPercent(33.33, 0, 33.33, 100)
^!3::
^!+3::MoveWindowByPercent(66.66, 0, 33.33, 100)
^!4::
^!+4::MoveWindowByPercent(0, 0, 25.0, 100)
^!5::
^!+5::MoveWindowByPercent(25.0, 0, 25.0, 100)
^!6::
^!+6::MoveWindowByPercent(50.0, 0, 25.0, 100)
^!7::
^!+7::MoveWindowByPercent(75.0, 0, 25.0, 100)
^!u::
^!+u::MoveWindowByPercent(0, 0, 50.0, 50.0)
^!i::
^!+i::MoveWindowByPercent(50.0, 0, 50.0, 50.0)
^!j::
^!+j::MoveWindowByPercent(0, 50.0, 50.0, 50.0)
^!k::
^!+k::MoveWindowByPercent(50.0, 50.0, 50.0, 50.0)

^!Left::
^!+Left::
^!h::
^!+h::MoveWindowByPercent(0, 0, 50.0, 100.0)

^!Right::
^!+Right::
^!l::
^!+l::MoveWindowByPercent(50.0, 0, 50.0, 100.0)

^!Up::
^!+Up::MoveWindowByPercent(0, 0, 100.0, 50.0 )
^!Down::
^!+Down::MoveWindowByPercent(0, 50.0, 100.0, 50.0 )
^!Enter::
^!+Enter::ToggleMaximize()

; *** SCREEN CONTROL BINDINGS ***
;^p::DisplaySwitch.exe ; This is a Windows Default (Note, it cycles!)
^!c::
^!+c::Run DisplaySwitch.exe /clone ; mirror displays
^!e::
^!+e::Run DisplaySwitch.exe /extend ; extend displays
^!F1::
^!+F1::Run desk.cpl ; Open Displays Control Panel
^!F2::
^!+F2::ChangeResolution((ScreenWidth:=1920), (Screen_Height:=1080)) ; set primary resolution 1920x1080 (good remote resolution)
^!F3::
^!+F3::ChangeResolution((ScreenWidth:=3440), (Screen_Height:=1440)) ; set primary resolution 3440x1440 (for the asus widescreens)
^!F4::
^!+F4::ChangeResolution((ScreenWidth:=3440), (Screen_Height:=1440), (Refresh_Rate:=100)) ; set primary resolution 3440x1440 (for the asus widescreens)

; *** SOUND CONTROL BINDINGS ***
^![::
^!+[::Send {Volume_Down 2}
^!]::
^!+]::Send {Volume_Up 2}
^!\::
^!+\::Send {Volume_Mute}

; *** RELOAD THIS SCRIPT ***  
^!+Backspace::Reload

; *** GLOBAL FUNCTIONS ***
IsInRDP() {
    ; https://www.autohotkey.com/docs/commands/SysGet.htm
    ; 8192 = SM_REMOTECONTROL
    ; 4096 = SM_REMOTESESSION (false if in console RDP)
    SysGet, IsInTerminalServicesEnvironment, 8192
    Return IsInTerminalServicesEnvironment
}
ChangeResolution(Screen_Width := 1920, Screen_Height := 1080,  Refresh_Rate := 0, Color_Depth := 32) {
	VarSetCapacity(Device_Mode,156,0)
	NumPut(156,Device_Mode,36) 
	DllCall( "EnumDisplaySettingsA", UInt,0, UInt,-1, UInt, &Device_Mode )
	NumPut(0x5c0000,Device_Mode,40) 
	NumPut(Color_Depth,Device_Mode,104)
	NumPut(Screen_Width,Device_Mode,108)
	NumPut(Screen_Height,Device_Mode,112)
    If (Refresh_Rate > 0) {
	  NumPut(Refresh_Rate,Device_Mode,120)
    }
	Return DllCall("ChangeDisplaySettingsA", UInt, &Device_Mode, UInt,0 )
}
MoveWindowByPercent(X_Percent, Y_Percent, Width_Percent, Height_Percent) {
    winHandle := WinExist("A") ; The window to operate on

    VarSetCapacity(monitorInfo, 40), NumPut(40, monitorInfo)
    monitorHandle := DllCall("MonitorFromWindow", "Ptr", winHandle, "UInt", 0x2)
    DllCall("GetMonitorInfo", "Ptr", monitorHandle, "Ptr", &monitorInfo)

    Work_Left := NumGet(monitorInfo, 20, "Int")
    Work_Top := NumGet(monitorInfo, 24, "Int")
    Work_Right := NumGet(monitorInfo, 28, "Int")
    Work_Bottom := NumGet(monitorInfo, 32, "Int")
    Is_Primary:= NumGet(monitorInfo, 36, "Int")

    Work_Width := Work_Right - Work_Left
    Work_Height := Work_Bottom - Work_Top

    Win_X := Round(Work_Left + (Work_Width * (X_Percent/100.0)))
    Win_Y := Round(Work_Top + (Work_Height * (Y_Percent/100.0)))
    Win_Width := Round(Work_Width * (Width_Percent/100.0))
    Win_Height := Round(Work_Height * (Height_Percent/100.0))

    WinMove, A,,Win_X,Win_Y,Win_Width,Win_Height

    Return
}
ToggleMaximize() {
    WinGet MX, MinMax, A
    If MX
        WinRestore A
    Else
        WinMaximize A
    return
}
WindowsTerminal(Run_As_Administrator := false) {
  wt_handle:= WinExist("ahk_exe WindowsTerminal.exe")
  if (wt_handle > 0) {
      ; unminimize
    WinActivate, "ahk_id %wt_handle%"
    WinShow, "ahk_id %wt_handle%"
  } else {
    ;Run, *RunAs wt
    if (Run_As_Administrator) {
        msgbox as admin
        Run *RunAs wt.exe /restart
    } else {
        Run wt.exe
    }
  }
}
