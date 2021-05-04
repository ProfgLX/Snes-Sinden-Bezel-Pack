#NoEnv
SetBatchLines -1
ListLines Off

;*****************************Change Bezel path HERE********************
BezelPath := ".\SindenBezels\Operation Thunderbolt (USA).png"
;***********************************************************************************

Run, snes9x.exe -port2 Superscope "Operation Thunderbolt (USA).sfc" -fullscreen
sleep,200

;STARTS NOMOUSY TO HIDE CURSOR WHEN ON TOP OF BEZEL
Run,%A_ScriptDir%\SindenBezels\nomousy.exe /hide
sleep,200

IfWinNotExist, frame
{
	SysGet, m1, Monitor, 1
	CustomColor = 000000f  ; Can be any RGB color (it will be made transparent below).
	Gui, 88:+Toolwindow
	Gui, 88:+0x94C80000
	Gui, 88:+E0x20 ; this makes this GUI clickthrough
	Gui, 88:-Toolwindow
	Gui, 88: +LastFound +AlwaysOnTop -Caption +ToolWindow  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
	Gui, 88: Color, %CustomColor%
	Gui, 88: Add, Picture, x0 y0 w%m1right% h%m1Bottom% BackGroundTrans, %BezelPath%
	WinSet, TransColor, %CustomColor% ;150	; Make all pixels of this color transparent and make the text itself translucent (150)
	Gui, 88: Show, x0 y0 w%m1right% h%m1Bottom% NoActivate, frame ; NoActivate avoids deactivating the currently active window.
}

; 
; Close Overlay
; 
SubOverlayClose:
  Gui, GUI_Overlay:Destroy
  Return

;SuperScope Cursor button BOUND TO LEFT MOUSE BUTTON
$LButton::g

;SuperScope Trigger button BOUND TO RIGHT MOUSE BUTTON
$RButton::h

;START BUTTON / BOUND TO KEYBOARD 1, LIKE MAME DEFAULT START. CHANGE 1 TO WHATEVER YOU WANT START TO BE
$1::/


$Esc::
    Process,Close,snes9x.exe
    Run,taskkill /im "snes9x.exe" /F
	Sleep, 200
	Run,%A_ScriptDir%\SindenBezels\nomousy.exe
	ExitApp
	Return
	