Global Const $GUI_EVENT_CLOSE = -3
Global Const $GUI_CHECKED = 1
Global Const $GUI_DISABLE = 128
Global Const $PROCESS_VM_OPERATION = 0x00000008
Global Const $PROCESS_VM_READ = 0x00000010
Global Const $PROCESS_VM_WRITE = 0x00000020
Func _WinAPI_GetModuleHandle($sModuleName)
If $sModuleName = "" Then $sModuleName = Null
Local $aCall = DllCall("kernel32.dll", "handle", "GetModuleHandleW", "wstr", $sModuleName)
If @error Then Return SetError(@error, @extended, 0)
Return $aCall[0]
EndFunc
Func _SendMessage($hWnd, $iMsg, $wParam = 0, $lParam = 0, $iReturn = 0, $wParamType = "wparam", $lParamType = "lparam", $sReturnType = "lresult")
Local $aCall = DllCall("user32.dll", $sReturnType, "SendMessageW", "hwnd", $hWnd, "uint", $iMsg, $wParamType, $wParam, $lParamType, $lParam)
If @error Then Return SetError(@error, @extended, "")
If $iReturn >= 0 And $iReturn <= 4 Then Return $aCall[$iReturn]
Return $aCall
EndFunc
Func _WinAPI_CreateWindowEx($iExStyle, $sClass, $sName, $iStyle, $iX, $iY, $iWidth, $iHeight, $hParent, $hMenu = 0, $hInstance = 0, $pParam = 0)
If $hInstance = 0 Then $hInstance = _WinAPI_GetModuleHandle("")
Local $aCall = DllCall("user32.dll", "hwnd", "CreateWindowExW", "dword", $iExStyle, "wstr", $sClass, "wstr", $sName, "dword", $iStyle, "int", $iX, "int", $iY, "int", $iWidth, "int", $iHeight, "hwnd", $hParent, "handle", $hMenu, "handle", $hInstance, "struct*", $pParam)
If @error Then Return SetError(@error, @extended, 0)
Return $aCall[0]
EndFunc
Func _WinAPI_GetClassName($hWnd)
If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
Local $aCall = DllCall("user32.dll", "int", "GetClassNameW", "hwnd", $hWnd, "wstr", "", "int", 4096)
If @error Or Not $aCall[0] Then Return SetError(@error, @extended, '')
Return SetExtended($aCall[0], $aCall[2])
EndFunc
Func _WinAPI_IsClassName($hWnd, $sClassName)
Local $sSeparator = Opt("GUIDataSeparatorChar")
Local $aClassName = StringSplit($sClassName, $sSeparator)
If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
Local $sClassCheck = _WinAPI_GetClassName($hWnd)
For $x = 1 To UBound($aClassName) - 1
If StringUpper(StringMid($sClassCheck, 1, StringLen($aClassName[$x]))) = StringUpper($aClassName[$x]) Then Return True
Next
Return False
EndFunc
Global Const $MEM_COMMIT = 0x00001000
Global Const $MEM_RESERVE = 0x00002000
Global Const $PAGE_READWRITE = 0x00000004
Global Const $MEM_RELEASE = 0x00008000
Global Const $SE_DEBUG_NAME = "SeDebugPrivilege"
Global Const $SE_PRIVILEGE_ENABLED = 0x00000002
Global Enum $SECURITYANONYMOUS = 0, $SECURITYIDENTIFICATION, $SECURITYIMPERSONATION, $SECURITYDELEGATION
Global Const $TOKEN_QUERY = 0x00000008
Global Const $TOKEN_ADJUST_PRIVILEGES = 0x00000020
Func _WinAPI_GetLastError(Const $_iCallerError = @error, Const $_iCallerExtended = @extended)
Local $aCall = DllCall("kernel32.dll", "dword", "GetLastError")
Return SetError($_iCallerError, $_iCallerExtended, $aCall[0])
EndFunc
Func _Security__AdjustTokenPrivileges($hToken, $bDisableAll, $tNewState, $iBufferLen, $tPrevState = 0, $pRequired = 0)
Local $aCall = DllCall("advapi32.dll", "bool", "AdjustTokenPrivileges", "handle", $hToken, "bool", $bDisableAll, "struct*", $tNewState, "dword", $iBufferLen, "struct*", $tPrevState, "struct*", $pRequired)
If @error Then Return SetError(@error, @extended, False)
Return Not($aCall[0] = 0)
EndFunc
Func _Security__ImpersonateSelf($iLevel = $SECURITYIMPERSONATION)
Local $aCall = DllCall("advapi32.dll", "bool", "ImpersonateSelf", "int", $iLevel)
If @error Then Return SetError(@error, @extended, False)
Return Not($aCall[0] = 0)
EndFunc
Func _Security__LookupPrivilegeValue($sSystem, $sName)
Local $aCall = DllCall("advapi32.dll", "bool", "LookupPrivilegeValueW", "wstr", $sSystem, "wstr", $sName, "int64*", 0)
If @error Or Not $aCall[0] Then Return SetError(@error + 10, @extended, 0)
Return $aCall[3]
EndFunc
Func _Security__OpenThreadToken($iAccess, $hThread = 0, $bOpenAsSelf = False)
Local $aCall
If $hThread = 0 Then
$aCall = DllCall("kernel32.dll", "handle", "GetCurrentThread")
If @error Then Return SetError(@error + 20, @extended, 0)
$hThread = $aCall[0]
EndIf
$aCall = DllCall("advapi32.dll", "bool", "OpenThreadToken", "handle", $hThread, "dword", $iAccess, "bool", $bOpenAsSelf, "handle*", 0)
If @error Or Not $aCall[0] Then Return SetError(@error + 10, @extended, 0)
Return $aCall[4]
EndFunc
Func _Security__OpenThreadTokenEx($iAccess, $hThread = 0, $bOpenAsSelf = False)
Local $hToken = _Security__OpenThreadToken($iAccess, $hThread, $bOpenAsSelf)
If $hToken = 0 Then
Local Const $ERROR_NO_TOKEN = 1008
If _WinAPI_GetLastError() <> $ERROR_NO_TOKEN Then Return SetError(20, _WinAPI_GetLastError(), 0)
If Not _Security__ImpersonateSelf() Then Return SetError(@error + 10, _WinAPI_GetLastError(), 0)
$hToken = _Security__OpenThreadToken($iAccess, $hThread, $bOpenAsSelf)
If $hToken = 0 Then Return SetError(@error, _WinAPI_GetLastError(), 0)
EndIf
Return $hToken
EndFunc
Func _Security__SetPrivilege($hToken, $sPrivilege, $bEnable)
Local $iLUID = _Security__LookupPrivilegeValue("", $sPrivilege)
If $iLUID = 0 Then Return SetError(@error + 10, @extended, False)
Local Const $tagTOKEN_PRIVILEGES = "dword Count;align 4;int64 LUID;dword Attributes"
Local $tCurrState = DllStructCreate($tagTOKEN_PRIVILEGES)
Local $iCurrState = DllStructGetSize($tCurrState)
Local $tPrevState = DllStructCreate($tagTOKEN_PRIVILEGES)
Local $iPrevState = DllStructGetSize($tPrevState)
Local $tRequired = DllStructCreate("int Data")
DllStructSetData($tCurrState, "Count", 1)
DllStructSetData($tCurrState, "LUID", $iLUID)
If Not _Security__AdjustTokenPrivileges($hToken, False, $tCurrState, $iCurrState, $tPrevState, $tRequired) Then Return SetError(2, @error, False)
DllStructSetData($tPrevState, "Count", 1)
DllStructSetData($tPrevState, "LUID", $iLUID)
Local $iAttributes = DllStructGetData($tPrevState, "Attributes")
If $bEnable Then
$iAttributes = BitOR($iAttributes, $SE_PRIVILEGE_ENABLED)
Else
$iAttributes = BitAND($iAttributes, BitNOT($SE_PRIVILEGE_ENABLED))
EndIf
DllStructSetData($tPrevState, "Attributes", $iAttributes)
If Not _Security__AdjustTokenPrivileges($hToken, False, $tPrevState, $iPrevState, $tCurrState, $tRequired) Then Return SetError(3, @error, False)
Return True
EndFunc
Global Const $tagMEMMAP = "handle hProc;ulong_ptr Size;ptr Mem"
Func _MemFree(ByRef $tMemMap)
Local $pMemory = DllStructGetData($tMemMap, "Mem")
Local $hProcess = DllStructGetData($tMemMap, "hProc")
Local $bResult = _MemVirtualFreeEx($hProcess, $pMemory, 0, $MEM_RELEASE)
DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hProcess)
If @error Then Return SetError(@error, @extended, False)
Return $bResult
EndFunc
Func _MemInit($hWnd, $iSize, ByRef $tMemMap)
Local $aCall = DllCall("user32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $hWnd, "dword*", 0)
If @error Then Return SetError(@error + 10, @extended, 0)
Local $iProcessID = $aCall[2]
If $iProcessID = 0 Then Return SetError(1, 0, 0)
Local $iAccess = BitOR($PROCESS_VM_OPERATION, $PROCESS_VM_READ, $PROCESS_VM_WRITE)
Local $hProcess = __Mem_OpenProcess($iAccess, False, $iProcessID, True)
Local $iAlloc = BitOR($MEM_RESERVE, $MEM_COMMIT)
Local $pMemory = _MemVirtualAllocEx($hProcess, 0, $iSize, $iAlloc, $PAGE_READWRITE)
If $pMemory = 0 Then Return SetError(2, 0, 0)
$tMemMap = DllStructCreate($tagMEMMAP)
DllStructSetData($tMemMap, "hProc", $hProcess)
DllStructSetData($tMemMap, "Size", $iSize)
DllStructSetData($tMemMap, "Mem", $pMemory)
Return $pMemory
EndFunc
Func _MemRead(ByRef $tMemMap, $pSrce, $pDest, $iSize)
Local $aCall = DllCall("kernel32.dll", "bool", "ReadProcessMemory", "handle", DllStructGetData($tMemMap, "hProc"), "ptr", $pSrce, "struct*", $pDest, "ulong_ptr", $iSize, "ulong_ptr*", 0)
If @error Then Return SetError(@error, @extended, False)
Return $aCall[0]
EndFunc
Func _MemWrite(ByRef $tMemMap, $pSrce, $pDest = 0, $iSize = 0, $sSrce = "struct*")
If $pDest = 0 Then $pDest = DllStructGetData($tMemMap, "Mem")
If $iSize = 0 Then $iSize = DllStructGetData($tMemMap, "Size")
Local $aCall = DllCall("kernel32.dll", "bool", "WriteProcessMemory", "handle", DllStructGetData($tMemMap, "hProc"), "ptr", $pDest, $sSrce, $pSrce, "ulong_ptr", $iSize, "ulong_ptr*", 0)
If @error Then Return SetError(@error, @extended, False)
Return $aCall[0]
EndFunc
Func _MemVirtualAllocEx($hProcess, $pAddress, $iSize, $iAllocation, $iProtect)
Local $aCall = DllCall("kernel32.dll", "ptr", "VirtualAllocEx", "handle", $hProcess, "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iAllocation, "dword", $iProtect)
If @error Then Return SetError(@error, @extended, 0)
Return $aCall[0]
EndFunc
Func _MemVirtualFreeEx($hProcess, $pAddress, $iSize, $iFreeType)
Local $aCall = DllCall("kernel32.dll", "bool", "VirtualFreeEx", "handle", $hProcess, "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iFreeType)
If @error Then Return SetError(@error, @extended, False)
Return $aCall[0]
EndFunc
Func __Mem_OpenProcess($iAccess, $bInherit, $iPID, $bDebugPriv = False)
Local $aCall = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $iAccess, "bool", $bInherit, "dword", $iPID)
If @error Then Return SetError(@error, @extended, 0)
If $aCall[0] Then Return $aCall[0]
If Not $bDebugPriv Then Return SetError(100, 0, 0)
Local $hToken = _Security__OpenThreadTokenEx(BitOR($TOKEN_ADJUST_PRIVILEGES, $TOKEN_QUERY))
If @error Then Return SetError(@error + 10, @extended, 0)
_Security__SetPrivilege($hToken, $SE_DEBUG_NAME, True)
Local $iError = @error
Local $iExtended = @extended
Local $iRet = 0
If Not @error Then
$aCall = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $iAccess, "bool", $bInherit, "dword", $iPID)
$iError = @error
$iExtended = @extended
If $aCall[0] Then $iRet = $aCall[0]
_Security__SetPrivilege($hToken, $SE_DEBUG_NAME, False)
If @error Then
$iError = @error + 20
$iExtended = @extended
EndIf
Else
$iError = @error + 30
EndIf
DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hToken)
Return SetError($iError, $iExtended, $iRet)
EndFunc
Global Const $__GUICTRL_IDS_OFFSET = 2
Global Const $__GUICTRL_ID_MAX_WIN = 16
Global Const $__GUICTRL_STARTID = 10000
Global Const $__GUICTRL_ID_MAX_IDS = 65535 - $__GUICTRL_STARTID
Global Const $__GUICTRLCONSTANT_WS_VISIBLE = 0x10000000
Global Const $__GUICTRLCONSTANT_WS_CHILD = 0x40000000
Global $__g_hGUICtrl_LastWnd
Global $__g_aGUICtrl_IDs_Used[$__GUICTRL_ID_MAX_WIN][$__GUICTRL_ID_MAX_IDS + $__GUICTRL_IDS_OFFSET + 1]
Func __GUICtrl_SendMsg($hWnd, $iMsg, $iIndex, ByRef $tItem, $tBuffer = 0, $bRetItem = False, $iElement = -1, $bRetBuffer = False, $iElementMax = $iElement)
If $iElement > 0 Then
DllStructSetData($tItem, $iElement, DllStructGetPtr($tBuffer))
If $iElement = $iElementMax Then DllStructSetData($tItem, $iElement + 1, DllStructGetSize($tBuffer))
EndIf
Local $iRet
If IsHWnd($hWnd) Then
If($hWnd = $__g_hGUICtrl_LastWnd) Or(DllCall("user32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $hWnd, "dword*", 0)[2] = @AutoItPID) Then
$__g_hGUICtrl_LastWnd = $hWnd
$iRet = DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $hWnd, "uint", $iMsg, "wparam", $iIndex, "struct*", $tItem)[0]
Else
Local $iItem = Ceiling(DllStructGetSize($tItem) / 16) * 16
Local $tMemMap, $pText
Local $iBuffer = 0
If($iElement > 0) Or($iElementMax = 0) Then $iBuffer = DllStructGetSize($tBuffer)
Local $pMemory = _MemInit($hWnd, $iItem + $iBuffer, $tMemMap)
If $iBuffer Then
$pText = $pMemory + $iItem
If $iElementMax Then
DllStructSetData($tItem, $iElement, $pText)
Else
$iIndex = $pText
EndIf
_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
EndIf
_MemWrite($tMemMap, $tItem, $pMemory, $iItem)
$iRet = DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $hWnd, "uint", $iMsg, "wparam", $iIndex, "ptr", $pMemory)[0]
If $iBuffer And $bRetBuffer Then
_MemRead($tMemMap, $pText, $tBuffer, $iBuffer)
EndIf
If $bRetItem Then _MemRead($tMemMap, $pMemory, $tItem, $iItem)
_MemFree($tMemMap)
EndIf
Else
$iRet = GUICtrlSendMsg($hWnd, $iMsg, $iIndex, DllStructGetPtr($tItem))
EndIf
Return $iRet
EndFunc
Func __GUICtrl_GetNextGlobalID($hWnd)
If DllCall("user32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $hWnd, "dword*", 0)[2] <> @AutoItPID Then
Return SetError(4, 0, 0)
EndIf
Local $nCtrlID, $iUsedIndex = -1, $bAllUsed = True
If Not WinExists($hWnd) Then Return SetError(2, -1, 0)
For $iIndex = 0 To $__GUICTRL_ID_MAX_WIN - 1
If $__g_aGUICtrl_IDs_Used[$iIndex][0] <> 0 Then
If Not WinExists($__g_aGUICtrl_IDs_Used[$iIndex][0]) Then
For $x = 0 To UBound($__g_aGUICtrl_IDs_Used, 2) - 1
$__g_aGUICtrl_IDs_Used[$iIndex][$x] = 0
Next
$__g_aGUICtrl_IDs_Used[$iIndex][1] = $__GUICTRL_STARTID
$bAllUsed = False
EndIf
EndIf
Next
For $iIndex = 0 To $__GUICTRL_ID_MAX_WIN - 1
If $__g_aGUICtrl_IDs_Used[$iIndex][0] = $hWnd Then
$iUsedIndex = $iIndex
ExitLoop
EndIf
Next
If $iUsedIndex = -1 Then
For $iIndex = 0 To $__GUICTRL_ID_MAX_WIN - 1
If $__g_aGUICtrl_IDs_Used[$iIndex][0] = 0 Then
$__g_aGUICtrl_IDs_Used[$iIndex][0] = $hWnd
$__g_aGUICtrl_IDs_Used[$iIndex][1] = $__GUICTRL_STARTID
$bAllUsed = False
$iUsedIndex = $iIndex
ExitLoop
EndIf
Next
EndIf
If $iUsedIndex = -1 And $bAllUsed Then Return SetError(16, 0, 0)
If $__g_aGUICtrl_IDs_Used[$iUsedIndex][1] =($__GUICTRL_STARTID + $__GUICTRL_ID_MAX_IDS) Then
For $iIDIndex = $__GUICTRL_IDS_OFFSET To UBound($__g_aGUICtrl_IDs_Used, 2) - 1
If $__g_aGUICtrl_IDs_Used[$iUsedIndex][$iIDIndex] = 0 Then
$nCtrlID =($iIDIndex - $__GUICTRL_IDS_OFFSET) + $__GUICTRL_STARTID
$__g_aGUICtrl_IDs_Used[$iUsedIndex][$iIDIndex] = $nCtrlID
Return $nCtrlID
EndIf
Next
Return SetError(8, $__GUICTRL_ID_MAX_IDS, 0)
EndIf
$nCtrlID = $__g_aGUICtrl_IDs_Used[$iUsedIndex][1]
$__g_aGUICtrl_IDs_Used[$iUsedIndex][1] += 1
$__g_aGUICtrl_IDs_Used[$iUsedIndex][($nCtrlID - $__GUICTRL_STARTID) + $__GUICTRL_IDS_OFFSET] = $nCtrlID
Return $nCtrlID
EndFunc
Global Const $__STATUSBARCONSTANT_WM_USER = 0X400
Global Const $SB_GETUNICODEFORMAT = 0x2000 + 6
Global Const $SB_ISSIMPLE =($__STATUSBARCONSTANT_WM_USER + 14)
Global Const $SB_SETPARTS =($__STATUSBARCONSTANT_WM_USER + 4)
Global Const $SB_SETTEXTA =($__STATUSBARCONSTANT_WM_USER + 1)
Global Const $SB_SETTEXTW =($__STATUSBARCONSTANT_WM_USER + 11)
Global Const $SB_SETTEXT = $SB_SETTEXTA
Global Const $SB_SIMPLEID = 0xff
Global $__g_tSBBuffer, $__g_tSBBufferANSI
Global Const $__STATUSBARCONSTANT_ClassName = "msctls_statusbar32"
Global Const $__STATUSBARCONSTANT_WM_SIZE = 0x05
Func _GUICtrlStatusBar_Create($hWnd, $vPartEdge = -1, $vPartText = "", $iStyles = -1, $iExStyles = 0x00000000)
If Not IsHWnd($hWnd) Then Return SetError(1, 0, 0)
Local $iStyle = BitOR($__GUICTRLCONSTANT_WS_CHILD, $__GUICTRLCONSTANT_WS_VISIBLE)
If $iStyles = -1 Then $iStyles = 0x00000000
If $iExStyles = -1 Then $iExStyles = 0x00000000
Local $aPartWidth[1], $aPartText[1]
If @NumParams > 1 Then
If IsArray($vPartEdge) Then
$aPartWidth = $vPartEdge
Else
$aPartWidth[0] = $vPartEdge
EndIf
If @NumParams = 2 Then
ReDim $aPartText[UBound($aPartWidth)]
Else
If IsArray($vPartText) Then
$aPartText = $vPartText
Else
$aPartText[0] = $vPartText
EndIf
If UBound($aPartWidth) <> UBound($aPartText) Then
Local $iLast
If UBound($aPartWidth) > UBound($aPartText) Then
$iLast = UBound($aPartText)
ReDim $aPartText[UBound($aPartWidth)]
Else
$iLast = UBound($aPartWidth)
ReDim $aPartWidth[UBound($aPartText)]
For $x = $iLast To UBound($aPartWidth) - 1
$aPartWidth[$x] = $aPartWidth[$x - 1] + 75
Next
$aPartWidth[UBound($aPartText) - 1] = -1
EndIf
EndIf
EndIf
If Not IsHWnd($hWnd) Then $hWnd = HWnd($hWnd)
If @NumParams > 3 Then $iStyle = BitOR($iStyle, $iStyles)
EndIf
Local $nCtrlID = __GUICtrl_GetNextGlobalID($hWnd)
If @error Then Return SetError(@error, @extended, 0)
Local $hWndSBar = _WinAPI_CreateWindowEx($iExStyles, $__STATUSBARCONSTANT_ClassName, "", $iStyle, 0, 0, 0, 0, $hWnd, $nCtrlID)
If @error Then Return SetError(@error + 10, @extended, 0)
If @NumParams > 1 Then
_GUICtrlStatusBar_SetParts($hWndSBar, UBound($aPartWidth), $aPartWidth)
For $x = 0 To UBound($aPartText) - 1
_GUICtrlStatusBar_SetText($hWndSBar, $aPartText[$x], $x)
Next
EndIf
Return $hWndSBar
EndFunc
Func _GUICtrlStatusBar_GetUnicodeFormat($hWnd)
If Not _WinAPI_IsClassName($hWnd, $__STATUSBARCONSTANT_ClassName) Then Return SetError(2, 0, False)
If Not IsDllStruct($__g_tSBBuffer) Then
$__g_tSBBuffer = DllStructCreate("wchar Text[4096]")
$__g_tSBBufferANSI = DllStructCreate("char Text[4096]", DllStructGetPtr($__g_tSBBuffer))
EndIf
Return _SendMessage($hWnd, $SB_GETUNICODEFORMAT) <> 0
EndFunc
Func _GUICtrlStatusBar_IsSimple($hWnd)
If Not _WinAPI_IsClassName($hWnd, $__STATUSBARCONSTANT_ClassName) Then Return SetError(2, 0, False)
Return _SendMessage($hWnd, $SB_ISSIMPLE) <> 0
EndFunc
Func _GUICtrlStatusBar_Resize($hWnd)
If Not _WinAPI_IsClassName($hWnd, $__STATUSBARCONSTANT_ClassName) Then Return SetError(2, 0, False)
_SendMessage($hWnd, $__STATUSBARCONSTANT_WM_SIZE)
EndFunc
Func _GUICtrlStatusBar_SetParts($hWnd, $vPartEdge = -1, $vPartWidth = 25)
If Not _WinAPI_IsClassName($hWnd, $__STATUSBARCONSTANT_ClassName) Then Return SetError(2, 0, False)
If IsArray($vPartEdge) And IsArray($vPartWidth) Then Return False
Local $tParts, $iParts
If IsArray($vPartEdge) Then
$vPartEdge[UBound($vPartEdge) - 1] = -1
$iParts = UBound($vPartEdge)
$tParts = DllStructCreate("int[" & $iParts & "]")
For $x = 0 To $iParts - 2
DllStructSetData($tParts, 1, $vPartEdge[$x], $x + 1)
Next
DllStructSetData($tParts, 1, -1, $iParts)
Else
If $vPartEdge < -1 Then Return False
If IsArray($vPartWidth) Then
$iParts = UBound($vPartWidth)
$tParts = DllStructCreate("int[" & $iParts & "]")
Local $iPartRightEdge = 0
For $x = 0 To $iParts - 2
$iPartRightEdge += $vPartWidth[$x]
If $vPartWidth[$x] <= 0 Then Return False
DllStructSetData($tParts, 1, $iPartRightEdge, $x + 1)
Next
DllStructSetData($tParts, 1, -1, $iParts)
ElseIf $vPartEdge > 1 Then
$iParts = $vPartEdge
$tParts = DllStructCreate("int[" & $iParts & "]")
For $x = 1 To $iParts - 1
DllStructSetData($tParts, 1, $vPartWidth * $x, $x)
Next
DllStructSetData($tParts, 1, -1, $iParts)
Else
$iParts = 1
$tParts = DllStructCreate("int")
DllStructSetData($tParts, 1, -1)
EndIf
EndIf
__GUICtrl_SendMsg($hWnd, $SB_SETPARTS, $iParts, $tParts)
_GUICtrlStatusBar_Resize($hWnd)
Return True
EndFunc
Func _GUICtrlStatusBar_SetText($hWnd, $sText = "", $iPart = 0, $iUFlag = 0)
If Not _WinAPI_IsClassName($hWnd, $__STATUSBARCONSTANT_ClassName) Then Return SetError(2, 0, False)
Local $iBuffer = StringLen($sText) + 1
Local $tText, $iMsg
If _GUICtrlStatusBar_GetUnicodeFormat($hWnd) Then
$tText = DllStructCreate("wchar Text[" & $iBuffer & "]")
$iMsg = $SB_SETTEXTW
Else
$tText = DllStructCreate("char Text[" & $iBuffer & "]")
$iMsg = $SB_SETTEXT
EndIf
DllStructSetData($tText, "Text", $sText)
If _GUICtrlStatusBar_IsSimple($hWnd) Then $iPart = $SB_SIMPLEID
Local $iRet = __GUICtrl_SendMsg($hWnd, $iMsg, BitOR($iPart, $iUFlag), $tText)
Return $iRet <> 0
EndFunc
$hGUI = GUICreate("Dransik ClassiK Editor", 1200, 700)
GUISetIcon(@ScriptDir & "\Assets\Dransik Editor.ico")
$FileMenu = GUICtrlCreateMenu("File")
$miOpenUsecode = GUICtrlCreateMenuItem("Open Usecode", $FileMenu)
$miNewUsecode = GUICtrlCreateMenuItem("New Usecode", $FileMenu)
GUICtrlCreateMenuItem("", $FileMenu)
$miCreateLocal = GUICtrlCreateMenuItem("Create Local Data", $FileMenu)
$miCreateGame = GUICtrlCreateMenuItem("Create Game Data", $FileMenu)
GUICtrlCreateMenuItem("", $FileMenu)
$miExit = GUICtrlCreateMenuItem("Exit", $FileMenu)
$ArtworkMenu = GUICtrlCreateMenu("Artwork")
$miImportArtwork = GUICtrlCreateMenuItem("Import", $ArtworkMenu)
$EditMenu = GUICtrlCreateMenu("Edit")
$miNpcEditor = GUICtrlCreateMenuItem("Npc Editor", $EditMenu)
$miMapEditor = GUICtrlCreateMenuItem("Map Editor", $EditMenu)
$miAnimEditor = GUICtrlCreateMenuItem("Anim Editor", $EditMenu)
$miTypeEditor = GUICtrlCreateMenuItem("Type Editor", $EditMenu)
$miShopEditor = GUICtrlCreateMenuItem("Shop Editor", $EditMenu)
$miEncounters = GUICtrlCreateMenuItem("Encounters", $EditMenu)
$miTreasures = GUICtrlCreateMenuItem("Treasures", $EditMenu)
$miTradeData = GUICtrlCreateMenuItem("Trade Data", $EditMenu)
$GameDataMenu = GUICtrlCreateMenu("Game Data")
$miExportClient = GUICtrlCreateMenuItem("Export Client", $GameDataMenu)
$miExportServer = GUICtrlCreateMenuItem("Export Server", $GameDataMenu)
GUICtrlSetState($miExportClient, $GUI_DISABLE)
GUICtrlSetState($miExportServer, $GUI_DISABLE)
$UsecodeMenu = GUICtrlCreateMenu("Usecode")
$miOpenFile = GUICtrlCreateMenuItem("Open File", $UsecodeMenu)
$miNewFile = GUICtrlCreateMenuItem("New File", $UsecodeMenu)
$miCompileFile = GUICtrlCreateMenuItem("Compile File", $UsecodeMenu)
$miBuildAll = GUICtrlCreateMenuItem("Build All", $UsecodeMenu)
$ExportMenu = GUICtrlCreateMenu("Export")
$miExportWep = GUICtrlCreateMenuItem("Export Wep n Armor", $ExportMenu)
$ViewMenu = GUICtrlCreateMenu("View")
$miViewToolbar = GUICtrlCreateMenuItem("Toolbar", $ViewMenu)
$miViewStatusbar = GUICtrlCreateMenuItem("Status Bar", $ViewMenu)
GUICtrlCreateMenuItem("", $ViewMenu)
$miMapPosition = GUICtrlCreateMenuItem("Map Position", $ViewMenu)
GUICtrlSetState($miMapPosition, $GUI_DISABLE)
GUICtrlSetState($miViewToolbar, $GUI_CHECKED)
GUICtrlSetState($miViewStatusbar, $GUI_CHECKED)
$HelpMenu = GUICtrlCreateMenu("Help")
$miAbout = GUICtrlCreateMenuItem("About Dransik Editor...", $HelpMenu)
Global $aParts[2] = [120, -1]
$hStatus = _GUICtrlStatusBar_Create($hGUI)
_GUICtrlStatusBar_SetParts($hStatus, $aParts)
_GUICtrlStatusBar_SetText($hStatus, "Ready")
Global $g_aMenuItems[] = [ $miOpenUsecode, $miNewUsecode, $miCreateLocal, $miCreateGame, $miExit, $miImportArtwork, $miNpcEditor, $miMapEditor, $miAnimEditor, $miTypeEditor, $miShopEditor, $miEncounters, $miTreasures, $miTradeData, $miOpenFile, $miNewFile, $miCompileFile, $miBuildAll, $miExportWep, $miViewToolbar, $miViewStatusbar, $miMapPosition, $miAbout ]
GUISetState(@SW_SHOW)
While True
Local $msg = GUIGetMsg()
If $msg = $GUI_EVENT_CLOSE Then Exit
For $i = 0 To UBound($g_aMenuItems) - 1
If $msg = $g_aMenuItems[$i] Then
MsgBox(64, "Menu Click", "Menu #" &($i + 1) & " clicked — nothing added here yet.")
If $g_aMenuItems[$i] = $miExit Then Exit
EndIf
Next
WEnd
