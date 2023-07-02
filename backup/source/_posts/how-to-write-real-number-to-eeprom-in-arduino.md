title: 如何在 Arduino 將 float, double 寫入 EEPROM 
date: 2017-11-09 15:59:19
tags:
- arduino
- c
---
最近被問到要如何將浮點數存到 EEPROM，由於 EEPROM 一次只能存 1 byte.
所以實際上的問題應該是說如何將 4 bytes(float) 或是 8 bytes(double) 的資料型態每次 1 byte 存進 EEPROM。
第一直覺當然是使用 bitshift operator 來做，畢竟要切 byte 最直覺的方式就是透過 bitshifting 來切。不過 c/c++ 並不能做 floating-point shifting。
上網查了一下發現可以用 c union 來做，實際上做了也發現這樣的做法直觀容易多了。
  
在 c 中 union 就像是 struct 一樣，只不過其中的所有成員都是使用同一塊記憶體區域。在特殊情況下這似乎符合這次的需求：「將 float 或 double 用 byte 方式呈現。」
```
union eDouble {
    double dValue;
    byte[8] bValue;
}
```
這樣設計將兩者對齊後就可以透過 eDouble.bValue[] 來一次存取一個 byte 了。  
  
挺有趣
