#include <GUIConstantsEx.au3>
#include <GuiMenu.au3>
#include <GuiStatusBar.au3>

; ======================================================================
;   CREATE MAIN GUI WINDOW
; ======================================================================
$hGUI = GUICreate("Dransik ClassiK Editor", 1200, 700)
GUISetIcon(@ScriptDir & "\Assets\Dransik Editor.ico")


; ======================================================================
;   MENU BAR - FILE
; ======================================================================
$FileMenu        = GUICtrlCreateMenu("File")
$miOpenUsecode   = GUICtrlCreateMenuItem("Open Usecode",    $FileMenu) ; #01
$miNewUsecode    = GUICtrlCreateMenuItem("New Usecode",     $FileMenu) ; #02
GUICtrlCreateMenuItem("", $FileMenu)  ; separator
$miCreateLocal   = GUICtrlCreateMenuItem("Create Local Data", $FileMenu) ; #03
$miCreateGame    = GUICtrlCreateMenuItem("Create Game Data",  $FileMenu) ; #04
GUICtrlCreateMenuItem("", $FileMenu)
$miExit          = GUICtrlCreateMenuItem("Exit",            $FileMenu) ; #05


; ======================================================================
;   MENU BAR - ARTWORK
; ======================================================================
$ArtworkMenu     = GUICtrlCreateMenu("Artwork")
$miImportArtwork = GUICtrlCreateMenuItem("Import", $ArtworkMenu) ; #06


; ======================================================================
;   MENU BAR - EDIT
; ======================================================================
$EditMenu     = GUICtrlCreateMenu("Edit")
$miNpcEditor  = GUICtrlCreateMenuItem("Npc Editor",   $EditMenu) ; #07
$miMapEditor  = GUICtrlCreateMenuItem("Map Editor",   $EditMenu) ; #08
$miAnimEditor = GUICtrlCreateMenuItem("Anim Editor",  $EditMenu) ; #09
$miTypeEditor = GUICtrlCreateMenuItem("Type Editor",  $EditMenu) ; #10
$miShopEditor = GUICtrlCreateMenuItem("Shop Editor",  $EditMenu) ; #11
$miEncounters = GUICtrlCreateMenuItem("Encounters",   $EditMenu) ; #12
$miTreasures  = GUICtrlCreateMenuItem("Treasures",    $EditMenu) ; #13
$miTradeData  = GUICtrlCreateMenuItem("Trade Data",   $EditMenu) ; #14


; ======================================================================
;   MENU BAR - GAME DATA
; ======================================================================
$GameDataMenu     = GUICtrlCreateMenu("Game Data")
$miExportClient   = GUICtrlCreateMenuItem("Export Client", $GameDataMenu) ; #15
$miExportServer   = GUICtrlCreateMenuItem("Export Server", $GameDataMenu) ; #16

GUICtrlSetState($miExportClient, $GUI_DISABLE)
GUICtrlSetState($miExportServer, $GUI_DISABLE)


; ======================================================================
;   MENU BAR - USECODE
; ======================================================================
$UsecodeMenu     = GUICtrlCreateMenu("Usecode")
$miOpenFile      = GUICtrlCreateMenuItem("Open File",     $UsecodeMenu) ; #17
$miNewFile       = GUICtrlCreateMenuItem("New File",      $UsecodeMenu) ; #18
$miCompileFile   = GUICtrlCreateMenuItem("Compile File",  $UsecodeMenu) ; #19
$miBuildAll      = GUICtrlCreateMenuItem("Build All",     $UsecodeMenu) ; #20


; ======================================================================
;   MENU BAR - EXPORT
; ======================================================================
$ExportMenu  = GUICtrlCreateMenu("Export")
$miExportWep = GUICtrlCreateMenuItem("Export Wep n Armor", $ExportMenu) ; #21


; ======================================================================
;   MENU BAR - VIEW
; ======================================================================
$ViewMenu        = GUICtrlCreateMenu("View")
$miViewToolbar   = GUICtrlCreateMenuItem("Toolbar",    $ViewMenu) ; #22
$miViewStatusbar = GUICtrlCreateMenuItem("Status Bar", $ViewMenu) ; #23
GUICtrlCreateMenuItem("", $ViewMenu)
$miMapPosition   = GUICtrlCreateMenuItem("Map Position", $ViewMenu) ; #24
GUICtrlSetState($miMapPosition, $GUI_DISABLE)

