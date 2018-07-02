#!/bin/sh
gst-launch-1.0 audiotestsrc ! audioresample ! audio/x-raw,channels=1,rate=16000 ! opusenc bitrate=20000 ! rtpopuspay pt=111 ! udpsink host=127.0.0.1 port=50002
