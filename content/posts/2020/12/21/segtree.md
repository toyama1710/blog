---
title: "セグメント木"
date: 2020-12-21T02:07:22+09:00
description: "セグ木のライブラリのドキュメント"
draft: false
math: true
toc: true
categories: [競プロ]
tags: [ライブラリ]
---

TODO: 書き切る\
2次元セグ木以降は随時更新のつもり

## SegmentTree

空間: $O(N)$ (より正確にはちょうど $2N$)

いわゆる普通のセグ木\
1点更新/区間取得が $O(log N)$ 

### Monoid

template の Monoid が満たすべき要件は以下

- 演算対象のデータの型を Monoid::value_type (以降 T ) とする
- T の二項演算を operation() として定義
- (T, operation()) の単位元を identity() として定義

コードにすると次のようになる

```c++
struct M {
    using value_type = T;
    static T identity() { return T(); };
    static T operation(T lhs, T rhs) { return lhs + rhs; };
};
```

### コンストラクタ

要素数を指定して単位元で埋められてセグ木を指定するものと、要素の列を iterator で渡して初期化するものの 2 種類\
ともに $O(N)$

### fold(l, r)

時間: $O(log N)$

区間 $[l, r)$ を左からfoldしていく\
`for i in [l, r) { s += arr[i]; }` みたいな感じ

### update(k, dat)

時間: $O(log N)$

k 番目の要素を dat で上書きする

### search(l, fn)

時間: $O(log N)$

fn: T を 1 つだけ引数にとりboolを返す関数

fn(fold(l, i)) が true になるような最初の i を返す\
そのような i が存在しない場合 -1 を返す

## DualSegmentTree

空間: $O(N)$

双対セグ木\
区間更新/1点取得が $O(log N)$ 

### Monoid

SegmentTree と同じ

### コンストラクタ

要素数 n の単位元で埋まったセグ木を作る

### update(l, r, op)

時間: $O(log N)$

区間 $[l, r)$ に op を作用させる

### get(k)

左から k 番目のデータを取得

## LazySegmentTree

空間: $O(N)$

遅延伝播セグメント木\
区間更新/区間取得が $O(log N)$ 

### MonoidwithOperator

SegmentTree の Monoid と同じように定義された型 M と O があるとする\
M は fold したいモノイドで、O は作用素\
下のコードのようにして値、作用素、2者の演算を定義する

```c++
struct A {
    using value_structure = M;
    using operator_structure = O;
    using T = typename M::value_type;
    using E = typename O::value_type;
    static T operation(T dat, E op) {
        return dat + op;
    };
};
```

ただし、T, E はサンプルコードを簡単にするためのものでテンプレート引数の要件には含まれない

### update(l, r, op)

時間: $O(log N)$

区間 [l, r) に作用素 op を作用させる

### set(k, dat)

時間: $O(log N)$

左から k 番目の要素を dat で上書きする

### fold(l, r)

時間: $O(log N)$

区間 [l, r) を左から fold していく

## SegmentTree2D

2次元セグ木

## DynamicSegmentTree

必要なところだけつくるセグ木\
座圧したいけどオンラインなので辛い、みたいなときに使う

## PersistentSegmentTree

永続セグ木
