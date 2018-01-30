title: struct vs class in csharp
date: 2018-01-30 16:39:35
tags:
- c++
- c#
---
前陣子因為個人主張`用 class 取代 struct`而討論到 csharp 中 struct 跟 class 有什麼不同。 
```csharp
struct foo
{
    public int id;
    public string value;
}
```
跟 
```csharp
class foo
{
    public int id;
    public string value;
}
```
有什麼不同。 
個人因為覺得都一樣所以傾向用 class，不過上網查之後才發現在 csharp 中跟傳統 cpp 不太一樣。 

先簡單說在 cpp 中 struct 跟 class 是同一件事，差別在 
1. struct 只能用 public ， class 預設 private 不過可以用 tag 設定為 public。 
2. class 可以含有方法， struct 只能有成員。 
3. class 可以繼承， struct 不行。 

事實上在 cpp 中還是有一部分的人完全不會用到 class。 
不過在 csharp 中[微軟的官方文件][1]就指出兩者的不同並提出兩者建議的使用時機。 
最大的差異在於 struct 是 value type，而 class 是 reference type。 
有相關概念的人應該這樣就會知道兩者個差異，不過對自己來說這樣還是太過於抽象。先把那些 struct 是在 stack 中而 class 是在 heap 中放一邊。看些簡單的例子。 
```csharp
struct structTest
{
    public int value;
}
class classTest
{
    public int value;
}
class Program
{
    static void Main(string[] args) 
    {
        structTest iAmStruct = new structTest
        {
            value = 1234;
        }
        classTest iAmClass = new classTest
        {
            value = 5678;
        }
        // iAmStruct.value = 1234, iAmClass.value = 5678

        // 指定到另外一個變數
        structTest iAmAnotherStruct = iAmStruct;
        classTest iAmAnotherClass = iAmClass;

        // 改一下數值
        iAmAnotherStruct.value = 0;
        iAmAnotherClass.value = 0;

        // iAmStruct.value = 1234, iAmClass.value = 0
    }
}
```

同理可以推廣到 function 

``` csharp
public void changeStructTestValueToZero(structTest input)
{
    input.value = 0; // 不會改到外部的值
}
public void changeClassTestValueToZero(classTest input)
{
    input.value = 0; // 會改到外部的值 
}
```

這就是過去在學習 cpp 中都會學到 pass by value 跟 pass by reference 的差異，而兩者行為上差異就是在這裡。
其他的語言可能會稱為 immutable 之類的，不過只要想一下是這是 value 還是 pointer 應該就知道了。

知道這個小知識就可以避免掉一些不如預期的的狀況，這次又有更深的了解了，挺不錯。
[1]: https://docs.microsoft.com/en-us/dotnet/standard/design-guidelines/choosing-between-class-and-struct
