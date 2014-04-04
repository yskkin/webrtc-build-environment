WebRTC Build Environment
========================

Android 向けの [WebRTC](http://www.webrtc.org)
を用いたネイティブアプリを作るのに必要なライブラリのビルド環境

前提
====

- [Vagrant](http://www.vagrantup.com/) のインストール(VirtualBox等も含む)
- [Chef](http://www.getchef.com/)のインストール
- Ruby実行環境

利用方法
=======


初回のセットアップ
------------------

```bash
vagrant box add hashicorp/precise64
git clone https://github.com/yskkin/webrtc-build-environment.git /path/to/repo
cd /path/to/repo
bundle install
bundle exec berks install --path cookbooks
vagrant up
```

pull時
------

```bash
vagrant up --provision
```

ライブラリのビルド
------------------

```bash
vagrant ssh
# 以下VM内で
cd webrtc/trunk
ninja -C out/Release AppDemoRTC
```

`webrtc/trunk/out/Release` 下に生成される成果物
- `AppRTCDemo-debug.apk` : サンプルアプリ
- `libjingle_peerconnection_so.so`, `libjingle_peerconnection.jar` : ライブラリ

既知の問題
==========

`vagrant up` で時間がかかるので、 Control-c で中断するとうまくいっていることがあります。


問題が解決できない場合は[オリジナルの手順](http://www.webrtc.org/reference/getting-started)を参考にしてください。
