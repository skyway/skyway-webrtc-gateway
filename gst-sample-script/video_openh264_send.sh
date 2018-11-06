#!/bin/sh
gst-launch-1.0 v4l2src device=/dev/video1 ! videoconvert ! video/x-raw,width=640,height=480,framerate=60/1 ! videoconvert ! openh264enc enable-denoise=true qp-max=20 complexity=high background-detection=true rate-control=off ! rtph264pay ! udpsink port=50001 host=127.0.0.1 sync=false
