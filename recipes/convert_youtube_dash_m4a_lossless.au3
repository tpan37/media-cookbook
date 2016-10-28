#comments-start
@title Convert YouTube "dash" audio files to M4A files (lossless)
@desc-start
Convert YouTube "dash" audio files to normal M4A files using ffmpeg (lossless).

This is required for YouTube DASH audio files because the MP4 container's ftyp has the "major brand" set to "dash" instead of "m4a".

Then the volume of converted M4A files are normalized using aac3gain (lossless).

Input files should use the ".mp4" extension, from which ".m4a" files will be produced.
#desc-end
@input @filelist Input files
#comments-end

Func convert_youtube_dash_m4a_lossless($inputs)
	Local $batch[1]
	For $filepath in $inputs[0]
		Local $m4afilepath = ChangeExt($filepath, "m4a")
		_ArrayAdd($batch, 'ffmpeg\bin\ffmpeg.exe -i "' & $filepath & '" -vn -c:a copy "' & $m4afilepath & '"')
		_ArrayAdd($batch, 'aacgain\aacgain.exe /r /c "' & $m4afilepath & '"')
	Next
	return $batch
EndFunc
