#comments-start
@title Normalize volume of MP4/M4A files (lossless)
@desc-start
Normalize volume of MP4 video or M4A audio files (lossless) using aacgain. Raw AAC files/HE-AAC/SBR are not supported.

This recipe is useful for making MP4 video files with a very soft audio track sound louder.
#desc-end
@input @filelist Input files
#comments-end

Func normalize_mp4_lossless($inputs)
	Local $batch[1]
	For $filepath in $inputs[0]
		_ArrayAdd($batch, 'aacgain\aacgain.exe /r /c "' & $filepath & '"')
	Next
	return $batch
EndFunc
