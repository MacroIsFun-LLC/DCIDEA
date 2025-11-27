#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>

; =====================================================================
;   ⭐ IMPORTANT ⭐  Disable DPI virtualization so GUI is not distorted
; =====================================================================
DllCall("User32.dll", "bool", "SetProcessDPIAware")

; =====================================================================
;   WINDOW (226 x 178) — scaled slightly for modern UI breathing space
; =====================================================================
GUICreate("Dialog", 260, 210)

; ----------------------------
; LEFT SIDE (To Hit, Damage)
; ----------------------------
GUICtrlCreateLabel("To Hit Modifier:", 15, 9, 80, 15)
$txtHit  = GUICtrlCreateInput("", 100, 7, 50, 18)

GUICtrlCreateLabel("Min Damage:", 21, 23, 80, 15)
$txtMinDmg = GUICtrlCreateInput("", 100, 22, 50, 18)

GUICtrlCreateLabel("Max Damage:", 19, 39, 80, 15)
$txtMaxDmg = GUICtrlCreateInput("", 100, 37, 50, 18)

GUICtrlCreateLabel("Speed:", 40, 54, 80, 15)
$txtSpeed = GUICtrlCreateInput("", 100, 52, 50, 18)

GUICtrlCreateLabel("Min Health:", 25, 69, 80, 15)
$txtMinHP = GUICtrlCreateInput("", 100, 67, 50, 18)

GUICtrlCreateLabel("Max Health:", 23, 85, 80, 15)
$txtMaxHP = GUICtrlCreateInput("", 100, 82, 50, 18)

; ----------------------------
; FLAGS GROUPBOX
; ----------------------------
GUICtrlCreateGroup("Flags", 21, 104, 100, 70)
$chkRepair = GUICtrlCreateCheckbox("Can be repaired", 31, 114, 120, 18)
$chkRanged = GUICtrlCreateCheckbox("Ranged Weapon", 31, 125, 120, 18)
$chkMagic  = GUICtrlCreateCheckbox("Magic", 31, 136, 60, 18)
GUICtrlCreateGroup("", -99, -99, 1, 1)

; ----------------------------
; RIGHT SIDE — CLASS + ALIGN
; ----------------------------
GUICtrlCreateLabel("Class:", 135, 9, 60, 15)
$cbClass = GUICtrlCreateCombo("", 158, 7, 80, 90, $CBS_DROPDOWNLIST)

GUICtrlCreateLabel("Alignment:", 121, 25, 80, 15)
$cbAlign = GUICtrlCreateCombo("", 158, 23, 80, 90, $CBS_DROPDOWNLIST)

; ----------------------------
; ATTRIBUTE REQUIREMENTS
; ----------------------------
GUICtrlCreateGroup("Attribute Requirements", 121, 41, 150, 120)

GUICtrlCreateLabel("Min Level:", 131, 57, 80, 15)
$txtMinLvl = GUICtrlCreateInput("", 190, 55, 50, 18)

GUICtrlCreateLabel("Min Str:", 140, 71, 80, 15)
$txtMinStr = GUICtrlCreateInput("", 190, 70, 50, 18)

GUICtrlCreateLabel("Min Int:", 141, 84, 80, 15)
$txtMinInt = GUICtrlCreateInput("", 190, 84, 50, 18)

GUICtrlCreateLabel("Min Dex:", 136, 100, 80, 15)
$txtMinDex = GUICtrlCreateInput("", 190, 99, 50, 18)

GUICtrlCreateLabel("Min Con:", 136, 113, 80, 15)
$txtMinCon = GUICtrlCreateInput("", 190, 112, 50, 18)

GUICtrlCreateGroup("", -99, -99, 1, 1)

; ----------------------------
; BUTTONS
; ----------------------------
$btnOK     = GUICtrlCreateButton("OK", 7, 170, 60, 24)
$btnCancel = GUICtrlCreateButton("Cancel", 185, 170, 60, 24)

GUISetState()

; =====================================================================
; MESSAGE LOOP
; =====================================================================
While True
    $msg = GUIGetMsg()
    Switch $msg
        Case $GUI_EVENT_CLOSE, $btnCancel
            Exit
        Case $btnOK
            MsgBox(64, "OK", "Values accepted")
    EndSwitch
WEnd
