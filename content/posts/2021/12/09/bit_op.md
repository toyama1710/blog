---
title: "bit演算シリーズ"
date: 2021-12-09T20:50:04+09:00
description: ""
draft: false
math: true
toc: true
categories: [競プロ]
tags: [ライブラリ]
---

[bit/clz.hpp](https://toyama1710.github.io/cpp_library/bit/clz.hpp),
[bit/ctz.hpp](https://toyama1710.github.io/cpp_library/bit/ctz.hpp),
[bit/msb.hpp](https://toyama1710.github.io/cpp_library/bit/msb.hpp),
[bit/lsb.hpp](https://toyama1710.github.io/cpp_library/bit/lsb.hpp),
[bit/pop_count.hpp](https://toyama1710.github.io/cpp_library/bit/pop_count.hpp)
のドキュメント

ビルトイン関数を使えば良いです速いし\
それらが使えない処理系のための実装を提供するのと、`__builtin_ctz(0);`などが未定義動作なので安全に使えるようにするのを目的に作ったライブラリ

## 外から呼ぶやつ

### int clz64(uint64_t)
64bit版のcount leading zero
最上位bitからいくつ0が連続してるか数える

#### sample
```cpp
assert(clz64(0) == 64);
assert(clz64(1) == 63);
assert(clz64(1ull << 63) == 0);
```

### int clz32(uint32_t)
clz64の32bit版

### int ctz64(uint64_t)
64bit版のcount trailing zero
最下位bitからいくつ0が連続してるか数える

#### sample
```cpp
assert(ctz64(0) == 64);
assert(ctz64(1) == 0);
assert(clz64(1ull << 63) == 63);
```

### int ctz32(uint32_t)
32bit版のctz64

### uint64_t msb64(uint64_t)
64bit符号なし整数からMSBを取り出す
一番左の立ってるbitの抽出

#### sample
```cpp
assert(msb64(0) == 0);
assert(msb64(1) == 1);
assert(msb64(0xf) == 0x8);
```

### uint32_t msb32(uint32_t)
32bit版のmsb64

### uint64_t lsb64(uint64_t)
64bit符号なし整数からMSBを取り出す
一番右の立ってるbitの抽出

#### sample
```cpp
assert(lsb64(0) == 0);
assert(lsb64(1) == 1);
assert(lsb64(6) == 2);
```

### uint32_t lsb32(uint32_t)
32bit版のlsb64

### int popcnt64(uint64_t)
64bit版のpop count　立ってるbitの数を返す

#### sample
```cpp
assert(popcnt64(0) == 0);
assert(popcnt64(1) == 1);
assert(popcnt64((1ull << 50) - 1) == 50);
```

### int popcnt32(uint32_t)
popcnt64の32bit版

## ビルトイン関数が使えないとき用の実装たち
本編

### int clz64_(uint64_t)
MSBを抽出する　0を除くとこれは64種類しかない(1が立ってるbitは1bitだけ)のでこれをうまく0~63に変換して表引きしてやればOK\
うまく変換のパートはDe Bruijin Sequenceを使うと乗算でできる

### int ctz64_(uint64_t)
LSBを抽出したらあとはclz64_と同じ

### uint64_t msb64_(uint64_t)
最下位bitからMSBまで1で埋まってるデータ(aとする)を作って `a ^ (a >> 1)` でMSBより下のbitを消去する方針

データを作るパートが本質で、これはMSBを始点に1で埋まってる幅を倍々にしていくと $\Theta(\log w)$ 回程度のbit演算で可能

### uint64_t lsb64_(uint64_t)
`bit & (~bit + 1)`\
2の補数表現を仮定すると `bit & -bit` とも書ける

### int popcnt64(uint64_t)
bit並列に数え上げる

偶数bitと奇数bitに分けて1bitずらして足すと、データを2bitずつ区切ったときそれぞれ1がいくつあるか数えられる\
次は2bitずらして足して 4bitずらして足して..... としていくと最終的に64bit中に1がいくつあるかわかる
