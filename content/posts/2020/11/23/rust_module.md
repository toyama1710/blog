---
title: "RustのモジュールシステムのTips"
date: 2020-11-23T22:48:01+09:00
draft: false
math: false
toc: true
categories: [Rust]
tags: [Rust, Cargo]
description: "Rustのモジュールシステム、ググっても中々必要な情報に辿り着けないし調べ直すと手間だからハマったポイントについてまとめるぜ！"
twitter_card: "summary"
---

Rustのモジュールシステム、ググっても中々必要な情報に辿りつけなくて辛いです\
自分がハマったポイントについてまとめます

## 複数の実行可能バイナリを1つのクレートにまとめる

クライアントとホストのプラグラムを1つのクレートにまとめたい、なんてときに使えます\
depandeciesを1箇所にまとめられて便利

```toml
[[bin]]
name = "host"
path = "src/host_src/main.rs"

[[bin]]
name = "client"
path = "src/client_src/main.rs"
```

Cargo.tomlにこんな感じに追記します\
binテーブルの配列にパスと生成するバイナリファイルの名前を書けばいいです

cargo run での実行は `cargo run --bin <NAME>` になります\
生成されたバイナリは、上記の例のclientであれば target/debug/client か target/release/client にあります

### 全てのバイナリで共通するモジュール

今、クレートのディレクトリ構成が次のようだったとします

```
rust_ssh
    └--src
        ├--lib.rs
        ├--cipher.rs
        |
        ├--host_src
        |    └--main.rs
        └--client_src
             └--main.rs
```

この時、host_src/main.rs と client_src/main.rs の双方からcipherモジュールを参照することを考えます

これちょっと罠なんですが crate::cipher ではアクセスできなくて、rust_ssh::cipher でアクセスします

```rust
use rust_ssh::cipher;

fn main() {
    cipher::encrypt();
}
```

みたいな感じ\
client も host も同じクレート内にあるんだから crate::cipher でアクセスできるに決まってるだろ！wって言ってたらハマりました

## pub use でディレクトリ構造を変える

競技ミングのライブラリを書いているとよく

```rust
use crate::segment_tree::lazy_segment_tree::LazySegmentTree;
```

みたいなuse句を書くことがあります\
これを

```rust
use crate::segment_tree::LazySegmentTree
```

のように書けるようにします

まず、次のようなディレクトリ構成を考えます

```
rs_library
    └--src
        ├--lib.rs
        └--segment_tree
              ├--mod.rs
              ├--lazy_segment_tree.rs
              ├--dual_segment_tree.rs
              └--segment_tree.rs
```

mod.rs は

```
pub mod lazy_segment_tree
pub mod dual_segment_tree
pub mod segment_tree
```

となっているとします。\
LazySegmentTree は lazy_segment_tree.rs で定義されている構造体です

ここで、mod.rs を次のように書き換えます

```rust
pub mod lazy_segment_tree
pub mod dual_segment_tree
pub mod segment_tree

pub use lazy_segment_tree::*;
pub use dual_segment_tree::*;
pub use segment_tree::*;
```

これで、crate::segment_tree::LazySegmentTree のようにして LazySegmentTree にアクセスできるようになりました

pub use を使ってスコープに持ち込んだパスを外部に公開することで、ファイルを分割したままあたかも1つのファイルで定義されているかのように見せかけることができ、パスが冗長化するのを防ぐことができます
