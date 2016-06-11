#include <File.au3>
#include <EditConstants.au3>
#include <GuiConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <FontConstants.au3>

#pragma compile(AutoItExecuteAllowed, true)
Opt("MustDeclareVars", 1)
Opt("GUIOnEventMode", 1)

Global Enum $RC_FILEPATH = 0, $RC_TITLE, $RC_DESC, $RC_INPUTS
 
Global $hGui = GUICreate("Media Cookbook V0.1.0", 780, 580, -1, -1, $WS_OVERLAPPEDWINDOW, $WS_EX_ACCEPTFILES)
GUISetOnEvent($GUI_EVENT_DROPPED, "_EVENT_DROPPED")
GUISetOnEvent($GUI_EVENT_CLOSE, "_EVENT_CLOSE")

; Recipe list
Global $hRecipeList = GUICtrlCreateList("", 10, 10, 300, 300)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP)
GUICtrlSetOnEvent($hRecipeList, "OnRecipeListClick")

; Recipe description
Global $hRecipeDesc = GUICtrlCreateEdit("", 10, 305, 300, 265, $ES_AUTOVSCROLL + $ES_READONLY)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM)

; Vertical separator
GUICtrlCreateLabel("", 315, 10, 2, 560, $SS_SUNKEN)

Global $gaDropFiles[1], $hControls[1], $hInputs[4], $hInputsSel[4]
GUIRegisterMsg($WM_GETMINMAXINFO, "_WM_GETMINMAXINFO")
GUIRegisterMsg($WM_DROPFILES, "_WM_DROPFILES_UNICODE_FUNC")

GUISetState(@SW_SHOW)

Global $recipes = ReadRecipes()
_GUICtrlListBox_SetCurSel($hRecipeList, 0)
OnRecipeListClick()

While 1
    Sleep(1000)
WEnd

Func _EVENT_CLOSE()
    Exit
EndFunc

Func _EVENT_DROPPED()
	Local $fileList = ""
	For $i = 0 To UBound($gaDropFiles)-1
	   $fileList &= "|" & $gaDropFiles[$i]
	Next
	GUICtrlSetData(@GUI_DropId, $fileList)
EndFunc

Func ReadRecipes()
	Local $files = _FileListToArray("recipes", "*.au3", $FLTA_FILESFOLDERS, True)
	Local $recipes[$files[0]], $count = 0
	For $i = 1 to $files[0]
		Local $recipe = ParseRecipe($files[$i])
		if ($recipe <> False) Then
			GUICtrlSetData($hRecipeList, $recipe[$RC_TITLE] & "|")
			$recipes[$count] = $recipe
			$count = $count + 1
		EndIf
	Next
	ReDim $recipes[$count]
	Return $recipes
EndFunc

Func ParseRecipe($filepath)
	Local $recipe[6], $lines, $descStart = False, $desc = "Source file: " & $filepath & @CRLF & @CRLF, $inputCount = 0, $inputs[4]
	; Read and parse recipe file
	$recipe[$RC_FILEPATH] = $filepath
	_FileReadToArray($filepath, $lines)
	For $i = 1 to UBound($lines)-1
		Local $line = StringStripWS($lines[$i], $STR_STRIPLEADING + $STR_STRIPTRAILING)
		If StringInStr($line, "@desc-start") = 1 Then
			$descStart = True
		ElseIf StringInStr($line, "#desc-end") = 1 Then
			$descStart = False
		ElseIf $descStart Then
			$desc = $desc & $line & @CRLF
		ElseIf StringInStr($line, "@title ") = 1 Then
			$recipe[$RC_TITLE] = StringTrimLeft($line, StringLen("@title "))
		ElseIf StringInStr($line, "@input ") = 1 Then
			$line = StringTrimLeft($line, StringLen("@input "))
			If StringInStr($line, "@filelist ") = 1 or  StringInStr($line, "@filepath ") = 1 or StringInStr($line, "@value:") = 1 Then
				$inputs[$inputCount] = $line
				$inputCount = $inputCount + 1
			EndIf
		EndIf
	Next
	$recipe[$RC_DESC] = $desc
	ReDim $inputs[$inputCount]
	$recipe[$RC_INPUTS] = $inputs
	; Return recipe
	If ($recipe[$RC_TITLE] == "") Then Return False
	Return $recipe
EndFunc

