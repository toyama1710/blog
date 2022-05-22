---
title: "ModInt書いた"
date: 2021-09-13T21:41:19+09:00
description: ""
draft: false
math: false
toc: false
categories: [競プロ]
tags: [ライブラリ]
---

[ModInt](https://toyama1710.github.io/cpp_library/math/modint.hpp)のドキュメント　書くこと、あるか？

```cpp
ModInt<998244353> mi(1);
ModInt<998244353> mi = 5;
```
みたいにテンプレート引数で法を指定して使う\
法が素数でない場合の挙動は未定義(多分除算以外は動くと思うけど...)

mod p上での四則演算ができる　intが入り混じったりした式でも動く

cin, cout での入出力ができる

比較演算子は定義していない　どうしても比較を行う場合はメンバ変数`d`を直接参照すること
