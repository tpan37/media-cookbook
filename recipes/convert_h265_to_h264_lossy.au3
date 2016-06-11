#comments-start
@title Convert H265 video files to H264 MP4 files (lossy)
@desc-start
Convert H265-encoded video files to H265-encoded MP4 files (lossy).

The audio stream is assumed to be AAC-encoded and copied without transcoding. The video stream is transcoded to H264.
#desc-end
@input @filelist Input files
#comments-end

Func convert_h265_to_h264_lossy($inputs)
	Local $batch[1]
	For $filepath in $inputs[0]
		Local $mp4filepath = ChangeExt($filepath, "mp4")
		_ArrayAdd($batch, 'ffmpeg\bin\ffmpeg.exe -i "' & $filepath & '" -bsf:v h264_mp4toannexb -map 0:v -map 0:a -c:a copy -vcodec libx264 "' & $mp4filepath & '"')
	Next
	return $batch
EndFunc