Func OnRecipeListClick()
	Local $selected = _GUICtrlListBox_GetCurSel($hRecipeList)
	If $selected < 0 Then Return
	Local $recipe = $recipes[$selected]
	GUICtrlSetData($hRecipeDesc, $recipe[$RC_DESC])
	
	For $i = 1 to UBound($hControls)-1
		If $hControls[$i] <> "" Then GuiCtrlDelete($hControls[$i])
	Next
	ReDim $hControls[1]
	
	Local $hCtrl = GUICtrlCreateGroup("", 325, 5, 450, 50)
	_ArrayAdd($hControls, $hCtrl)
	Local $hCtrl2 = GUICtrlCreateLabel($recipe[$RC_TITLE], 330, 20, 435, 30, $SS_CENTER + $SS_CENTERIMAGE)
	GUICtrlSetFont($hCtrl2, 11, $FW_BOLD, 0, "Tahoma")
	_ArrayAdd($hControls, $hCtrl2)
	
	Local $inputs = $recipe[$RC_INPUTS]
	For $i = 0 to UBound($inputs)-1
		Local $hCtrlLast = $hControls[UBound($hControls)-1]
		Local $input = $inputs[$i]
		Local $firstSpace = StringInStr($input, " ")
		Local $inputType = StringLeft($input, $firstSpace-1)
		Local $inputDesc = StringStripWS(StringTrimLeft($input, $firstSpace), $STR_STRIPLEADING + $STR_STRIPTRAILING)
		If $inputType = "@filelist" Then
			Local $hCtrl3 = GUICtrlCreateLabel($inputDesc, 325, GetHeight($hCtrlLast) + 10, 435, -1)
			_ArrayAdd($hControls, $hCtrl3)
			Local $hCtrl4 = GUICtrlCreateList("", 325, GetHeight($hctrl3) + 0, 445, 200)
			GUICtrlSetState(-1, $GUI_DROPACCEPTED)
			_ArrayAdd($hControls, $hCtrl4)
			$hInputs[$i] = $hCtrl4
		ElseIf $inputType = "@filepath" Then
			Local $hCtrl3 = GUICtrlCreateLabel($inputDesc, 325, GetHeight($hCtrlLast) + 10, 300, -1)
			_ArrayAdd($hControls, $hCtrl3)
			Local $hCtrl4 = GUICtrlCreateInput("", 325, GetHeight($hctrl3) + 0, 410, -1)
			$hInputs[$i] = $hCtrl4
			_ArrayAdd($hControls, $hCtrl4)
			Local $hCtrl5 = GUICtrlCreateButton("...", GetWidth($hctrl4)+5, GetHeight($hctrl3) + 0, 30, -1)
			$hInputsSel[$i] = $hCtrl5
			GUICtrlSetOnEvent(-1, "OnSelectFilePathButtonClick")
			_ArrayAdd($hControls, $hCtrl5)
		ElseIf StringInStr($inputType, "@value:") = 1 Then
			Local $defaultVal = StringMid($inputType, StringLen("@value:")+1)
			If StringLeft($defaultVal, 1) = '"' Then
				Local $firstQuote = StringInStr($inputDesc, '"')
				$defaultVal = StringMid($defaultVal, 2) & StringLeft($inputDesc, $firstQuote-1)
				$inputDesc = StringMid($inputDesc, $firstQuote+2)
			EndIf
			Local $hCtrl3 = GUICtrlCreateLabel($inputDesc, 325, GetHeight($hCtrlLast) + 10, 300, -1)
			_ArrayAdd($hControls, $hCtrl3)
			Local $hCtrl4 = GUICtrlCreateInput("", 325, GetHeight($hctrl3) + 0, 445, -1)
			GUICtrlSetData($hCtrl4, $defaultVal)
			$hInputs[$i] = $hCtrl4
			_ArrayAdd($hControls, $hCtrl4)
		EndIf
	Next

	Local $hCtrlLast = $hControls[UBound($hControls)-1]
	Local $hCtrl5 = GUICtrlCreateButton("Go!", 325, GetHeight($hCtrlLast) + 20, 300, -1)
	GUICtrlSetResizing(-1, $GUI_DOCKAUTO)
	GUICtrlSetOnEvent(-1, "OnGoButtonClick")
	_ArrayAdd($hControls, $hCtrl5)
	Local $hCtrl6 = GUICtrlCreateCheckbox("Create batch file only", GetWidth($hCtrl5) + 10, GetHeight($hCtrlLast) + 20, 345, -1) 
	GUICtrlSetResizing(-1, $GUI_DOCKAUTO)
	_ArrayAdd($hControls, $hCtrl6)
EndFunc

Func OnSelectFilePathButtonClick()
    Local $filepath = FileOpenDialog("Select file", "", "All (*.*)", 0)
    If Not @error Then
        Local $idx = _ArraySearch($hInputsSel, @GUI_CtrlId)
		If $idx <> -1 Then GUICtrlSetData($hInputs[$idx], $filepath)
    EndIf
	FileChangeDir(@ScriptDir)
EndFunc

