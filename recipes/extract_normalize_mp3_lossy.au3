#comments-start
@title Extract audio from video as normalized MP3 files (lossy)
@desc-start
Extract audio track from given video files using ffmpeg and transcode to MP3 files (lossy).

Then the volume of extracted MP3 files are normalized using mp3gain.

The "-q:a 5" parameter determines the quality of the variable bitrate MP3 file created by ffmpeg. Valid values are 0-9 (lower is better).
#desc-end
@input @filelist Input files
@input @value:5 Quality (0-9; lower is better)
#comments-end

Func extract_normalize_mp3_lossy($inputs)
	Local $batch[1]
	For $filepath in $inputs[0]
		Local $mp3filepath = ChangeExt($filepath, "mp3")
		_ArrayAdd($batch, 'ffmpeg\bin\ffmpeg.exe -i "' & $filepath & '" -q:a ' & $inputs[1] & ' -map 0:a "' & $mp3filepath & '"')
		_ArrayAdd($batch, 'mp3gain\mp3gain.exe /r /c "' & $mp3filepath & '"')
	Next
	return $batch
EndFunc
