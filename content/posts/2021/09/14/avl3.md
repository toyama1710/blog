---
title: "AVL木書いた3"
date: 2021-09-14T13:15:41+09:00
description: "std::multisetと同じことができる永続AVL木"
draft: false
math: true
toc: false
categories: [競プロ]
tags: [ライブラリ, 平衡二分木, 永続データ構造]
---

[PersistentAVLSet](https://toyama1710.github.io/cpp_library/bbst/persistent_avl_set.hpp)のドキュメント

[AVLSet](https://blog.toyama1710.net/posts/2021/09/02/avl/)を継承してinsert/erase周りをオーバーライドして実装\
insert/eraseで変更のあるノードは $O(\log N)$ 個なので全部コピーして良い

merge/split は未実装 (オーバーライドしてassertすべき？)\
count(), find_Kth()などのメソッドはそのまま使用可能

## insert(const T &dat)
dat を集合に追加する　戻り値はdatを追加したあとのPersistentAVLSet\
呼び出し元のオブジェクトを変更することはない $\Theta (\log N)$

## erase(const T &dat)
dat を集合から削除する 戻り値はdatを削除したあとの PersistentAVLSet\
呼び出し元のオブジェクトを変更することはない $\Theta (\log N)$
