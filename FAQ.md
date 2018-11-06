## 要注意点について

### Video/Audioが出ない

通信中にKeyframeが欠損した場合、次のKeyframe受信まで映像が正常に表示できません。これを避けるため、次の点を確認して下さい。

1. 受信側の再生アプリケーション起動後にRTPを送信開始する
2. "/media/connections/#{media_connection_id}/events" を監視し "STREAM" イベント(*)発火後にRTPメディアを送信する

*このイベントは、STUNパケットを受信したタイミングで発火しますので、相手側がRTPパケットを送信していなくても、MediaStream確立に成功した時点で発火します。

### Mac版のChromeでH.264エンコードのビデオが表示されない

x264encを利用した場合、H.264のChrome側で無視されるようです。OpenH264でエンコードすることにより表示されることを確認しています。
https://github.com/skyway/skyway-webrtc-gateway/issues/14
