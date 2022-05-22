---
title: "Test"
date: 2020-10-27T11:38:09+09:00
draft: false
tags: [markdown]
categories: [others]
math: true
toc: true
description: "テストページです"
---

このブログはHugoで生成されています。
これは各種機能のテストのために作ったページです。

md の書き方とか自分用のドキュメントも兼ねてる

## 見出し1
`##` で `<h2>` 相当
### 見出し2
`###` で `<h3>` 相当\
`#` は `<h1>` 相当なんですが自動生成される目次に使われない

## フロントマター

md の先頭の `---` で囲まれたところに yaml 形式でいろんなパラメータを置いてく

    toc: true
h1,h2とかを拾って目次を自動生成してくれる。

    tags: [t1, t2, .... , tN]
    categories: [c1, c2, ... , cN]
タグとかカテゴリの設定

    math: true
KaTeXを読み込む 数式を書かない記事ならfalseにしとくと若干読み込みが速い(はず)

    description: "abracadabra"
記事の summary を手動設定する　設定しなくても勝手に最初の方の文章を拾ってくれる


## syntax highlight test

` ``` ` でコードブロックを囲うといい感じにしてくれる。

    ```c++
    ここにプログラムを書く
    ```
    
みたいな感じで言語名を書くとパースしてハイライトしてくれて嬉しい

    ```rust{linenos=table}
    fn main() {
        println!("hello");
    }
    ```

みたいにして行番号も付けられる


C++コード
```c++
#include <iostream>

#define _overload(_1, _2, _3, _4, name, ...) name
#define _rep1(Itr, N) _rep3(Itr, 0, N, 1)
#define _rep2(Itr, a, b) _rep3(Itr, a, b, 1)
#define _rep3(Itr, a, b, step) for (i64 (Itr) = a; (Itr) < b; (Itr) += step)
#define repeat(...) _overload(__VA_ARGS__, _rep3, _rep2, _rep1)(__VA_ARGS__)

using namespace std;
using i64 = long long;

int main() {
    for (int i = 0; i < 3; i++) cout << "hello0" << '\n';
    repeat(i, 3) cout << "hello1" << '\n';
    repeat(i, 0, 3) cout << "hello2" << '\n';
    repeat(i, 0, 3, 1) cout << "hello3" << '\n';
}
```

Rust コード
```rust {linenos=table}
fn main() {
    for i in 0..3 {
        println!("hello");
    }
}
```

## math test


`$$`で囲った数式をいい感じにしてくれる。`$` で囲った時はインライン表示する

$$
\KaTeX{}
$$

配列 $A, B$ の要素を適切に並べ替えて $\sum_{i=1}^{N} A_i \times B_i$ を最小化してください

配列 `$A, B$` の要素を適切に並べ替えて `$\sum_{i=1}^{N} A_i \times B_i$` を最小化してください


displaystyleとか使うと見慣れた感じにできる。

配列 $A, B$ の要素を適切に並べ替えて $\displaystyle \sum_{i=1}^{N} A_i \times B_i$ を最小化してください

配列 `$A, B$` の要素を適切に並べ替えて `$\displaystyle \sum_{i=1}^{N} A_i \times B_i$` を最小化してください

## md の忘れそうな文法とか

空行は段落を切り替えるときに使って段落変えずに改行する時は `\` を使う(今まで混同してたのでメモ)

`<pre>` は文章の前に空白4つ入れると使える

`*`で囲むと *強調* になる 2つ使うともっと強い　**FAKE** とか書ける

リンクは `[テキスト](URL)` で貼れる [sample](/) `[sample](https://blog.toyama1710.net/)` `[sample](/)`

ほとんど同じ要領で画像も貼れる `![alt属性](画像URL)`

HTMLコードもそのまま書ける 画像のサイズ調整とか必要になったら `<img>` タグで画像を貼る
