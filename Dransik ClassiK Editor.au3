#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Assets\Dransik Editor.ico
#AutoIt3Wrapper_Outfile=Dransik ClassiK Editor0.0.0.13.exe
#AutoIt3Wrapper_Res_Fileversion=0.0.0.14
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_ProductName=Dransik ClassiK Editor
#AutoIt3Wrapper_Res_CompanyName=MacroIsFunLLc
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_Icon_Add=Assets\Dransik Editor.ico
#AutoIt3Wrapper_Res_File_Add=Assets\Dransik Editor.ico, rt_icon, MAIN
#AutoIt3Wrapper_Add_Constants=n
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/sf
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <GUIConstantsEx.au3>
#include <GuiMenu.au3>
#include <GuiStatusBar.au3>

; ====================================================================================
;                               CREATE GUI WINDOW
; ====================================================================================
$hGUI = GUICreate("Dransik ClassiK Editor", 1200, 700)
GUISetIcon(@ScriptDir & "\Assets\Dransik Editor.ico")


; ====================================================================================
;                                      MENUBAR
; ====================================================================================

; ------------------------------ FILE MENU -------------------------------------------
$FileMenu        = GUICtrlCreateMenu("File")
$miOpenUsecode   = GUICtrlCreateMenuItem("Open Usecode",       $FileMenu)
$miNewUsecode    = GUICtrlCreateMenuItem("New Usecode",        $FileMenu)
GUICtrlCreateMenuItem("", $FileMenu)
$miCreateLocal   = GUICtrlCreateMenuItem("Create Local Data",  $FileMenu)
$miCreateGame    = GUICtrlCreateMenuItem("Create Game Data",   $FileMenu)
GUICtrlCreateMenuItem("", $FileMenu)
$miExit          = GUICtrlCreateMenuItem("Exit",               $FileMenu)

; ------------------------------ ARTWORK MENU ----------------------------------------
$ArtworkMenu     = GUICtrlCreateMenu("Artwork")
$miImportArtwork = GUICtrlCreateMenuItem("Import", $ArtworkMenu)

; ------------------------------ EDIT MENU -------------------------------------------
$EditMenu      = GUICtrlCreateMenu("Edit")
$miNpcEditor   = GUICtrlCreateMenuItem("Npc Editor",   $EditMenu)
$miMapEditor   = GUICtrlCreateMenuItem("Map Editor",   $EditMenu)
$miAnimEditor  = GUICtrlCreateMenuItem("Anim Editor",  $EditMenu)
$miTypeEditor  = GUICtrlCreateMenuItem("Type Editor",  $EditMenu)
$miShopEditor  = GUICtrlCreateMenuItem("Shop Editor",  $EditMenu)
$miEncounters  = GUICtrlCreateMenuItem("Encounters",   $EditMenu)
$miTreasures   = GUICtrlCreateMenuItem("Treasures",    $EditMenu)
$miTradeData   = GUICtrlCreateMenuItem("Trade Data",   $EditMenu)

; ------------------------------ GAME DATA -------------------------------------------
$GameDataMenu     = GUICtrlCreateMenu("Game Data")
$miExportClient   = GUICtrlCreateMenuItem("Export Client", $GameDataMenu)
$miExportServer   = GUICtrlCreateMenuItem("Export Server", $GameDataMenu)
GUICtrlSetState($miExportClient, $GUI_DISABLE)
GUICtrlSetState($miExportServer, $GUI_DISABLE)

; ------------------------------ USECODE MENU ----------------------------------------
$UsecodeMenu      = GUICtrlCreateMenu("Usecode")
$miOpenFile       = GUICtrlCreateMenuItem("Open File",    $UsecodeMenu)
$miNewFile        = GUICtrlCreateMenuItem("New File",     $UsecodeMenu)
$miCompileFile    = GUICtrlCreateMenuItem("Compile File", $UsecodeMenu)
$miBuildAll       = GUICtrlCreateMenuItem("Build All",    $UsecodeMenu)

; ------------------------------ EXPORT MENU -----------------------------------------
$ExportMenu       = GUICtrlCreateMenu("Export")
$miExportWep      = GUICtrlCreateMenuItem("Export Wep n Armor", $ExportMenu)

; ------------------------------ VIEW MENU -------------------------------------------
$ViewMenu         = GUICtrlCreateMenu("View")
$miViewToolbar    = GUICtrlCreateMenuItem("Toolbar",    $ViewMenu)
$miViewStatusbar  = GUICtrlCreateMenuItem("Status Bar", $ViewMenu)
GUICtrlCreateMenuItem("", $ViewMenu)
$miMapPosition    = GUICtrlCreateMenuItem("Map Position", $ViewMenu)
GUICtrlSetState($miMapPosition,   $GUI_DISABLE)
GUICtrlSetState($miViewToolbar,   $GUI_CHECKED)
GUICtrlSetState($miViewStatusbar, $GUI_CHECKED)

; ------------------------------ HELP MENU -------------------------------------------
$HelpMenu     = GUICtrlCreateMenu("Help")
$miAbout      = GUICtrlCreateMenuItem("About Dransik Editor...", $HelpMenu)



; ====================================================================================
;                                  STATUS BAR
; ====================================================================================
Global $aParts[2] = [120, -1]
$hStatus = _GUICtrlStatusBar_Create($hGUI)
_GUICtrlStatusBar_SetParts($hStatus, $aParts)
_GUICtrlStatusBar_SetText($hStatus, "Ready")


; ====================================================================================
;                       ARRAY OF ALL MENU ITEMS (AUTONUMBERED)
; ====================================================================================
Global $g_aMenuItems[] = [ _
    $miOpenUsecode, _
    $miNewUsecode, _
    $miCreateLocal, _
    $miCreateGame, _
    $miExit, _
    $miImportArtwork, _
    $miNpcEditor, _
    $miMapEditor, _
    $miAnimEditor, _
    $miTypeEditor, _
    $miShopEditor, _
    $miEncounters, _
    $miTreasures, _
    $miTradeData, _
    $miOpenFile, _
    $miNewFile, _
    $miCompileFile, _
    $miBuildAll, _
    $miExportWep, _
    $miViewToolbar, _
    $miViewStatusbar, _
    $miMapPosition, _
    $miAbout _
]


GUISetState(@SW_SHOW)


; ====================================================================================
;                              MAIN MESSAGE LOOP
; ====================================================================================
While True
    Local $msg = GUIGetMsg()

    ; Close button ends program
    If $msg = $GUI_EVENT_CLOSE Then Exit


    ; Loop through menu items and match clicks
    For $i = 0 To UBound($g_aMenuItems) - 1
        If $msg = $g_aMenuItems[$i] Then
            ; Show numbered message
            MsgBox(64, "Menu Click", "Menu #" & ($i + 1) & " clicked — nothing added here yet.")

            ; Special case: Exit
            If $g_aMenuItems[$i] = $miExit Then Exit
        EndIf
    Next

WEnd
