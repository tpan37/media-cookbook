#comments-start
@title Convert any video file to H264 MP4 file (lossy)
@desc-start
Convert any video file supported by ffmpeg to H264 MP4 file (lossy)

The audio stream is assumed to be either AC3 or AAC and is copied without transcoding.

This recipe is useful for reducing the size of an input file with unnecessarily high bitrate, or to transcode an uncommon codec (eg. H265) into the more widely used H264.
#desc-end
@input @filelist Input files
@input @value:-1 New video width (-1 = no change)
@input @value:23 CRF/quality (0-51; lower is better)
#comments-end

Func convert_to_h264_lossy($inputs)
	Local $batch[1]
	For $filepath in $inputs[0]
		Local $mp4filepath = ChangeExt($filepath, "mp4")
		_ArrayAdd($batch, 'ffmpeg\bin\ffmpeg.exe -i "' & $filepath & '" -bsf:v h264_mp4toannexb -map 0:v -map 0:a -filter:v scale=' & $inputs[1] & ':-1 -c:a copy -c:v libx264 -crf ' & $inputs[2] & ' "' & $mp4filepath & '"')
	Next
	return $batch
EndFunc
