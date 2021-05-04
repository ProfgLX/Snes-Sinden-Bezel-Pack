#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;; #Warn  ; Enable warnings to assist with detecting common errors.
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#NoEnv
SetBatchLines -1
ListLines Off

SetTitleMatchMode,2

;*****************************Change Bezel path HERE********************
BezelPath := ".\SindenBezels\Lethal Enforcers.png"
;***********************************************************************************

Run, snes9x.exe -port2 Justifier "Lethal Enforcers (USA).sfc" -fullscreen
sleep,200


;DETERMINE THE PIXEL TO SHOOT FOR RELOAD
SysGet, m1, Monitor, 1
LeftPixel := Floor((m1right - ((m1bottom/7)*8))/2)
RightPixel := Floor(m1right - LeftPixel)
ReloadPosition := LeftPixel - 10

;STARTS NOMOUSY TO HIDE CURSOR WHEN ON TOP OF BEZEL
Run,%A_ScriptDir%\SindenBezels\nomousy.exe /hide
sleep,200

IfWinNotExist, frame
{
	CustomColor = 000000f  ; Can be any RGB color (it will be made transparent below).
	Gui, 88:+Toolwindow
	Gui, 88:+0x94C80000
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

$LButton::
	MouseGetPos, xposa, yposa		;Prend la position de la souris et le nom de la fenêtre
	if ((xposa < LeftPixel and xposa >= 0) or (xposa > RightPixel and xposa <= m1right))
		{
		BlockInput, On
		MouseMove, %ReloadPosition%, 500, 0
		sleep, 2
		Send {v down}
		sleep, 2
		Send {v up}
		sleep, 2
		MouseMove, xposa, yposa, 0		;Restitue la position de la souris
		BlockInput, Off
		Return
		}
	else
		{
		send {LButton down}
		sleep, 2
		send {LButton up}
		Return
		}
	Return
		
$RButton::
	MouseGetPos, xposb, yposb		;Prend la position de la souris
	BlockInput, On
	MouseMove, %ReloadPosition%, 500, 0
	sleep 2
	Send {v down}
	sleep 2
	Send {v up}
	sleep,2
	MouseMove, xposb, yposb, 0		;Restitue la position de la souris
	BlockInput, Off
	Return

	
$1::Rbutton			;Whatever you want to be the Start button

$Esc::
    Process,Close,snes9x.exe
    Run,taskkill /im "snes9x.exe" /F
	sleep,200
	Run,%A_ScriptDir%\SindenBezels\nomousy.exe /hide
    ExitApp
	
	
Return