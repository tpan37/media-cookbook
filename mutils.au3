Func ChangeExt($filepath, $newExt)
	Local $drive, $dir, $fname, $fext
	_PathSplit($filepath, $drive, $dir, $fname, $fext)
	return _PathMake($drive, $dir, $fname, $newExt)
EndFunc

Func AppendToFilename($filepath, $postfix)
	Local $drive, $dir, $fname, $fext
	_PathSplit($filepath, $drive, $dir, $fname, $fext)
	return _PathMake($drive, $dir, $fname & $postfix, $fext)
EndFunc

