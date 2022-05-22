---
title: "AVL木書いた2"
date: 2021-09-07T16:21:32+09:00
description: "列を超高機能に扱うタイプのAVL木書いた"
draft: false
math: true
toc: true
categories: [競プロ]
tags: [ライブラリ, 平衡二分木]
---

[AVLArray](https://toyama1710.github.io/cpp_library/bbst/avl_array.hpp)のドキュメント
AVL木で任意区間の切り貼り、区間反転、区間更新、区間積を $\Theta (\log N)$ でできるやつ書いた

[DynamicSequanceRangeAffineRangeSum](https://judge.yosupo.jp/problem/dynamic_sequence_range_affine_range_sum)が解ける

## 外から叩くやつ

### template引数
 MonoidwithOperator が満たすべき要件は[LazySegmentTree](https://blog.toyama1710.net/posts/2020/12/21/segtree/#monoidwithoperator)と同じ
 
 ```cpp
 struct A {
     using value_structure = M;
     using operator_structrue = O;
     using T = typename M::value_type;
     using E = typename O::value_type;
     static T  operation(T dat, E op) {
         return dat + op;
     };
 };
 ```

### insert_at(int k, const T &dat)
列の左からk番目にdatを挿入する(0-indexed) $\Theta (\log N)$\
arr.insert_at(0, dat); で列のはじめにdatを挿入する arr.insert_at(n, dat); で列の最後に追加

### set(int k, const T &dat)
arr[k] = dat ができる $\Theta (\log N)$

### erase_at(int k)
列の左からk番目の要素を削除する　残った要素は順序を保って連結される

### fold(int l, int r)
[l, r)のモノイドの積を返す $\Theta (\log N)$

### update(int l, int r, const E &op)
[l, r)に作用素opを適用する $\Theta (\log N)$

### reverse(int l, int r)
[l, r)の要素の順序を逆転させる\
例えば、{0, 1, 2, 3, 4, 5} で [1, 4) を reverse すると {0, 3, 2, 1, 4, 5} になる $\Theta (\log N)$

### rotate(int l, int mid, int r)
[std::rotate](https://cpprefjp.github.io/reference/algorithm/rotate.html)と同じことが $\Theta(\log N)$ でできる\
midが先頭に来るように[l, r)を巡回左シフトする

### append(AVLArray &r)
rをそっくりそのまま配列の直後に追加する\
append()を呼び出したあと、rは空になる $\Theta (\log N)$

### split_at(int k)
[0, k), [k, n) で配列を分割してpairで返す　元の配列は空になる $\Theta (\log N)$

### operator []
はい $\Theta (\log N)$

## 内部実装用のやつ

### push_down(Node *u)
uで遅延させている値やrev_flagを伝播させる

### balance(Node *u)
uを根とする部分木を平衡させる\
rotateを呼び出す前にpush_down()を必ず呼び出す　rev_flagを処理したときに平衡係数の正負が反転して正しく木を回転させられなくなるため

### merge(Node *mid, Node *l, Node *r)
l, mid, r の順で木をmergeする\
midは単一のノード, lとrは木の根\
基本的な戦略はl, r の高さの差が十分小さくなるまで木を潜っていって、midの左子をl,右子をrとする
l が高い場合はl->ch[1] = merge(mid, l->ch[1], r);としてやればおーけー
