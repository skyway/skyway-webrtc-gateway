require "net/http"
require "json"
require "socket"

HOST = "localhost"
PORT = 8000

def parse_response(json)
  if json.is_a?(Net::HTTPCreated)
    JSON.parse(json.body)
  elsif json.is_a?(Net::HTTPOK)
    JSON.parse(json.body)
  elsif json.is_a?(Net::HTTPAccepted)
    JSON.parse(json.body)
  elsif json.is_a?(String)
    JSON.parse(json)
  else
    json
  end
end

def request(method_name, uri, *args)
  response = nil
  Net::HTTP.start(HOST, PORT) { |http|
    response = http.send(method_name, uri, *args)
  }
  response.each_header { |name, value|
  }
  response
end

def wait_thread_for(uri, event: "OPEN", ended: nil)
  e = nil
  thread_event = Thread.new do
    while e == nil or e["event"] != event
      r = request(:get, uri)
      e = parse_response(r)
    end
    if ended
      ended.call(e)
    end
  end.run
  thread_event
end

def create_peer(key, peer_id)
  params = {
      "key": key,
      "domain": "localhost",
      "turn": true,
      "peer_id": peer_id,
  }
  res = request(:post, "/peers", JSON.generate(params))
  json = parse_response(res)
  json["params"]["token"]
end

def create_media(is_video)
  params = {
      is_video: is_video,
  }
  #open datasocket for sending data
  res = request(:post, "/media", JSON.generate(params))
  json = parse_response(res)
  media_id = json["media_id"]
  ip_v4 = json["ip_v4"]
  port = json["port"]
  [media_id, ip_v4, port]
end

def create_constraints(video_id, audio_id)
  {
      "video": true,
      "videoReceiveEnabled": true,
      "audio": true,
      "audioReceiveEnabled": true,
      "video_params": {
          "band_width": 1500,
          "codec": "H264",
          "media_id": video_id,
          "payload_type": 100,
      },
      "audio_params": {
          "band_width": 1500,
          "codec": "opus",
          "media_id": audio_id,
          "payload_type": 111,
      }
  }
end

def call(peer_id, token, target_id, video_id, audio_id, video_redirect, audio_redirect)
  constraints = create_constraints(video_id, audio_id)
  redirect_params = {
      "video": {
          "ip_v4": video_redirect[0],
          "port": video_redirect[1],
      },
      "audio": {
          "ip_v4": audio_redirect[0],
          "port": audio_redirect[1],
      },
  }

  params = {
      "peer_id": peer_id,
      "token": token,
      "target_id": target_id,
      "constraints": constraints,
      "redirect_params": redirect_params,
  }

  res = request(:post, "/media/connections", JSON.generate(params))
  json = parse_response(res)
  json["params"]["media_connection_id"]
end

def wait_call(peer_id, peer_token)
  media_connection_id = nil
  thread_event = wait_thread_for("/peers/#{peer_id}/events?token=#{peer_token}", event: "CALL", ended: lambda { |e|
    media_connection_id = e["call_params"]["media_connection_id"]
  })

  thread_event.join
  media_connection_id
end

def wait_stream(media_connection_id)
  thread_event = wait_thread_for("/media/connections/#{media_connection_id}/events", event: "STREAM", ended: lambda { |e|
  })

  thread_event.join
end

def answer(media_connection_id, video_id, audio_id, video_redirect, audio_redirect)
  constraints = create_constraints(video_id, audio_id)
  redirect_params = {
      "video": {
          "ip_v4": video_redirect[0],
          "port": video_redirect[1],
      },
      "audio": {
          "ip_v4": audio_redirect[0],
          "port": audio_redirect[1],
      },
  }

  params = {
      "constraints": constraints,
      "redirect_params": redirect_params,
  }
  res = request(:post, "/media/connections/#{media_connection_id}/answer", JSON.generate(params))
  json = parse_response(res)
end

def redirect(media_connection_id, video_redirect, audio_redirect)
  params = {
      "video": {
          "ip_v4": video_redirect[0],
          "port": video_redirect[1],
      },
      "audio": {
          "ip_v4": audio_redirect[0],
          "port": audio_redirect[1],
      },
  }
  res = request(:post, "/media/connections/#{media_connection_id}/redirect", JSON.generate(params))
  json = parse_response(res)
end

def create_data
  #open datasocket for sending data
  res = request(:post, "/data", '{}')
  json = parse_response(res)
  data_id = json["data_id"]
  ip_v4 = json["ip_v4"]
  port = json["port"]
  [data_id, ip_v4, port]
end

def connect(token, peer_id, target_id, data_id, recv_ip, recv_port)
  params = {
      "peer_id": peer_id,
      "token": token,
      "target_id": target_id,
      "options": {
          "serialization": "BINARY",
      },
      "params": {
          "data_id": data_id,
      },
      "redirect_params": {
          "ip_v4": recv_ip,
          "port": recv_port,
      }
  }
  res = request(:post, "/data/connections", JSON.generate(params))
  json = parse_response(res)
  data_connection_id = json["params"]["data_connection_id"]
  data_connection_id
end

def wait_open(data_connection_id)
  thread_event = wait_thread_for("/data/connections/#{data_connection_id}/events", event: "OPEN", ended: lambda { |e|
  })
  thread_event.join
end

def wait_connection(peer_id, peer_token)
  data_connection_id = nil
  thread_event = wait_thread_for("/peers/#{peer_id}/events?token=#{peer_token}", event: "CONNECTION", ended: lambda { |e|
    data_connection_id = e["data_params"]["data_connection_id"]
  })
  thread_event.join
  data_connection_id
end

def manage_data_transmission_settings(data_connection_id, data_id, redirect_addr, redirect_port)
  params = {
      #for sending data
      "feed_params": {
          "data_id": data_id,
      },
      #for receiving data
      "redirect_params": {
          "ip_v4": redirect_addr,
          "port": redirect_port,
      },
  }

  res = request(:put, "/data/connections/#{data_connection_id}", JSON.generate(params))
end
