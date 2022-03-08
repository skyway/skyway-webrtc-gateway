# SkyWay WebRTC Gateway release notes

## [v0.4.1](https://github.com/skyway/skyway-webrtc-gateway/releases/tag/0.4.1)

- Call への応答 API で `constranints` の `video` が `false` の場合に PLI パケット送信 API を実行した際、405 エラーが返却される不具合を修正しました。

## [v0.4.0](https://github.com/skyway/skyway-webrtc-gateway/releases/tag/0.4.0)

- `PeerID` を指定せずに生成した `Peer` が、シグナリングサーバと自動再接続する際に、 `PeerID` が変わってしまう不具合を修正しました。
- Peer認証に使用される `Credential` の更新後に `Peer` がシグナリングサーバと自動再接続する際、再接続に失敗する不具合を修正しました。
- `Peer` がシグナリングサーバと自動再接続する際に、 `Peer` のopenイベントが再発火する不具合を修正しました。
- シグナリングサーバへの接続プロセスを修正し、 `Peer` からディスパッチャーサーバへのリクエストが失敗した場合に再接続するようにしました。
- セキュリティの強化を実施しました。

## [v0.3.2](https://github.com/skyway/skyway-webrtc-gateway/releases/tag/0.3.2)

- `/media/connections/{media_connection_id}/answer` で解放済みのmediaを設定するとクラッシュする不具合を修正しました。

## [v0.3.1](https://github.com/skyway/skyway-webrtc-gateway/releases/tag/0.3.1)

- SCTPに関する脆弱性への対応

## [v0.3.0](https://github.com/skyway/skyway-webrtc-gateway/releases/tag/0.3.0)

- バグの修正
  - 通話を繰り返すことによりメモリ使用量が増加してしまう問題を修正
  - `Peer`インスタンスを生成するとき、`+`などの記号を含む`Peer ID`を引数に指定した場合、指定した`Peer ID`と異なる`Peer ID`が割り当てられる問題を修正
- [SkyWay Peer Authentication](https://github.com/skyway/skyway-peer-authentication-samples) に対応
- [API Referenceの更新](http://35.200.46.204/)

## [v0.2.1](https://github.com/skyway/skyway-webrtc-gateway/releases/tag/0.2.1)

- DELETE命令を行ってもポートが閉じないことがあるバグを修正(#19)

## [v0.2.0](https://github.com/skyway/skyway-webrtc-gateway/releases/tag/0.2.0)

- ポート番号・ログレベルの変更のための設定ファイルを定義
- 内部で利用しているlibWebRTCのバージョンを更新(M72)
- 長時間起動時の安定性を向上
- 依存ライブラリを整理

## [v0.1.0](https://github.com/skyway/skyway-webrtc-gateway/releases/tag/0.1.0)

- 受信したRTCPのユーザへの送信[(#3)](https://github.com/skyway/skyway-webrtc-gateway/issues/3)
- RTCPの相手側への転送[(#4)](https://github.com/skyway/skyway-webrtc-gateway/issues/4)

## [v0.0.4](https://github.com/skyway/skyway-webrtc-gateway/releases/tag/0.0.4)

- バグの修正
  - 長時間起動し大量にcallした際にクラッシュする問題を修正

## [v0.0.3](https://github.com/skyway/skyway-webrtc-gateway/releases/tag/0.0.3)

- バグの修正
  - /data/connections/{data_connection_id}/statusの中のフィールド名が間違っている(#11)
  - /media/connections/{media_connection_id}/statusの戻り値が間違っている(#12)
- 軽微な変更
  - REST API Access時のTimeout時間を5秒から30秒に延長(#13)

## [v0.0.2](https://github.com/skyway/skyway-webrtc-gateway/releases/tag/0.0.2)

- ARM版の追加[(#1)](https://github.com/skyway/skyway-webrtc-gateway/issues/1)
- Gateway側でノイズが鳴るバグを修正[(#6)](https://github.com/skyway/skyway-webrtc-gateway/issues/6)

## [v0.0.1](https://github.com/skyway/skyway-webrtc-gateway/releases/tag/0.0.1)

- first release
