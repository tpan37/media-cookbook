#comments-start
@title Change volume of an audio or video file in dB using ffmpeg
@desc-start
Change volume for a video or audio file in dB using ffmpeg


#desc-end
@input @filelist Input files
@input @value:0.0 Enter dB change (+/-0.0)
@input @filepath Output file
#comments-end

Func change_dB_anyfile($inputs)
	Local $batch[1]
	For $filepath in $inputs[0]
		_ArrayAdd($batch, 'ffmpeg\bin\ffmpeg.exe -i "' & $filepath & '" -af "volume=' & $inputs[1] & ' dB" -vcodec copy "' & $inputs[2] & '"')
		;ffmpeg" -i "inputfile.xxx" -af "volume=6.0dB" -vcodec copy "outputfile_normalized.xxx"
		;_ArrayAdd($batch, 'ffmpeg\bin\ffmpeg.exe -i "' & $filepath & '" -bsf:v h264_mp4toannexb -map 0:v -map 0:a -filter:v scale=' & $inputs[1] & ':-1 -c:a copy -c:v libx264 -crf ' & $inputs[2] & ' "' & $mp4filepath & '"')
	Next
	return $batch
EndFunc
