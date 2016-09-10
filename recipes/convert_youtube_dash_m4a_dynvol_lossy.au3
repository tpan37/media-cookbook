#comments-start
@title Convert YouTube "dash" audio files to M4A files (lossy)
@desc-start
Convert YouTube "dash" audio files to normal M4A files using ffmpeg.

This is required for YouTube DASH audio files because the MP4 container's ftyp has the "major brand" set to "dash" instead of "m4a".

The volume of the converted M4A files are normalized using the "Dynamic Audio Normalizer" filter (lossy) integrated into ffmpeg.

Input files should use the ".mp4" extension, from which ".m4a" files will be produced.
#desc-end
@input @filelist Input files
#comments-end

Func convert_youtube_dash_m4a_dynvol_lossy($inputs)
	Local $batch[1]
	For $filepath in $inputs[0]
		Local $m4afilepath = ChangeExt($filepath, "m4a")
		_ArrayAdd($batch, 'ffmpeg\bin\ffmpeg.exe -i "' & $filepath & '" -vn -af dynaudnorm "' & $m4afilepath & '"')
	Next
	return $batch
EndFunc
