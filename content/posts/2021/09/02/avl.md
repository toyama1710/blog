---
title: "AVL木書いた"
date: 2021-09-02T02:49:09+09:00
description: "AVL木でC++のstd::multiset相当のものを実装した"
draft: false
math: true
toc: true
categories: [競プロ]
tags: [ライブラリ, 平衡二分木]
---

[AVLSet](https://toyama1710.github.io/cpp_library/bbst/avl_set.hpp) のドキュメント

## 外から叩くメソッド

### template引数
template引数Tが満たすべき要件は以下
- operator < を実装していること
- 順序が正しく定義されていること

### insert(const T &dat)
datを集合に挿入する\
格納しているデータ数 $N$ に対して $\Theta(\log N)$

既に同値なデータが木に含まれている場合にも新たにノードを作って挿入する

### erase(const T &dat)
dat を削除する $\Theta(\log N)$ \
同じ要素が複数ある場合、そのうちの一つのみを削除する

### contains(const T &dat)
datが集合に含まれている場合trueを返し、そうでないときfalseを返す

### lower_bound(const T &x)
戻り値はoptional<T> 計算量は $\Theta(\log N)$\
x以上の最小の要素を探して返す　そのような要素がないときはnulloptを返す

### upper_bound(const T &x)
ほぼlower_bound()と同じ\
xより大きい最小の要素を返す　

### find_Kth(int k)
集合内の要素の小さい方から $k$ 番目の要素を返し、ない場合はnulloptを返す\
0-indexedなのでset.find_Kth(0)で最小の要素を参照できる　最大値はset.find_Kth(set.size() - 1)\
$\Theta(\log N)$ で動作する

### count(const T &x)
xと等価な要素の個数を返す $\Theta(\log N)$

### count_lower(const T &x)
x**より小さい**要素の個数を返す $\Theta(\log N)$

### count_upper(const T &x)
x**より大きい**要素の個数を返す $\Theta(\log N)$

### list()
集合内の要素を昇順に並べたvectorを返す $\Theta(N)$\
イテレータを実装していないので、集合内の要素をなめたいときにはこれを使う

### merge_with(AVLSet &r)
$x \le y(x \in this, y \in r)$ が成り立つとき、thisにrをマージする $\Theta(\log N)$\
マージ後、rは空になる\
条件が厳しいのであまり使わない

### split(int k)
thisのうち小さい方からk個を含むsetと、それ以外の要素からなるsetをpairにして返す $\Theta(\log N)$\
適当に切ってあげることで集合のうち $x \in [l, r)$ であるような要素だけにクエリを投げたりできる　countシリーズやfind_Kthを使えば大体さばけるので使わない

## 内部での実装補助用の関数

### rotate(Node *u)
ノードuを中心に回転させる　rotate<0>(u)で左回転 rotate<1>(u)で右回転になる\
左回転はuの左子を持ち上げる操作を指す\
$O(1)$

### balance(Node *u)
uを根とするような木を平衡させる\
ただし、uの左部分木、右部分木がともにAVL木であることと高さの差が$2$以下であることを仮定する\
$O(1)$

### isolate_node(Node *u)
ノードuを木から切り離す　戻り値はuを切り離してできた木の根
$\Theta(\log N)$

### split_rightest_node(Node *v)
ノードvを根とする木の最右ノードを木から切り離す\
戻り値型はpairで、firstは最右ノードを切り離してできた木の根、secondは切り離された最右ノード\
$\Theta(\log N)$

### dump()
デバッグ用　木を出力する
