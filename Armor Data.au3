#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>

; =====================================================================
;   ? IMPORTANT ?  Disable DPI virtualization so GUI is NOT distorted
; =====================================================================
DllCall("User32.dll", "bool", "SetProcessDPIAware")

; ---------------------------------------------------------------------
;   Now the GUI uses TRUE pixels and matches your layout correctly
; ---------------------------------------------------------------------

GUICreate("Armor Data", 260, 185, -1, -1)

; Type / Protection
GUICtrlCreateLabel("Type:", 15, 15, 40, 15)
$cbType = GUICtrlCreateCombo("", 55, 12, 110, 100, $CBS_DROPDOWNLIST)

GUICtrlCreateLabel("Alignment:", 155, 15, 60, 15)
$cbAlignment = GUICtrlCreateCombo("", 220, 12, 100, 100, $CBS_DROPDOWNLIST)

GUICtrlCreateLabel("Protection Value:", 15, 42, 90, 15)
$txtProtValue = GUICtrlCreateInput("", 110, 40, 55, 18)

; Flags group
GUICtrlCreateGroup("Flags", 15, 65, 120, 60)
$chkRepairable = GUICtrlCreateCheckbox("Can be repaired", 25, 82, 100, 18)
$chkMagic = GUICtrlCreateCheckbox("Magic", 25, 102, 60, 18)
GUICtrlCreateGroup("", -99, -99, 1, 1)

; Health
GUICtrlCreateLabel("Min Health:", 20, 135, 65, 15)
$txtMinHealth = GUICtrlCreateInput("", 90, 133, 55, 18)

GUICtrlCreateLabel("Max Health:", 20, 160, 65, 15)
$txtMaxHealth = GUICtrlCreateInput("", 90, 158, 55, 18)

; Attributes
GUICtrlCreateGroup("Attribute Requirements", 150, 40, 165, 120)

GUICtrlCreateLabel("Min Level:", 160, 60, 60, 15)
$txtMinLvl = GUICtrlCreateInput("", 230, 58, 55, 18)

GUICtrlCreateLabel("Min Str:", 160, 82, 60, 15)
$txtMinStr = GUICtrlCreateInput("", 230, 80, 55, 18)

GUICtrlCreateLabel("Min Int:", 160, 104, 60, 15)
$txtMinInt = GUICtrlCreateInput("", 230, 102, 55, 18)

GUICtrlCreateLabel("Min Dex:", 160, 126, 60, 15)
$txtMinDex = GUICtrlCreateInput("", 230, 124, 55, 18)

GUICtrlCreateLabel("Min Con:", 160, 148, 60, 15)
$txtMinCon = GUICtrlCreateInput("", 230, 146, 55, 18)

GUICtrlCreateGroup("", -99, -99, 1, 1)

; Buttons
$btnOK = GUICtrlCreateButton("OK", 15, 160, 60, 22)
$btnCancel = GUICtrlCreateButton("Cancel", 205, 160, 60, 22)

GUISetState()

; -------------------------------------------------------------------
; Message loop
; -------------------------------------------------------------------
While True
    $msg = GUIGetMsg()
    Switch $msg
        Case $GUI_EVENT_CLOSE, $btnCancel
            Exit
        Case $btnOK
            MsgBox(64, "OK", "Values would be saved here")
    EndSwitch
WEnd
