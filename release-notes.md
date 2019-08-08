# SkyWay WebRTC Gateway release notes

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
