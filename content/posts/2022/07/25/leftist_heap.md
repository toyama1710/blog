---
title: "weight-biased Leftist Heap のC言語実装"
date: 2022-07-25T23:09:27+09:00
description: "課外プロジェクト用資料"
draft: false
math: true
toc: true
categories: [others]
tags: [ヒープ]
---

[問題](https://onlinejudge.u-aizu.ac.jp/problems/ALDS1_9_C)と[提出](https://onlinejudge.u-aizu.ac.jp/status/users/ei1710/submissions/1/ALDS1_9_C/judge/6836873/C)

## コード
```c
#include <stdio.h>
#include <stdlib.h> // malloc(), free() の使用のために必要
#include <string.h> // strcmp() の使用のために必要

#define swap(Type, A, B) \
{                   \
    Type __tmp = A; \
    A = B;          \
    B = __tmp;      \
}                   \

typedef struct Node_ {
    int data;
    int size;
    struct Node_ *lch, *rch; // Cでは構造体タグ名の前にstructを付けないと型名として無効
} Node;

int size(Node *u);
Node *single(int d);
Node *merge(Node *a, Node *b);
Node *insert(Node *h, int d);
Node *deleteMax(Node *h);
int findMax(Node *h);

int main() {
    Node *root = NULL;
    char s[8];

    while (1) {
        scanf("%s", s);

        if (strcmp(s, "insert") == 0) {
            int d;
            scanf("%d", &d);
            root = insert(root, d);
        }
        else if (strcmp(s, "extract") == 0) {
            int x = findMax(root);
            root = deleteMax(root);
            printf("%d\n", x);
        }
        else { // s == "end"
            break;
        }
    }
}

int size(Node *u) {
    if (u == NULL) return 0;
    else return u->size;
}

Node *single(int d) {
    Node *node = (Node *)malloc(sizeof(Node));
    node->data = d;
    node->size = 1;
    node->lch = NULL;
    node->rch = NULL;
    return node;
}

Node *merge(Node *a, Node *b) {
    if (a == NULL) return b;
    else if (b == NULL) return a;

    if (a->data < b->data) swap(Node *, a, b);

    a->rch = merge(a->rch, b);
    if (size(a->lch) < size(a->rch)) swap(Node *, a->lch, a->rch);
    a->size = size(a->lch) + size(a->rch) + 1;

    return a;
}

Node *insert(Node *h, int d) {
    Node *u = single(d);
    return merge(h, u);
}

Node *deleteMax(Node *h) {
    Node *l = h->lch;
    Node *r = h->rch;
    free(h);
    return merge(l, r);
}

int findMax(Node *h) {
    return h->data;
}
```

# 実装の解説

[データ構造の解説](https://blog.toyama1710.net/posts/2021/11/24/leftist_heap/#%E6%A7%8B%E9%80%A0)

## main関数内での木の扱い方
根へのポインタで木を管理する\
木へ何らかの操作を加えるたびに適宜更新する\
例えば、`deleteMax(root)` を呼び出した後、戻り値で `root` を更新している

## swap マクロ
```c
#define swap(Type, A, B) \
{                   \
    Type __tmp = A; \
    A = B;          \
    B = __tmp;      \
}                   \
```

```swap(型名, 変数1, 変数2)``` の形で使用する\
```swap(int, a, b)``` のように書くと、以下のように展開される
```c
{
    int __tmp = a;
    a = b;
    b = __tmp;
}
```

## size()
ノードへのポインタを受け取り、これを根とする部分木のサイズ(=ノード数)を返す\
ヌルポインタが渡されたときは 0 を返す\
メンバ変数 size にアクセスする際にいちいちヌルチェックを挟むのが面倒なので関数に切り出した

## single()
ノード1つだけからなる木を作り、根へのポインタを返す

## merge(Node *a, Node *b)
```c
if (a->data < b->data) swap(Node *, a, b);
```
と書いてこれ以降は a->data $\ge$ b->data が常に成り立つようにしている\
b->data > a->data の場合を考慮しなくてよいので実装が簡潔になる

## insert(Node *h, int d)
h を根とする木にデータ d を追加する関数\
ノード1つだけの木を作ったあと merge() を呼び出せばよい

## deleteMax()
```c
Node *deleteMax(Node *h) {
    Node *l = h->lch;
    Node *r = h->rch;
    free(h);
    return merge(l, r);
}
```

h を根とする木から最大値を取り除いた木の根を返す\
ヒープでは根が最大値を持っている[^1]ので根を除いた木を作りたい\
これは根の左右の子をmerge()で1つにまとめてしまえば良い
[^1]: ヒープ条件(heapify)の不等号を逆にして最小値を持つように定義する場合もある

`free(h)` した後はhが指すメモリ領域へのアクセスが許されないので `h->lch` や `h-rch` にアクセスできないことに注意
