#!/bin/sh
gst-launch-1.0 autovideosrc name=src0 ! video/x-raw,width=640,height=480 ! videoconvert ! x264enc bitrate=90000 pass=quant quantizer=25 rc-lookahead=0 sliced-threads=true speed-preset=superfast sync-lookahead=0 tune=zerolatency ! rtph264pay pt=100 mtu=1400 config-interval=3 ! udpsink port=50001 host=127.0.0.1 sync=false
