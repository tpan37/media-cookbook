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

#include <Array.au3>
#include <File.au3>
#include <FileConstants.au3>
#include "mutils.au3"
Local $inputs[3]
Local $input_0[1]
$input_0[0] = "F:\Downloads\Video\song.mp3"
$inputs[0] = $input_0
$inputs[1] = "0.0"
$inputs[2] = "F:\Downloads\Video\song_2.mp3"
$batch = change_db_anyfile($inputs)
_ArrayInsert($batch, 1, "@title Media Cookbook (CMD)")
_ArrayAdd($batch, "@pause")
Local $fh = FileOpen("_recipe.cmd", $FO_OVERWRITE + $FO_ANSI)
_FileWriteFromArray($fh, $batch, 1, Default, "")
FileClose($fh)
