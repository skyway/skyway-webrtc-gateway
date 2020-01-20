# Config

You can change a WebRTC Gateway's behavior by editing [config.toml](https://github.com/skyway/skyway-webrtc-gateway/blob/master/config.toml), which is located in the same directory as gateway itself.

[config.toml](https://github.com/skyway/skyway-webrtc-gateway/blob/master/config.toml)を編集することで動作を変更することができます。
config.tomlはgatewayと同じディレクトリに配置してください。

```toml
[general]
# default: 8000
api_port = 8000
# error, warn, debug
log_level = "error"
```

Api_port is from 1025 to 65535. It shows the port number of API endpoint.

Log_level is "error", "warn" or "debug".

api_portはAPIエンドポイントのポート番号で、1025から65535の間で設定可能です。

log_levelは"error", "warn", "debug"の3種類が設定可能です。