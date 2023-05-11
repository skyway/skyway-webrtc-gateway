# Release Process

When an user release her end-user-program, the program needs to access some API to release objects in WebRTC Gateway.

エンドユーザプログラムの終了時には、WebRTC Gatewayで割り当てられているいくつかのリソースを開放してください。

- [DataConnection Release API](https://skyway.github.io/skyway-webrtc-gateway/#/2.data/data_connection_close)
- [MediaConnection Release API](https://skyway.github.io/skyway-webrtc-gateway/#/3.media/media_connection_close)
- [PeerObject Release API](https://skyway.github.io/skyway-webrtc-gateway/#/1.peers/peer_destroy)

It doesn't have to call these APIs, because they are automatically closed when P2P links which use the resources.
If the program access to the releasing APIs, they would return error codes, but it's ok to ignore the errors.
Notice: if these resources are created and not used yet, an end-user-program needs to access the releasing APIs.

DataConnectionやMediaConnetionの終了時、これらが内部的に使用していたコンテンツの受信ポートは自動的に終了されます。
そのためこれらのコンテンツポートを開放するためのAPIには明示的にアクセスする必要はありません。
既に開放済みの場合、これらのAPIへのアクセスはエラーを返しますが、無視して問題ありません。
* 但し、開放したもののDataConnetionやMediaConnectionで利用していないポートに関しては、以下のAPIにアクセスし手動で開放する必要があります。

- [Media Port Release API](https://skyway.github.io/skyway-webrtc-gateway/#/3.media/streams_delete)
- [RTCP Port Release API](https://skyway.github.io/skyway-webrtc-gateway/#/3.media/media_rtcp_delete)
- [Data Port Release API](https://skyway.github.io/skyway-webrtc-gateway/#/2.data/data_delete)
