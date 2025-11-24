#include <GUIConstantsEx.au3>
#include <GuiMenu.au3>
#include <GuiStatusBar.au3>

; ==========================
;     CREATE GUI WINDOW
; ==========================
$hGUI = GUICreate("Dransik ClassiK Editor", 1200, 700)
GUISetIcon(@ScriptDir & "\Assets\Dransik Editor.ico")

; ==========================
;         MENUBAR
; ==========================

; --- FILE ---
$FileMenu = GUICtrlCreateMenu("File")
$miOpenUsecode   = GUICtrlCreateMenuItem("Open Usecode", $FileMenu)
$miNewUsecode    = GUICtrlCreateMenuItem("New Usecode", $FileMenu)
GUICtrlCreateMenuItem("", $FileMenu)
$miCreateLocal   = GUICtrlCreateMenuItem("Create Local Data", $FileMenu)
$miCreateGame    = GUICtrlCreateMenuItem("Create Game Data", $FileMenu)
GUICtrlCreateMenuItem("", $FileMenu)
$miExit          = GUICtrlCreateMenuItem("Exit", $FileMenu)

; --- ARTWORK ---
$ArtworkMenu = GUICtrlCreateMenu("Artwork")
$miImportArtwork = GUICtrlCreateMenuItem("Import", $ArtworkMenu)

; --- EDIT ---
$EditMenu = GUICtrlCreateMenu("Edit")
$miNpcEditor   = GUICtrlCreateMenuItem("Npc Editor",   $EditMenu)
$miMapEditor   = GUICtrlCreateMenuItem("Map Editor",   $EditMenu)
$miAnimEditor  = GUICtrlCreateMenuItem("Anim Editor",  $EditMenu)
$miTypeEditor  = GUICtrlCreateMenuItem("Type Editor",  $EditMenu)
$miShopEditor  = GUICtrlCreateMenuItem("Shop Editor",  $EditMenu)
$miEncounters  = GUICtrlCreateMenuItem("Encounters",   $EditMenu)
$miTreasures   = GUICtrlCreateMenuItem("Treasures",    $EditMenu)
$miTradeData   = GUICtrlCreateMenuItem("Trade Data",   $EditMenu)

; --- GAME DATA ---
$GameDataMenu = GUICtrlCreateMenu("Game Data")
$miExportClient = GUICtrlCreateMenuItem("Export Client", $GameDataMenu)
$miExportServer = GUICtrlCreateMenuItem("Export Server", $GameDataMenu)
GUICtrlSetState($miExportClient, $GUI_DISABLE)
GUICtrlSetState($miExportServer, $GUI_DISABLE)

; --- USECODE ---
$UsecodeMenu = GUICtrlCreateMenu("Usecode")
$miOpenFile    = GUICtrlCreateMenuItem("Open File",    $UsecodeMenu)
$miNewFile     = GUICtrlCreateMenuItem("New File",     $UsecodeMenu)
$miCompileFile = GUICtrlCreateMenuItem("Compile File", $UsecodeMenu)
$miBuildAll    = GUICtrlCreateMenuItem("Build All",    $UsecodeMenu)

; --- EXPORT ---
$ExportMenu = GUICtrlCreateMenu("Export")
$miExportWep = GUICtrlCreateMenuItem("Export Wep n Armor", $ExportMenu)

; --- VIEW ---
$ViewMenu = GUICtrlCreateMenu("View")
$miViewToolbar   = GUICtrlCreateMenuItem("Toolbar",    $ViewMenu)
$miViewStatusbar = GUICtrlCreateMenuItem("Status Bar", $ViewMenu)
GUICtrlCreateMenuItem("", $ViewMenu)
$miMapPosition   = GUICtrlCreateMenuItem("Map Position", $ViewMenu)
GUICtrlSetState($miMapPosition, $GUI_DISABLE)
GUICtrlSetState($miViewToolbar,   $GUI_CHECKED)
GUICtrlSetState($miViewStatusbar, $GUI_CHECKED)

; --- HELP ---
$HelpMenu = GUICtrlCreateMenu("Help")
$miAbout = GUICtrlCreateMenuItem("About Dransik Editor...", $HelpMenu)



; ==========================
;       STATUS BAR
; ==========================
Global $aParts[2] = [120, -1]
$hStatus = _GUICtrlStatusBar_Create($hGUI)
_GUICtrlStatusBar_SetParts($hStatus, $aParts)
_GUICtrlStatusBar_SetText($hStatus, "Ready")

GUISetState(@SW_SHOW)

; ==========================
;       MESSAGE LOOP
; ==========================
While 1
    If GUIGetMsg() = $GUI_EVENT_CLOSE Then Exit
WEnd
