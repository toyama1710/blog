---
title: "weight-biased leftist heap 書いた"
date: 2021-11-24T23:03:39+09:00
description: "meldable heapの一種であるところのleftist heap書いた　mergeがO(log N)でできる"
draft: false
math: true
toc: true
categories: [競プロ]
tags: [ライブラリ, ヒープ]
---

[LeftistHeap](https://toyama1710.github.io/cpp_library/heap/leftist_heap.hpp) のドキュメント

最小ヒープになっていることと、C++のstd::priority_queueで言うところのtop()がpeek()になっている点に注意

## インタフェース

### template引数
template引数Tは比較演算子\<を定義している必要がある

### LeftistHeap &push(T val)
valをヒープに追加する $\Omicron (\log N)$

### LeftistHeap &merge_with(LeftistHeap &h)
自身とhを融合する　このメソッドを呼び出した後hは空になる $\Omicron (\log N)$

### LeftistHeap &pop()
ヒープ中で最小の要素を削除する $\Omicron (\log N)$

### T peek()
ヒープ中で最小の要素を返す $\Theta (1)$

### int size()
ヒープに格納されている要素の数を返す $\Theta (1)$

### bool empty()
ヒープが空ならtrueを返しさもなくばfalseを返す $\Theta (1)$

## 内部利用の関数と構造の解説

### 構造
weight-biased leftist heapは次の条件を満たす二分木である
- どのノードも左部分木のサイズが右部分木のサイズ以上 (leftist property)
- どのノードも自身の持つ値は部分木の持つ値以下 (heapify)

### Node *meld(Node *h1, Node *h2)
h1とh2をマージした木の根を返す\
以下の戦略で木をマージする　ただし、h1 < h2であるとする

h1が空であればh2を返す\
そうでなくて、h2が空であればh1を返す\
そうでなければ、h1.right = meld(h1.right, h2)として再帰的にマージ\
leftist propertyが満たされなければh1の左右の子を入れ替える

push,popはmeldを用いて次のように実装できる
- push: 単一ノードからなるヒープを作ってmeld
- pop: 根ノードを削除して左部分木と右部分木をmeld

### 計算量
meldは木を右へ降りていって空になったときに終了する\
よって右スパイン[^1]の長さが$\Omicron(\log N)$であることを示せば良い
[^1]: 空ノードまでの最も右の経路

leftist propertyより、右部分木のサイズは $\lfloor \frac{N-1}{2} \rfloor$ 以下である\
そうでないとき、右部分木のサイズが左部分木のサイズより大きいことになるためlefitst propertyを満たさない\
右へ降りていくとノード数が常に半分になっていくので、右スパインの長さは$\Omicron(\log N)$\
$\log|x| + \log|y| \le 2 \times \log N$ よりmeld(x, y)の計算量のは $\Omicron(\log |x|) + \Omicron(\log |y|) = \Omicron(\log N)$

### tips
- 実は木の高さは $\Omicron(\log N)$ ではない
    - $1, 2, ... ,N$ のようにデータを昇順に並べてpushしていくと木の高さが$\Theta(N)$ になる
- ノードが親へのリンクを持たず、最悪計算量がいい感じなので何も考えずにpath-copyingで永続化できる
    - [実装例](https://toyama1710.github.io/cpp_library/heap/persistent_leftist_heap.hpp)と[ドキュメント](https://blog.toyama1710.net/posts/2021/11/24/persistent_leftist_heap/)

