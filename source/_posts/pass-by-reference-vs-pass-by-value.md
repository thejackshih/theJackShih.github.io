title: pass-by-reference-vs-pass-by-value
date: 2018-02-01 13:40:19
tags:
- javascript
- c#
- programming language
---
在討論完 struct vs class 之後遇到了這樣的問題。

```javascript
function clearArray(input) {
    input = [];
}

var someArray = [1, 2, 3, 4];

clearArray(someArray);

console.log(someArray); // [1, 2, 3, 4]
```
也許會覺得 array 不是 pass by reference 嗎？為什麼不會改到外部的值？
事實上在例子中的 `input = []` 時 已經將 input 所指向的記憶體位置所轉換，而並非 someArray 所指向的位置。所以發生不如預期的狀況。

在 c# 中也會有一樣的狀況

```csharp
public void clearClassValue(someClass input)
{
    input = new someClass();
}

public static void main()
{
    var input = new someClass();
    input.value = 1;
    clearClassValue(input);
    Console.WriteLine(input.value); // 1
}
```
不過在 c# 中可以再加上 `ref` 關鍵字來取得儲存位置的位置。JavaScript 中倒是不知道有沒有這種功能。

過去學習記憶體和記憶體位置這類底層的東西這時候就可以派上用場了。

之後查了一下發現網路上解釋得更好的文章，有興趣可以看看。[連結][1]

[1]: https://medium.com/@TK_CodeBear/javascript-arrays-pass-by-value-and-thinking-about-memory-fffb7b0bf43
