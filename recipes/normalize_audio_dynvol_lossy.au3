#comments-start
@title Normalize volume of audio files dynamically (lossy)
@desc-start
Normalize volume of FFmpeg-supported audio files using the "Dynamic Audio Normalizer" filter (lossy) integrated into ffmpeg.
#desc-end
@input @filelist Input files
#comments-end

Func normalize_audio_dynvol_lossy($inputs)
	Local $batch[1]
	For $filepath in $inputs[0]
		Local $newfilepath = AppendToFilename($filepath, "_dynvol")
		_ArrayAdd($batch, 'ffmpeg\bin\ffmpeg.exe -i "' & $filepath & '" -vn -af dynaudnorm "' & $newfilepath & '"')
	Next
	return $batch
EndFunc
