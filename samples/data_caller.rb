require './util.rb'

SKYWAY_API_KEY = "YOUR API KEY"
PEER_ID = "data_caller"
TARGET_ID = "data_callee"
DATA_RECV_ADDR = "127.0.0.1"
DATA_RECV_PORT = 10001

#connect to skyway server
peer_token = create_peer(SKYWAY_API_KEY, PEER_ID)
#port open request for sending data
(data_id, dest_ip, dest_port) = create_data
#establish dataconnection with target
data_connection_id = connect(peer_token, PEER_ID, TARGET_ID, data_id, DATA_RECV_ADDR, DATA_RECV_PORT)
wait_open(data_connection_id)
#now you can send data from your app

puts "you can send udp data to at #{dest_ip}:#{dest_port} as #{data_id}"
puts "data from #{TARGET_ID} will redirect to  #{DATA_RECV_ADDR}:#{DATA_RECV_PORT}"

sleep(1000)
#closing
request(:delete, "/data/connections/#{data_connection_id}")
request(:delete, "/peers/#{PEER_ID}?token=#{peer_token}")
