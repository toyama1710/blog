---
title: "多次元のvector作るやつ"
date: 2021-12-07T21:19:49+09:00
description: ""
draft: false
math: true
toc: false
categories: [競プロ]
tags: [ライブラリ]
---

[コード](https://toyama1710.github.io/cpp_library/util/make_vector.hpp)

## 概要

before:
```cpp
vector<vector<vector<T>>> vec = vector<vector<vector<T>>>(n1, vector<vector<T>>(n2, vector<T>(n3, e)));
```
after:
```cpp
auto vec = make_vector({n1, n2, n3}, e);
```

N次元vectorの宣言に$\Theta (N^2)$回もvectorって書きたくないので嬉しくなった\
`make_vector({n1, n2, n3}, 0);` と `make_vector({n1, n2, n3}, 0ll);` は等価ではないので注意(前者はint型で後者はlong long)\
要素数の指定でキャストの嵐になることもあるけどwarning無視したりRustも似たようなものだしなって思ったりすると辛さが薄れる\
`make_vector<long long>({n1, n2, n3}, 0)` みたいに呼び出した方が安全かもしれない

## 気持ちとか
戻り値の型をautoで推論できるのラムダ式だけだと思ってたので最近まで諦めてた\
実行時に型が決まるような仕組みではないので、テンプレート引数Nで次元の数を指定して 1次元, 2次元, 3次元.... のそれぞれの場合で違う関数になるようにしてる

可変引数テンプレートを使った方が実装は楽　その場合 `auto vec = make_vector(n1, n2, n3, e);` って書くことになるのでうっかり初期値を書き忘れて `auto vec = make_vector(n1, n2, n3);` とか書いてしまってもコンパイラでミスを検知できない\
自分の実装は妙にテクニカルになってしまったのでまあ一長一短
