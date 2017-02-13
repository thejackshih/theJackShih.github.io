title: Virtual Function in C++
date: 2016-12-18 08:34:55
tags:
- c++
---
最近跟朋友談論到這樣的問題 「解構式應加上 virtual 關鍵字」
(TL;DR 如果預期會有人繼承這個物件，請在解構式加上 virtual)

上網查了一下發現挺有趣的所以在這裡記錄下來。

<!-- more -->

virtual 關鍵字代表的意思是向其他人暗示，這個 function(method)，"應該"要被子類別覆寫(override)。方式是用子類別也用一樣的 function 名稱。

也許這時候會有疑問，其實不加 virtual 也是可以的，C++ 有所謂 overload 機制。

例如我有一個 Class A 跟 Class B 且 B 繼承 A。
{% codeblock lang:cpp %}
class A {
  public:
    void sayHello() {
      cout<<"hello from A"<<endl;
    }
    void hey() {
      cout<<"hey from A"<<endl;
    }
};
class B: public A {
  public:
    void sayHello() {
      cout<<"hello from B"<<endl;
    }
};
{% endcodeblock %}

然後這樣呼叫

{% codeblock lang:cpp %}
A *a = new A();
B *b = new B();
a->sayHello(); // hello from A
b->sayHello(); // hello from B
b->hey(); // hey from A
{% endcodeblock %}

一切看起來都很正常，但是繼承體系下，要用子類別也是父類別的一種，也就是說可以用父類別指標指向子類別。

{% codeblock lang:cpp %}
A *ab = new B();
ab->sayHello() // hello from A
{% endcodeblock %}

有過 Java 經驗或許會直覺是 hello from B，畢竟不論被當成什麼東西，物件是什麼就該是什麼。這也是所謂的多型。
但這樣的情況下 C++ 會印出的是 hello from A.
如果想要印出 hello from B 就應該要在 function 前面加上 virtual 關鍵字。

由以上 C++ 的行為就衍生出所謂 virtual destructors
如果沒有 virtual 關鍵字，如果 B 物件是在被 A 指標指的情況下對 A 所指向的物件釋放，會變成以 A 解構式解構 B 物件，這樣下來會發生錯誤也不意外了。

事實上在 C++11 前 C++ 是沒有 final 關鍵字來阻止別人繼承物件的。所以 C++ 內有種程式設計師的默契，如果類別中的解構式沒有 virtual 關鍵字，會是在暗示您不應該繼承這個物件。

另外 C++ 中並沒有像 Java 有所謂 abstract 或是 interface 的關鍵字，而是 pure virtual function。

{% codeblock lang:cpp %}
virtual function foo() = 0;
{% endcodeblock %}

挺有趣。
