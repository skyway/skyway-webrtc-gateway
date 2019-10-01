require './util.rb'

SKYWAY_API_KEY = ENV["API_KEY"]
PEER_ID = "media_caller"
TARGET_ID = "media_callee"
RECV_ADDR = "127.0.0.1"
VIDEO_RECV_PORT = 20000
AUDIO_RECV_PORT = 20001
VIDEO_RTCP_RECV_PORT = 20010
AUDIO_RTCP_RECV_PORT = 20011

#connect to skyway server
peer_token = create_peer(SKYWAY_API_KEY, PEER_ID)
#port open request for sending data
(video_id, video_ip, video_port) = create_media(true)
(audio_id, audio_ip, audio_port) = create_media(false)
(video_rtcp_id, video_rtcp_ip, video_rtcp_port) = create_rtcp()
(audio_rtcp_id, audio_rtcp_ip, audio_rtcp_port) = create_rtcp()

video_redirect = [RECV_ADDR, VIDEO_RECV_PORT]
audio_redirect = [RECV_ADDR, AUDIO_RECV_PORT]
video_rtcp_redirect = [RECV_ADDR, VIDEO_RTCP_RECV_PORT]
audio_rtcp_redirect = [RECV_ADDR, AUDIO_RTCP_RECV_PORT]
media_connection_id = call(PEER_ID, peer_token, TARGET_ID, video_id, video_redirect, audio_id, audio_redirect, video_rtcp_id, video_rtcp_redirect, audio_rtcp_id, audio_rtcp_redirect)
wait_ready(media_connection_id)
#now you can send stream form your app

puts "you can send video RTP packet to at #{video_ip}:#{video_port} as #{video_id}"
puts "you can send video RTCP packet to at #{video_rtcp_ip}:#{video_rtcp_port} as #{video_rtcp_id}"
puts "you can send audio RTP packet to at #{audio_ip}:#{audio_port} as #{audio_id}"
puts "you can send audio RTCP packet to at #{audio_rtcp_ip}:#{audio_rtcp_port} as #{audio_rtcp_id}"
puts "video from #{TARGET_ID} will redirect to  #{RECV_ADDR}:#{VIDEO_RECV_PORT}"
puts "video RTCP from #{TARGET_ID} will redirect to  #{RECV_ADDR}:#{VIDEO_RTCP_RECV_PORT}"
puts "audio from #{TARGET_ID} will redirect to  #{RECV_ADDR}:#{AUDIO_RECV_PORT}"
puts "audio RTCP from #{TARGET_ID} will redirect to  #{RECV_ADDR}:#{AUDIO_RTCP_RECV_PORT}"

sleep(1000)
#closing
request(:delete, "/media/connections/#{media_connection_id}")
request(:delete, "/peers/#{PEER_ID}?token=#{peer_token}")
