---
title: "簡易Deployerを実装しました"
date: 2020-12-02T20:27:21+09:00
draft: false
toc: true
description: "簡易的なDeployerをRustで実装しました"
categories: [ブログ制作]
tags: [ブログ制作, ネットワーク]
---

## はじめに

このブログのデプロイをscpで手作業で行っていたのを自動化しました\
github のレポジトリは[こちら](https://github.com/toyama1710/ssg-deployer/)

この記事は設計~開発の段階でメモ用紙代りに使っていた物です

## ユーザ認証の仕組み

RSA暗号を使います

事前にクライアントとホストでお互いに公開鍵を交換しておきます\
通信相手はこの公開鍵に対応する秘密鍵を持っているか？というのが基本的なアイデアです

1. 適当な長さの乱数列を暗号化して送信
1. 相手が乱数列を復号して返信してくるので、正しく復号できているか確認する
1. 正しく復号できていれば通信相手を信頼して良い　さもなければTCPコネクションを切断する

### 鍵の制約

PEM 形式の 4096 bit の鍵ファイルのみ受け付けます

いつも 2048 bit 使ってたりする人はごめんね

## 認証後の通信

RSAの暗号化/復号処理は重いので、ユーザ認証後は AES256CBC で暗号化して通信します\
鍵はセッションごとに乱数で生成

## 更新ファイルの確認

これは単純で、ホスト側とクライアント側でファイルのハッシュ値(SHA256)が同一か見てるだけ

ハッシュ値が違っていたり、ホスト側に存在しないファイルがあればそのファイルを送信します\
ホスト側にだけ存在しているファイルは消去します

## コマンド(クライアント)

`deploy section`

## 設定ファイル(クライアント)

dirs::config_dir()/ssg-deployer/config.toml に置く\
Linux であれば ~/.config/ssg-deployer/config.toml になるはず

```toml
[[section]]
name = "section_name"
user = "user_name"
host = "hostname"
publish_dir = "/path/to/public/"
port = 1710
own_pri = "/path/to/.ssh/id.pem"
host_pub = "/path/to/.ssh/host.pem.pub"
```

パスは絶対パスのみ受け付ける\
必ず '/' から始まっていること

## コマンド(ホスト)

`deploy-host` 
`-p num` でリッスンするポートを指定できる

優先順はコマンド > 設定ファイル

## 設定ファイル(ホスト)

```toml
port = 1710

[[authorized_client]]
user = "user_name"
client_pub = "/var/www/id_client.pem.pub"
own_pri = "/var/www/id.pem"

[[autorized_client]]
use = "toyama"
client_pub = "/var/www/id_toyama.pem.pub"
own_pri = "/var/www/id.pem"

[[section]]
name = "section_name"
publish_dir = "var/www/public/"
```

パスは絶対パスのみ受け付ける\
必ず '/' から始まっていること

## TODO

- ドキュメントをgithubに移す
- ‘~' から始まるパスにも対応する