Func OnGoButtonClick()
	Local $selected = _GUICtrlListBox_GetCurSel($hRecipeList)
	Local $recipe = $recipes[$selected]
	Local $filepath = $recipe[$RC_FILEPATH]
	Local $script
	_FileReadToArray($filepath, $script)
	_ArrayAdd($script, '')
	_ArrayAdd($script, '#include <Array.au3>')
	_ArrayAdd($script, '#include <File.au3>')
	_ArrayAdd($script, '#include <FileConstants.au3>');
	_ArrayAdd($script, '#include "mutils.au3"');
	Local $inputs = $recipe[$RC_INPUTS]
	_ArrayAdd($script, 'Local $inputs[' & UBound($inputs) & ']');
	For $i = 0 to UBound($inputs)-1
		Local $input = $inputs[$i]
		Local $firstSpace = StringInStr($input, " ")
		Local $inputType = StringLeft($input, $firstSpace-1)
		Local $inputDesc = StringStripWS(StringTrimLeft($input, $firstSpace), $STR_STRIPLEADING + $STR_STRIPTRAILING)
		If $inputType = "@filelist" Then
			Local $count = _GUICtrlListBox_GetCount($hInputs[$i])
			_ArrayAdd($script, 'Local $input_' & $i & '[' & $count & ']');
			For $j = 0 To $count-1
				_ArrayAdd($script, '$input_' & $i & '[' & $j & '] = "' & _GUICtrlListBox_GetText($hInputs[$i], $j) & '"');
			Next
			_ArrayAdd($script, '$inputs[' & $i & '] = $input_' & $i);
		ElseIf $inputType = "@filepath" or StringInStr($inputType, "@value:") = 1 Then
			_ArrayAdd($script, '$inputs[' & $i & '] = "' & GUICtrlRead($hInputs[$i]) & '"')
		EndIf
	Next
	Local $drive, $dir, $fname, $fext
	_PathSplit($recipe[$RC_FILEPATH], $drive, $dir, $fname, $fext)
	_ArrayAdd($script, '$batch = ' & $fname & '($inputs)');
	_ArrayAdd($script, '_ArrayInsert($batch, 1, "@title Media Cookbook (CMD)")')
	_ArrayAdd($script, '_ArrayAdd($batch, "@pause")')
	_ArrayAdd($script, 'Local $fh = FileOpen("_recipe.cmd", $FO_OVERWRITE + $FO_ANSI)')
	_ArrayAdd($script, '_FileWriteFromArray($fh, $batch, 1, Default, "")')
	_ArrayAdd($script, 'FileClose($fh)')
	Local $fh = FileOpen("_recipe.au3", $FO_OVERWRITE + $FO_UNICODE)
	_FileWriteFromArray($fh, $script, 1)
	FileClose($fh)
	FileDelete("_recipe.cmd")
	RunWait('"' & @AutoItExe & '" /AutoIt3ExecuteScript _recipe.au3')
	If FileExists("_recipe.cmd") Then
		Local $hChkBox = $hControls[UBound($hControls)-1]
		If GuiCtrlRead($hChkBox) = $GUI_CHECKED Then
			MsgBox($MB_OK + $MB_ICONINFORMATION, "Status", 'The batch file "_recipe.cmd" has been created.')
		Else
			RunWait(@ComSpec & " /c " & "_recipe.cmd", "", @SW_SHOW)
		EndIf
	Else
		MsgBox($MB_OK + $MB_ICONERROR, "Error", 'Oops! Something didn''t go according to plan.' & @CRLF & @CRLF & 'The batch file "_recipe.cmd" has not been created.')
	EndIf
EndFunc

Func _WM_GETMINMAXINFO($hWnd, $Msg, $wParam, $lParam) ; used to limit the minimum size of the GUI
    #forceref $hWnd, $Msg, $wParam, $lParam
    Local $iWidth = 780; minimum width setting
    Local $iHeight = 580; minimum height setting
    If $hWnd = $hGui Then
        Local $tagMaxinfo = DllStructCreate("int;int;int;int;int;int;int;int;int;int", $lParam)
        DllStructSetData($tagMaxinfo, 7, $iWidth) ; min width
        DllStructSetData($tagMaxinfo, 8, $iHeight) ; min height
		DllStructSetData($tagMaxinfo, 9, 99999) ; max width
		DllStructSetData($tagMaxinfo, 10, 99999) ; max height
        Return $GUI_RUNDEFMSG
    EndIf
EndFunc   ;==>_WM_GETMINMAXINFO

Func _WM_DROPFILES_UNICODE_FUNC($hWnd, $msgID, $wParam, $lParam)
    Local $nSize, $pFileName
    Local $nAmt = DllCall("shell32.dll", "int", "DragQueryFileW", "hwnd", $wParam, "int", 0xFFFFFFFF, "ptr", 0, "int", 255)
    For $i = 0 To $nAmt[0] - 1
        $nSize = DllCall("shell32.dll", "int", "DragQueryFileW", "hwnd", $wParam, "int", $i, "ptr", 0, "int", 0)
        $nSize = $nSize[0] + 1
        $pFileName = DllStructCreate("wchar[" & $nSize & "]")
        DllCall("shell32.dll", "int", "DragQueryFileW", "hwnd", $wParam, "int", $i, "int", DllStructGetPtr($pFileName), "int", $nSize)
        ReDim $gaDropFiles[$i + 1]
        $gaDropFiles[$i] = DllStructGetData($pFileName, 1)
        $pFileName = 0
    Next
EndFunc   ;==>WM_DROPFILES_UNICODE_FUNC

Func GetWidth($hCtrl)
    Local $Pos = ControlGetPos($hGUI, "", $hCtrl)
    Return $Pos[0] + $Pos[2]
EndFunc   ;==>GetPos

Func GetHeight($hCtrl)
    Local $Pos = ControlGetPos($hGUI, "", $hCtrl)
    Return $Pos[1] + $Pos[3]
EndFunc   ;==>GetPos
