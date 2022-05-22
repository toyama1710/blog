---
title: "ダブリングでLCA求めるやつ(DoublingTree)"
date: 2021-09-08T23:59:11+09:00
description: ""
draft: false
math: true
toc: true
categories: [競プロ]
tags: [ライブラリ]
---

[DoublingTree](https://toyama1710.github.io/cpp_library/tree/doubling_tree.hpp)のドキュメント\
LCAを求めたり木上の任意の2ノード間の距離を $\Theta(\log N)$ で計算したりできる

doubling_tree.hppにはDoublingTreeクラスとDoublingTreeBuilderクラスを定義してある

## DoublingTree

### コンストラクタ

```cpp
template<class InputItr>
DoublingTree(InputItr first, InputItr last)
```

vector\<optional\<int\>\>をiteratorで渡す (list\<optional\<long long\>\>とかでも動くと思うけどverifyしとらん)\
DoublingTree(v.begin(), v.end())みたいに呼び出す\
v[i]には頂点iの親が入る 頂点iが根の場合は親がないのでnulloptをいれておく

### lca(int u, int v)

頂点u,vのLowestCommonAncestorを求める $\Theta(\log N)$\
u, vが連結でない場合の動作は未定義

### climb(int u, int d)
戻り値の型はoptional\<int\>\
頂点uを根方向にd個遡った頂点を返すが、もしも根を飛び越してしまうような場合にはnulloptを返す $\Theta(\log N)$

### distance(int u, int v)
頂点u, vの距離をintで返す $\Theta(\log N)$\
u, vが連結でない場合の動作は未定義

## DoublingTreeBuilder
入力形式によってはDoublingTreeのコンストラクタが扱いにくいので作った補助クラス

### コンストラクタ
DoublingTreeBuilder(n)で頂点数n個の木を作る\
最初、どの頂点も辺で接続されていない

### add_edge(int u, int v)
頂点u,vを直接結ぶ辺を追加する

### build(const vector\<int\> &root = {0})
指定した頂点を根としてDoublingTreeを構築して返してくれる\
森を扱うことを考えて根は複数指定できるようにしてある
