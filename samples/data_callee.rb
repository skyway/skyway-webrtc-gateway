require './util.rb'

SKYWAY_API_KEY = ENV["API_KEY"]
PEER_ID = "data_callee"
TARGET_ID = "data_caller"
DATA_RECV_ADDR = "127.0.0.1"
DATA_RECV_PORT = 10002

#connect to skyway server
peer_token = create_peer(SKYWAY_API_KEY, PEER_ID)
#port open request for sending data
(data_id, dest_ip, dest_port) = create_data
#wait for datachannel establishment
data_connection_id = wait_connection(PEER_ID, peer_token)
wait_open(data_connection_id)
#now you can send data from your app
manage_data_transmission_settings(data_connection_id, data_id, DATA_RECV_ADDR, DATA_RECV_PORT)

puts "you can send udp data to at #{dest_ip}:#{dest_port} as #{data_id}"
puts "data from #{TARGET_ID} will redirect to  #{DATA_RECV_ADDR}:#{DATA_RECV_PORT}"

sleep(1000)
#closing
request(:delete, "/data/connections/#{data_connection_id}")
request(:delete, "/peers/#{PEER_ID}?token=#{peer_token}")
