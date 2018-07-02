#!/bin/sh
gst-launch-1.0  udpsrc port=20001 caps="application/x-rtp,payload=(int)111" ! rtpjitterbuffer latency=200 ! rtpopusdepay ! opusdec ! audioconvert ! pulsesink 
