# skyway-webrtc-gateway

[English version of this document](./README.md)

SkyWay WebRTC Gatewayは、WebRTCの可能性を広げる実験的な取り組みです。
ともにイノベーションに挑戦する仲間を募集しています。

## コンセプト

SkyWayは、WebRTCを誰にとっても使いやすくすることをミッションとして開発しています。
まずブラウザに対してはシグナリングを提供するところからスタートし、次にiOSやAndroidでも動かせるようにSDKを開発するなどサポート範囲の拡大を行ってきました。
これらの取り組みの次の一手として、動作対象とユースケースを一気に拡大すべく、IP通信のできる全てのデバイスをサポートするために作ったのがこのSkyWay WebRTC Gatewayです。

## 背景

ブラウザの中にあるWebRTC Engineは、ブラウザのAPIを介してしか操作できません。ブラウザ上のJavaScriptからの操作が前提になっています。

![WebブラウザのWebRTC Engineを直接コントロールできない](https://raw.githubusercontent.com/skyway/skyway-webrtc-gateway/master/images/as_is.png)

そのためかゆいところに手が届かず、悩んでいることがあるのではないでしょうか。例えば

- ブラウザを動かす能力のないデバイスでもWebRTCで通信したい
- 外部にあるIoTデバイスをどうやって操作したらいいんだろう？
- AIで映像を解析したり、作ったデータを送りたいんだけど…
- サーバでも動かしたいんだけど、ヘッドレスブラウザでは用途に合わないんだよね…
- 自社にある莫大なSIP/RTP資産をWebRTC時代にも活用できないものか…？
- etc...

外部のプログラムから自由に操作できる、むき出しのWebRTC Engineがあればもっと自由度が高く開発できるのに…

<div align="center">
<img src="https://raw.githubusercontent.com/skyway/skyway-webrtc-gateway/master/images/to_be.png" width=50%>
</div>

このようなニーズを埋めるためには、[libWebRTC](https://github.com/aisouard/libwebrtc)のようなWebRTCライブラリを利用して自分で一から開発するか、[OpenWebRTC](https://www.openwebrtc.org)や[Janus](https://janus.conf.meetecho.com)のようなWebRTC対応のアプリケーションを利用するかしか方法がありませんでした。
しかし、ライブラリの内容を理解してアプリケーションを開発するのは大変です。既存のアプリケーションもブラウザとは使い勝手が異なったり、シグナリングサーバやTURNサーバを自分で準備する必要があったり、開発者から運用サポートが得られないという問題があったりと、サービス導入までには様々な課題が有りました。

## 機能

以上の問題を解決するため、WebRTC通信エンジンをSkyWayでラッピングしたアプリケーションとして、SkyWay WebRTC Gatewayを開発しました。次のような機能があります。

- 今まで通りSkyWayを利用できる
    - シグナリングサーバ、TURNサーバの利用
    - 既存のAPIに似たREST APIで操作できる
- 外部から自由にデータを流し込むことができる
    - RTPを送ってMediaStream経由で相手側へ送信する
    - 相手側から届いたMediaStreamをRTPで受け取る
    - UDPを送ってDataChannelに流し込む
    - DataChannelで届いたデータをUDPで受け取る
- 単体のアプリケションとして動作するので、非力なデバイスでも他の端末上で動作しているSkyWay WebRTC Gatewayを利用できる

![WebRTCを外部プログラムから自由に扱える](https://raw.githubusercontent.com/skyway/skyway-webrtc-gateway/master/images/module.png)

## 利用の流れ

まずREST APIを叩き、WebRTCセッションを確立します。
後は外部のプログラムからダイレクトにRTPやUDPでデータを送受信すれば、確立したWebRTCセッション上をデータが流れていきます。
録画用デバイスに映像を流し込んだり、Firewallの裏にいるデバイスに制御信号を送ったりとWebRTCをさまざまなユースケースで自由に扱えるようになります。



## ユースケース

WebRTC Engineを自由に操作できることで、その用途は無限に広がります。
その一部をご紹介します。

- 自分ではWebRTCを話せない非力なデバイスをブラウザからコントロール

![IoT UseCase](https://raw.githubusercontent.com/skyway/skyway-webrtc-gateway/master/images/iot.png)

- 通話録音

![Recorder UseCase](https://raw.githubusercontent.com/skyway/skyway-webrtc-gateway/master/images/record.png)


- VRゲームの通信部分をWebRTCで実装する

![VR Game](https://raw.githubusercontent.com/skyway/skyway-webrtc-gateway/master/images/vr_game.png)

- 1000人に同じ映像を送ってバーチャルWebRTCerになりたい

![Virtual Youtuber](https://github.com/skyway/skyway-webrtc-gateway/blob/master/images/vtuber.png)

- クラウド上のAI基盤へのデータ集積

![AI UseCase1](https://raw.githubusercontent.com/skyway/skyway-webrtc-gateway/master/images/ai_1.png)

- クラウド上のAI基盤の解析結果閲覧

![AI UseCase2](https://raw.githubusercontent.com/skyway/skyway-webrtc-gateway/master/images/ai_2.png)

- 既存SIP/RTP機器の活用

![SIP UseCase](https://raw.githubusercontent.com/skyway/skyway-webrtc-gateway/master/images/sip.png)


他にも面白い使い方を思いついたら教えて下さい！

## How to Use

[API Reference](http://35.200.46.204)

[samples](https://github.com/skyway/skyway-webrtc-gateway/tree/master/samples)

[sequence](https://github.com/skyway/skyway-webrtc-gateway/tree/master/sequence)

[FAQ](https://github.com/skyway/skyway-webrtc-gateway/blob/master/FAQ.md)

[開発者コミュニティ](https://support.skyway.io/hc/ja/community/topics/360000026987)

## Download

### x86_64

- [Linux](https://github.com/skyway/skyway-webrtc-gateway/releases/download/0.0.1/gateway_linux)(Ubuntu18.04, 16.04, etc.)
- [Windows](https://github.com/skyway/skyway-webrtc-gateway/releases/download/0.0.1/gateway_windows.exe)(10, 8, 7)

MD5

gateway_windows.exe: 2b65ba995e3890d717e9501aedb22d1f

gateway_linux_x64: aeddc1ea62f5494a1d31002b83ba6330


### ARM

- [ARM](https://github.com/skyway/skyway-webrtc-gateway/releases/download/0.0.2/gateway_linux_arm)

MD5

gateway_linux_arm: a6646dcb00432c87ebf5f01656dec161


## Updates and Release Notes

[issues](https://github.com/skyway/skyway-webrtc-gateway/issues)
[release notes](https://github.com/skyway/skyway-webrtc-gateway/blob/master/release-notes.md)

## License

[利用規約](https://webrtc.ecl.ntt.com/terms.html)

このソフトウェアは、 Apache 2.0ライセンスで配布されている製作物が含まれています。

[LICENSE](https://github.com/skyway/skyway-webrtc-gateway/blob/master/LICENSE.txt)

[NOTICE](https://github.com/skyway/skyway-webrtc-gateway/blob/master/NOTICE.txt)
