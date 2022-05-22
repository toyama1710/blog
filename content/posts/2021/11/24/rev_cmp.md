---
title: "RevCmp"
date: 2021-11-24T23:04:30+09:00
description: ""
draft: false
math: false
toc: false
categories: [競プロ]
tags: [ライブラリ]
---

[RevCmp](https://toyama1710.github.io/cpp_library/util/reverse_cmp.hpp)のドキュメント

templateで受け取った型Tの比較順を逆にしてくれる Rustのstd::cmp::Reverseと同じもの\
Tはoperator \<がきちんと定義されていれば大丈夫 中身はstd::rel_opsとあまり変わらん\
value()で内部のTを取り出す

[AVLSet](https://blog.toyama1710.net/posts/2021/09/02/avl/)とか[LeftistHeap](https://blog.toyama1710.net/posts/2021/11/24/leftist_heap/)で要素を降順に取り出したいときに活躍する
