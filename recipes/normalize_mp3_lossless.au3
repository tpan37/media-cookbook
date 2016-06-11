#comments-start
@title Normalize volume of MP3 files (lossless)
@desc-start
Normalize volume of MP3 files using mp3gain (lossless).

All files are set to equal loudness (automatic track gain)
#desc-end
@input @filelist Input files
#comments-end

Func normalize_mp3_lossless($inputs)
	Local $batch[1]
	For $filepath in $inputs[0]
		_ArrayAdd($batch, 'mp3gain\mp3gain.exe /r /c "' & $filepath & '"')
	Next
	return $batch
EndFunc
