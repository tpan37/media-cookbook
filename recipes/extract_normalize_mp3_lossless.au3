#comments-start
@title Extract audio from video as normalized MP3 files (lossless)
@desc-start
Extract MP3 audio track from given video files using ffmpeg (lossless).

Then the volume of extracted MP3 files are normalized using mp3gain (lossless).

This recipe only works for source files with audio tracks already in the MP3 format so that they can be extracted without any additional transcoding.
#desc-end
@input @filelist Input files
#comments-end

Func extract_normalize_mp3_lossless($inputs)
	Local $batch[1]
	For $filepath in $inputs[0]
		Local $mp3filepath = ChangeExt($filepath, "mp3")
		_ArrayAdd($batch, 'ffmpeg\bin\ffmpeg.exe -i "' & $filepath & '" -vn -acodec copy "' & $mp3filepath & '"')
		_ArrayAdd($batch, 'mp3gain\mp3gain.exe /r /c "' & $mp3filepath & '"')
	Next
	return $batch
EndFunc
