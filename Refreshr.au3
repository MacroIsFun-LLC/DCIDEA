If $CmdLine[0] < 1 Then Exit

Local $main = $CmdLine[1]
Local $txt = FileRead($main)

; extract version
Local $ver = StringRegExpReplace($txt, '(?s).*#AutoIt3Wrapper_Res_Fileversion\s*=\s*([0-9]+\.[0-9]+).*', '\1')
Local $split = StringSplit($ver, ".", 2)
Local $major = Number($split[0])
Local $minor = Number($split[1]) + 1

Local $newVer = $major & "." & $minor

; build 12-hour timestamp
Local $hour = @HOUR, $ampm = "AM"
If $hour = 0 Then $hour = 12
If $hour = 12 Then $ampm = "PM"
If $hour > 12 Then $hour -= 12, $ampm = "PM"

Local $buildDate = StringFormat("%02i %02i %04i %02i:%02i:%02i %s", _
    @MON, @MDAY, @YEAR, $hour, @MIN, @SEC, $ampm)

Local $newLine = "#AutoIt3Wrapper_Res_Fileversion=" & $newVer & " ; Built: " & $buildDate

; ❤️ replace ALL matching version lines — flexible match
$txt = StringRegExpReplace($txt, '(?im)^\s*#AutoIt3Wrapper_Res_Fileversion\s*=.*$', $newLine)

FileDelete($main)
FileWrite($main, $txt)
