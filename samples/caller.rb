require './util.rb'

SKYWAY_API_KEY = "YOUR API KEY"
PEER_ID = "caller"
TARGET_ID = "callee"
DATA_RECV_ADDR = "127.0.0.1"
DATA_RECV_PORT = 10001
RECV_ADDR = "127.0.0.1"
VIDEO_RECV_PORT = 20000
AUDIO_RECV_PORT = 20001

#connect to skyway server
peer_token = create_peer(SKYWAY_API_KEY, PEER_ID)
#port open request for sending data
(video_id, video_ip, video_port) = create_media(true)
(audio_id, audio_ip, audio_port) = create_media(false)
video_redirect = [RECV_ADDR, VIDEO_RECV_PORT]
audio_redirect = [RECV_ADDR, AUDIO_RECV_PORT]
media_connection_id = call(PEER_ID, peer_token, TARGET_ID, video_id, audio_id, video_redirect, audio_redirect)
wait_stream(media_connection_id)
#now you can send stream form your app

#port open request for sending data
(data_id, dest_ip, dest_port) = create_data
#establish dataconnection with target
data_connection_id = connect(peer_token, PEER_ID, TARGET_ID, data_id, DATA_RECV_ADDR, DATA_RECV_PORT)
wait_open(data_connection_id)
#now you can send data from your app

puts "you can send rtp-video data to at #{video_ip}:#{video_port} as #{video_id}"
puts "you can send rtp-audio data to at #{audio_ip}:#{audio_port} as #{audio_id}"
puts "you can send udp data to at #{dest_ip}:#{dest_port} as #{data_id}"
puts "video from #{TARGET_ID} will redirect to  #{RECV_ADDR}:#{VIDEO_RECV_PORT}"
puts "audio from #{TARGET_ID} will redirect to  #{RECV_ADDR}:#{AUDIO_RECV_PORT}"
puts "data from #{TARGET_ID} will redirect to  #{DATA_RECV_ADDR}:#{DATA_RECV_PORT}"

sleep(1000)
#closing
request(:delete, "/media/connections/#{media_connection_id}")
request(:delete, "/peers/#{PEER_ID}?token=#{peer_token}")