GUICtrlSetState($miViewToolbar,   $GUI_CHECKED)
GUICtrlSetState($miViewStatusbar, $GUI_CHECKED)


; ======================================================================
;   MENU BAR - HELP
; ======================================================================
$HelpMenu = GUICtrlCreateMenu("Help")
$miAbout  = GUICtrlCreateMenuItem("About Dransik Editor...", $HelpMenu) ; #25


; ======================================================================
;   STATUS BAR
; ======================================================================
Global $aParts[2] = [120, -1]
$hStatus = _GUICtrlStatusBar_Create($hGUI)
_GUICtrlStatusBar_SetParts($hStatus, $aParts)
_GUICtrlStatusBar_SetText($hStatus, "Ready")

GUISetState(@SW_SHOW)



; ======================================================================
;   MAIN MESSAGE LOOP
; ======================================================================
While True

    ; Get menu item ID
    $msg = GUIGetMsg()

    ; Handle window close
    If $msg = $GUI_EVENT_CLOSE Then Exit

    ; Handle all menu clicks
    Switch $msg

        ; FILE MENU (1–5)
        Case $miOpenUsecode    ;1
            MsgBox(64, "1", "Nothing added here yet (1)")
        Case $miNewUsecode     ;2
            MsgBox(64, "2", "Nothing added here yet (2)")
        Case $miCreateLocal    ;3
            MsgBox(64, "3", "Nothing added here yet (3)")
        Case $miCreateGame     ;4
            MsgBox(64, "4", "Nothing added here yet (4)")
        Case $miExit           ;5
            Exit


        ; ARTWORK (6)
        Case $miImportArtwork  ;6
            MsgBox(64, "6", "Nothing added here yet (6)")


        ; EDIT (7–14)
        Case $miNpcEditor      ;7
            MsgBox(64, "7", "Nothing added here yet (7)")
        Case $miMapEditor      ;8
            MsgBox(64, "8", "Nothing added here yet (8)")
        Case $miAnimEditor     ;9
            MsgBox(64, "9", "Nothing added here yet (9)")
        Case $miTypeEditor     ;10
            MsgBox(64, "10", "Nothing added here yet (10)")
        Case $miShopEditor     ;11
            MsgBox(64, "11", "Nothing added here yet (11)")
        Case $miEncounters     ;12
            MsgBox(64, "12", "Nothing added here yet (12)")
        Case $miTreasures      ;13
            MsgBox(64, "13", "Nothing added here yet (13)")
        Case $miTradeData      ;14
            MsgBox(64, "14", "Nothing added here yet (14)")


        ; GAME DATA (15–16)
        Case $miExportClient   ;15
            MsgBox(64, "15", "Nothing added here yet (15)")
        Case $miExportServer   ;16
            MsgBox(64, "16", "Nothing added here yet (16)")


        ; USECODE (17–20)
        Case $miOpenFile       ;17
            MsgBox(64, "17", "Nothing added here yet (17)")
        Case $miNewFile        ;18
            MsgBox(64, "18", "Nothing added here yet (18)")
        Case $miCompileFile    ;19
            MsgBox(64, "19", "Nothing added here yet (19)")
        Case $miBuildAll       ;20
            MsgBox(64, "20", "Nothing added here yet (20)")


        ; EXPORT (21)
        Case $miExportWep      ;21
            MsgBox(64, "21", "Nothing added here yet (21)")


        ; VIEW (22–24)
        Case $miViewToolbar    ;22
            MsgBox(64, "22", "Nothing added here yet (22)")
        Case $miViewStatusbar  ;23
            MsgBox(64, "23", "Nothing added here yet (23)")
        Case $miMapPosition    ;24
            MsgBox(64, "24", "Nothing added here yet (24)")


        ; HELP (25)
        Case $miAbout          ;25
            MsgBox(64, "25", "Nothing added here yet (25)")

    EndSwitch

WEnd
