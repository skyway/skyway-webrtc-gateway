#!/bin/sh
gst-launch-1.0 udpsrc port=20000 caps="application/x-rtp,paylocad=(int)100" ! rtpjitterbuffer latency=500 ! rtph264depay ! avdec_h264 output-corrupt=false ! videoconvert ! fpsdisplaysink sync=false
