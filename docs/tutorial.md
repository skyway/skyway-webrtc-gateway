# Gateway Tutorial

macのdocker(Docker Desktop)を用いてGatewayサーバを立て、複数コンソールウィンドウでデータ・映像・音声の送受信を行うチュートリアルです。

システム構成は以下の通りです。Gatewayサーバを介してClient AとClient Bで送受信します。

```
mac(client A)<->docker(gw)<->mac(client B)
```


## 環境
macOS Mojave 10.15.7

```shell
$ docker --version
Docker version 20.10.0, build 7287ab3
$ ruby --version
Ruby 2.7.2p137 (2020-10-01 revision 5445e04352) [x86_64-darwin19]
$ nc --version
netcat (The GNU Netcat) 0.7.1
```

今回は[こちら](https://github.com/skyway/skyway-webrtc-gateway/tree/master/samples)のサンプルを利用します。

```
├── samples
│   ├── data_callee.rb
│   ├── data_caller.rb
│   ├── media_callee.rb
│   ├── media_caller.rb
│   └── util.rb
```

## Docker

Docker Imageを作成します。

```bash
$ git clone https://github.com/skyway/skyway-webrtc-gateway.git
$ cd skyway-webrtc-gateway
$ docker build . -t gateway-image
```

作成したイメージからコンテナを起動します。

8000/tcp(Peer作成などのREST APIエンドポイント用)、また、50001-50020/udp(メディア・データ送受信用)をポートフォワーディングします。

詳細は[こちら](https://github.com/skyway/skyway-webrtc-gateway/blob/master/docs/network.md)をご覧ください。

```bash
$ docker run --name gw -d -p 8000:8000 -p 50001-50020:50001-50020/udp gateway-image
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                                          NAMES
d2c352d6f6b6        c1d55d9a96c0        "/skyway/gateway_lin…"   3 seconds ago       Up 2 seconds        0.0.0.0:8000->8000/tcp, 0.0.0.0:50000-50010->50000-50010/udp   gw
```

### `host.docker.internal`のIP取得
Gatewayを用いてRTPなどをもらうためのIPを設定する必要があります。
dockerにおいて、guestからhostにアクセスする場合は`host.docker.internal`のFQDNを用いるので、そのIPをnslookupで参照しておきます。

※`host.docker.internal`はDocker Desktopのみ利用可能です。

```
$ docker exec gw nslookup host.docker.internal
nslookup: can't resolve '(null)': Name does not resolve

Name:      host.docker.internal
Address 1: 192.168.65.2
```

得られたIP(Address 1)を**全ての**sampleファイル`RECV_ADDR`, `DATA_RECV_ADDR`のvalueに設定してください。

data_caller.rbであれば、以下の通りです。

```ruby
DATA_RECV_ADDR = "192.168.65.2"
```

## dataconnection
SkyWayのAPIキーをご用意ください。
APIキーの発行は会員登録後、[こちら](https://console-webrtc-free.ecl.ntt.com/)から行えます。


利用するsampleファイルは以下の通りです。

- data_callee.rb
- data_caller.rb

それぞれ別のターミナルウィンドウで実行します。
 `DATA_RECV_ADDR`を変更してあることを確認して**先にdata_callee.rbを実行してください。**

window1(callee)
```bash
$ export API_KEY=03f94c1b-89dv-4cmn-b6aa-c999ab4467n1
$ ruby data_callee.rb ruby
```

実行後、特に出力はされません。
次に、別ウィンドウでdata_caller.rbを実行します。


window2(caller)
```bash
$ export API_KEY=03f94c1b-89dv-4cmn-b6aa-c999ab4467n1
$ ruby data_caller.rb ruby
```

両方のウィンドウで下記のようなメッセージが出れば準備完了です。

window1(callee)
```bash
you can send udp data to at 172.17.0.2:50001 as da-c1ee150b-eaf0-4c58-815f-7ae4a652fbeb
data from data_caller will redirect to  192.168.65.2:10002
```

windos2(caller)
```shell
you can send udp data to at 172.17.0.2:50002 as da-f5a079c7-34df-42dd-bd1d-412bc5dda1f0
data from data_callee will redirect to  192.168.65.2:10001
```

上記の例では`you can send udp data to at 172.17.0.2:50002` とありますが、ポートフォワードしてるので今回の場合は`localhost:50002`であることに注意してください。

UDPの口ができたのでnetcatで送受信を行います。mac標準にnetcatがinstallされていますが、もしinstallされていない場合はhomebrewなどでinstallしてください。

上記2ウインドウはsleepで1000秒待機した後closeが走るようになっているので、closeした場合はお手数ですが再度実行してください。

今回はさらに2ウィンドウ追加し(合計4ウィンドウ)、callerからcalleeに対してメッセージを送ってみます。


window3(callee)
```bash
$ nc -u -l 10002
```

homebrewなどでinstallしたnetcatの場合は`-p`が必要なことがあります。

window3(callee)
```bash
$ nc -u -l -p 10002
```

次に、適当な文字を送信します。今回は`hi`という文字列を送信します。

window4(caller)
```shell
$ nc localhost -u 50002
hi
```

`window3(callee)`で`hi`と表示されれば成功です。

## mediaconnection

利用するsampleファイルは以下の通りです。

- media_callee.rb
- media_caller.rb

gStreamerを利用します。プラグインなど含めインストールされていない場合はhomebrewを用いて、必要なライブラリをインストールしてください。

```bash
$ brew install gstreamer gst-libav gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly
```

先ほどのdataconnectionと同じように`media_callee.rb`、`media_caller.rb`の順で実行します。

window1(callee)
```bash
$ ruby media_callee.rb ruby
["rc-9b931d15-533d-49dd-879d-6e00db6678cf", "172.17.0.2", 50003]
["rc-6a210025-072e-4f46-9464-cb36d14b6eb7", "172.17.0.2", 50004]
you can send video RTP packet to at 172.17.0.2:50001 as vi-ec2f592e-3b55-4b00-8df4-703f37bd89b7
you can send video RTCP packet to at 172.17.0.2:50003 as rc-6a210025-072e-4f46-9464-cb36d14b6eb7
you can send audio RTP packet to at 172.17.0.2:50002 as au-a479b092-c44b-427e-8675-03e35891fc6e
you can send audio RTCP packet to at 172.17.0.2:50004 as rc-6a210025-072e-4f46-9464-cb36d14b6eb7
video from media_caller will redirect to  192.168.65.2:20000
video RTCP from media_caller will redirect to  192.168.65.2:20010
audio from media_caller will redirect to  192.168.65.2:20001
audio RTCP from media_caller will redirect to  192.168.65.2:20011
```

window2(caller)
```bash
$ ruby media_caller.rb ruby
you can send video RTP packet to at 172.17.0.2:50005 as vi-eb0cf478-2ac6-42bb-8752-8cf7b19062a0
you can send video RTCP packet to at 172.17.0.2:50007 as rc-0c4d71b4-e219-41eb-9e36-d1d309bde4ed
you can send audio RTP packet to at 172.17.0.2:50006 as au-2d17954f-8ddf-4ab2-8992-fc1c2a65540a
you can send audio RTCP packet to at 172.17.0.2:50008 as rc-1364f796-4d9b-4ba0-9a7c-2da84f1a251d
video from media_callee will redirect to  192.168.65.2:20000
video RTCP from media_callee will redirect to  192.168.65.2:20010
audio from media_callee will redirect to  192.168.65.2:20001
audio RTCP from media_callee will redirect to  192.168.65.2:20011
```

dataconnection同様、新規ウィンドウ2枚作りgstreamerを利用して送受信を行います。
以後利用するgstreamerのサンプルスクリプトは[こちら](https://github.com/skyway/skyway-webrtc-gateway/tree/master/gst-sample-script)になります。

### video

`callee` 側のshellの結果を確認してください。 上記の例では`caller` からのvideoは `20000` ポートに送られます。

```
video from media_caller will redirect to  192.168.65.2:20000
```

[video_recv.sh](https://github.com/skyway/skyway-webrtc-gateway/blob/master/gst-sample-script/video_recv.sh)の`port`部分を、shellの結果に応じて変更してください。

ポートの設定が完了したら、実行してください。

window3(callee)
```bash
$ ./video_recv.sh
```

次にcallerがsendを行います。

上記の `caller` 側のshellの結果を確認してください。 上記の例では50005ポートからvideoを送信することができます。

```
you can send video RTP packet to at 172.17.0.2:50005 as vi-eb0cf478-2ac6-42bb-8752-8cf7b19062a0
```

[video_send.sh](https://github.com/skyway/skyway-webrtc-gateway/blob/master/gst-sample-script/video_send.sh)の`port`部分を、shellの結果に応じて変更してください。映像ソースはデフォルトのカメラが選択されます。

Webカメラが存在しない場合は映像ソースを`autovideosrc`から`videotestsrc`に変更してください。


ポートの設定が完了したら、実行してください。

window4(caller)
```bash
$ ./video_send.sh
```

別ウィンドウでWebカメラの映像が別ウィンドウで表示されれば成功です。

※映像ウィンドウが表示されるまで10秒程かかることがあります。

### audio
videoと同じく、Audioを送信するポートと受信するポートを確認後、`audio_recv.sh`と`audio_send.sh`を実行します。

window1の結果からaudioは `20001` ポートに送られます。

```
audio from media_caller will redirect to  192.168.65.2:20001
```

[audio_recv.sh](https://github.com/skyway/skyway-webrtc-gateway/blob/master/gst-sample-script/audio_recv.sh)の`port`部分を、shellの結果に応じて変更してください。

ポートの設定が完了したら、実行してください。

window3(callee)
```bash
$ ./audio_recv.sh
```

pulsesinkが存在せずエラーが発生する場合は、`pulsesink`を`autoaudiosink`に変更してください。

```
gst-launch-1.0  udpsrc port=20001 caps="application/x-rtp,payload=(int)111" ! rtpjitterbuffer latency=200 ! rtpopusdepay ! opusdec ! audioconvert ! autoaudiosink
```

次にcallerがsendを行います。window2のshellの結果を確認してください。 上記の例では50006ポートからaudioを送信することができます。

```
you can send audio RTP packet to at 172.17.0.2:50006 as au-2d17954f-8ddf-4ab2-8992-fc1c2a65540a
```

[audio_send.sh](https://github.com/skyway/skyway-webrtc-gateway/blob/master/gst-sample-script/audio_send.sh)の`port`部分を、shellの結果に応じて変更してください。

ポートの設定が完了したら、実行してください。

window4(caller)
```bash
$ ./audio_recv.sh
```

”ポー”という440Hzのサイン波の音源がスピーカーまたはヘッドホンから出力されれば成功です。

## トラブルシューティング
### サンプルスクリプトで、`create_peer': undefined method `[]' for nil:NilClass (NoMethodError)が表示される
スクリプトを終了してもPeerIDが残るため、スクリプトを再度実行する場合はお手数ですがGatewayサーバの再起動を行なってください

```
$ docker restart gw
```

### その他
メディア・データが受信できない場合は以下の項目をチェックしてください
- APIキーのexportを行なっているか
- DATA_RECV_ADDRの書き換えたか
- listenポートは50020以下であるか
  - 必要ならばレンジを広げてください
- (mediaの場合) gstreamerのパイプラインのPortは合っているか

また必要に応じて、Gatewayサーバのログ表示してデバッグを行うことができます。

[こちら](https://github.com/skyway/skyway-webrtc-gateway/blob/5355ae0e7011413574efd12ece0886965ea0181b/Dockerfile#L6)をdebugにしてimageを再ビルドします。

以下のコマンドで Gatewayサーバのログをwatchできます。

```
$ docker logs gw -f
```
