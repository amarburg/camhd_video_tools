FFMPEG Snippets
==============

Extracting a snippet of video
----------------------------

	ffmpeg -y -ss 5:00 -i in.mp4 -ss 0:30 -to 1:00 -c copy out.mp4

Copies (does not transcode) a 30-second subset from 5m30s - 6m00s.
The flags are:

	-y          Yes, overwrite existing file

	-ss 5:00    [Before -i] Fast seek to 5m00s.   Does a coarse seek to the
	            closest i-frame before 5m00s (?)

	-i in.mp4   Input file

	-ss 0:30    [After -i] Slow/precise seek relative to previous seek, so in this
	            case seeks to 5m30s.

	-to 1:00     Sets total duration of copy, **relative to the first seek**

	-c copy      Direct copy (no transcode)

	out.mp4      Output file

On my desktop (i7 @ 3.3GHz, SSD) against a ~850MB CamHD .mp4, this takes 0.074 s.

The resulting file is (from ffprobe).

	Input #0, mov,mp4,m4a,3gp,3g2,mj2, from 'snippet.mp4':
	  Metadata:
	    major_brand     : isom
	    minor_version   : 512
	    compatible_brands: isomiso2avc1mp41
	    encoder         : Lavf57.36.100
	  Duration: 00:00:29.73, start: 0.330000, bitrate: 8512 kb/s
	    Stream #0:0(und): Video: h264 (High) (avc1 / 0x31637661), yuv420p, 1920x1080 [SAR 1:1 DAR 16:9], 8510 kb/s, 29.97 fps, 29.97 tbr, 30k tbn (default)
	    Metadata:
	      handler_name    : VideoHandler

If I omit the second (fine) `-ss` (note I've had to adjust the `-to` as well):

	ffmpeg -y -ss 5:30 -i CAMHDA301-20160526T180000Z.mp4 -to 0:30 -c copy snippet.mp4

Runtime is essentially the same.  The result is:

	Input #0, mov,mp4,m4a,3gp,3g2,mj2, from 'snippet.mp4':
	  Metadata:
	    major_brand     : isom
	    minor_version   : 512
	    compatible_brands: isomiso2avc1mp41
	    encoder         : Lavf57.36.100
	  Duration: 00:00:32.73, start: -2.673000, bitrate: 8467 kb/s
	    Stream #0:0(und): Video: h264 (High) (avc1 / 0x31637661), yuv420p, 1920x1080 [SAR 1:1 DAR 16:9], 8464 kb/s, 29.97 fps, 29.97 tbr, 30k tbn (default)
	    Metadata:
	      handler_name    : VideoHandler

a slightly _longer_ file.


An ~~equivalent~~ similar C++ program [tools/EveryFrame.cpp](tools/EveryFrame.cpp), which
simply decodes every frame in the video, takes 1m44s to read the entire video @ ~25100 frames.



Creating a timelapse
--------------------

From http://pr0gr4mm3r.com/linux/how-to-create-a-time-lapse-video-using-ffmpeg/

	#!/bin/bash

	# Description: make time lapse video
	# Usage: time-lapse.sh <source-video> <destination-file> <frames>
	# Source Video: the video that you are wanting to speed up
	# Destination File: the file where the video will be saved
	# Frames: the number of frames to pull per second (1 will speed it up the most, 10 will be slower)

	mkdir ffmpeg_temp
	ffmpeg -i $1 -r $3 -f image2 ffmpeg_temp/%05d.png
	ffmpeg -i ffmpeg_temp/%05d.png -b 512 $2
