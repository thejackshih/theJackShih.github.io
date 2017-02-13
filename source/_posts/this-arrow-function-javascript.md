title: Javascript 的 Arrow function.
date: 2017-01-22 15:45:47
tags:
- javascript
---
最近聽強者談論到在JS ES6 中使用 Arrow Function 要注意的事情，這事情跟 this 有關，趁這個機會對 this 做點了解。

<!-- more -->

先來一張從 Crockford 大神演講中偷來的表

|Invocation form|this|
|---|---|
|function| the global object or undefined*|
|method| the object|
|constructor| the new object|
|apply|argument|

知道 this 跟其他物件導向式的語言不同，會依照呼叫形式不同而有所不同之後大概就已經理解一半了。

其中要注意的是第一個 function 類型，使用 function 形式使用的時候 this 會指向 global object (non-strict) 或是 undefined (strict)

以 MDN 文件中的使用的範例為例

{% codeblock lang:js %}
function Person() {
  // The Person() constructor defines `this` as an instance of itself.
  this.age = 0;

  setInterval(function growUp() {
    // In non-strict mode, the growUp() function defines `this`
    // as the global object, which is different from the `this`
    // defined by the Person() constructor.
    this.age++;
  }, 1000);
}
var p = new Person();
{% endcodeblock %}

直覺看上， growUp 中所指的 this 看起來像跟外層 this.age = 0 的 this 是一樣的，但實際上會依照表中的規則 this 會是 global or undefined。

之後的解法或是一種 coding 習慣會是使用另外一個變數 that 來表示 this ，以確保 this 不會在可能沒注意到地方的被改掉。

{% codeblock lang:js %}
function Person() {
  var that = this;
  that.age = 0;

  setInterval(function growUp() {
    // The callback refers to the `that` variable of which
    // the value is the expected object.
    that.age++;
  }, 1000);
}
{% endcodeblock %}

而後還有 funcion.bind(obj) 這種方式來解決這種可能會發生的問題。

而 Arrow function 跟一般 function 不同地方在於他沒有 this。

{% codeblock lang:js %}
function Person(){
  this.age = 0;

  setInterval(() => {
    this.age++; // |this| properly refers to the person object
  }, 1000);
}

var p = new Person();
{% endcodeblock %}

以上的例子中由於 Arrow function 中沒有自己的 this，所以 this 依照 function scope 規則會是 this.age = 0 的 this。

看來沒把 JS 大全看完很難說自己能用得好啊。

# Reference:
[Arrow function](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Functions/Arrow_functions)
[Crockford on JavaScript - Act III: Function the Ultimate](https://www.youtube.com/watch?v=ya4UHuXNygM&list=PL7664379246A246CB&index=3)
