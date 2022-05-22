---
title: "永続weight-biased lefitst heap書いた"
date: 2021-11-24T23:04:24+09:00
description: "永続版のweight-biased leftist heap"
draft: false
math: true
toc: false
categories: [競プロ]
tags: [ライブラリ, ヒープ, 永続データ構造]
---

[PersistentLeftistHeap](https://toyama1710.github.io/cpp_library/heap/persistent_leftist_heap.hpp)のドキュメント

[LeftistHeap](https://blog.toyama1710.net/posts/2021/11/24/leftist_heap/)の永続化実装になってる

## インタフェース

### Self merge_with(Self h)
hとマージしてできたヒープを返す $\Omicron(\log N)$

### Self push(T v)
vを追加したヒープを返す $\Omicron(\log N)$

### Self pop()
最小値を削除したヒープを返す $\Theta(1)$

### int size()
ヒープに格納されている要素数 $\Theta(1)$

### bool empty()
ヒープが空か？ $\Theta(1)$
