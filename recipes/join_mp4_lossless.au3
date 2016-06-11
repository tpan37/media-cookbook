#comments-start
@title Join MP4 video files (lossless)
@desc-start
Join given MP4 video files without transcoding (lossless)

This recipe only works for MP4 source files encoded using H264 video and AAC audio codecs.
#desc-end
@input @filelist Input files
@input @filepath Output file
#comments-end

Func join_mp4_lossless($inputs)
	Local $batch[1], $count = 0
	For $filepath in $inputs[0]
		Local $tsfilepath = ChangeExt($filepath, "ts")
		_ArrayAdd($batch, 'ffmpeg\bin\ffmpeg.exe -i "' & $filepath & '" -c copy -bsf:v h264_mp4toannexb -f mpegts tmp' & $count & '.ts')
		$count = $count + 1
	Next
	Local $filelist
	For $i = 0 to $count-1
		$filelist = $filelist & 'tmp' & $i & '.ts'
		If $i < $count-1 Then $filelist = $filelist & '|'
	Next
	_ArrayAdd($batch, 'ffmpeg\bin\ffmpeg -i "concat:' & $filelist & '" -c copy -bsf:a aac_adtstoasc "' & $inputs[1] & '"', 0, @TAB) 
	For $i = 0 to $count-1
		_ArrayAdd($batch, 'del /q ' & 'tmp' & $i & '.ts')
	Next
	return $batch
EndFunc
