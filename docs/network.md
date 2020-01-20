# Contents Receving Port

WebRTC Gateway opens content receiving port in response to API access.
This is regardless of the media, data, or RTCP
It opens sequentially from 50001, regardless of the media, data, or RTCP.

WebRTC GatewayはAPIアクセスに従い、エンドユーザプログラムから転送するコンテンツの受信ポートを開放します。
これはmedia, data, rtcpの区別なく、50001番から連番で開放されます。

example
```shell
$ curl -X POST "http://127.0.0.1:8000/media/rtcp" -H  "accept: application/json" -H  "Content-Type: application/json" -d "{}"
{
  "ip_v4": "172.16.0.105",
  "port": 50001,
  "rtcp_id": "rc-c6f1fa98-577f-4141-bb38-74f0eaa44806"
}
$ curl -X POST "http://127.0.0.1:8000/data" -H  "accept: application/json" -H  "Content-Type: application/json" -d "{}"
{
  "data_id": "da-a54b47c6-72a0-4d21-aa99-602b678f742a",
  "ip_v4": "172.16.0.105",
  "port": 50002
}
$ curl -X POST "http://127.0.0.1:8000/media" -H  "accept: application/json" -H  "Content-Type: application/json" -d "{  \"is_video\": true}"
{
  "ip_v4": "172.16.0.105",
  "media_id": "vi-b693d23d-23bb-4f13-98f5-a7d39c3de567",
  "port": 50003
}
$ curl -X POST "http://127.0.0.1:8000/media" -H  "accept: application/json" -H  "Content-Type: application/json" -d "{  \"is_video\": true}"
{
  "ip_v4": "172.16.0.105",
  "media_id": "vi-f8bef9f9-e12b-4338-98d5-bc3c7188cd31",
  "port": 50004
}
$ curl -X POST "http://127.0.0.1:8000/media/rtcp" -H  "accept: application/json" -H  "Content-Type: application/json" -d "{}"
{
  "ip_v4": "172.16.0.105",
  "port": 50005,
  "rtcp_id": "rc-ded8d91f-ffba-4ea5-9cd0-d1d99a4a7fb5"
}
$ curl -X POST "http://127.0.0.1:8000/data" -H  "accept: application/json" -H  "Content-Type: application/json" -d "{}"                     
{
  "data_id": "da-90947052-57e0-413b-af4c-42397867a43b",
  "ip_v4": "172.16.0.105",
  "port": 50006
}

```

In this case, WebRTC Gateway has following ports.

上記のようにAPIアクセスした場合、実際に開放されるポートは以下のようになります。

| port   | kind |
|--------|------|
| 50001  | rtcp |
| 50002 | data |
| 50003  | rtp  |
| 50004  | rtp  |
| 50005  | rtcp |
| 50006  | data |


Also, the binding of content port can used in multiple DataConnection or MediaConnection.

開放されたポートは、複数のDataConnectionまたはMediaConnectionに割り当て可能です。