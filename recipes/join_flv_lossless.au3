#comments-start
@title Join FLV video files (lossless)
@desc-start
Join given FLV video files without transcoding (lossless)
#desc-end
@input @filelist Input files
@input @filepath Output file
#comments-end

Func join_flv_lossless($inputs)
	Local $filelist[1], $batch[1], $count = 0
	For $filepath in $inputs[0]
		_ArrayAdd($filelist, "file '" & $filepath & "'")
	Next
	Local $fh = FileOpen("_recipe.lst", $FO_OVERWRITE + $FO_ANSI)
	_FileWriteFromArray($fh, $filelist, 1, Default, "")
	FileClose($fh)
	_ArrayAdd($batch, 'ffmpeg\bin\ffmpeg -safe 0 -f concat -i _recipe.lst "' & $inputs[1] & '"', 0, @TAB) 
	return $batch
EndFunc
