title: 用 git 與 github 帳號連結
date: 2016-01-13 10:06:51
tags:
---
最近在github上查看Commit歷史紀錄時發現這個。
{% asset_img not-link.png github帳號未連結 %}
我預期應該要長這個樣子
{% asset_img link.png github帳號連結 %}
<!--more-->
原本以為在push到github時輸入帳號密碼就會紀錄是誰push的。不過上網Google了一下才發現原來是github會依照commit的email來連結帳號。

沒發現是因為過去都會安裝[github-desktop][github-desktop]，在github-desktop登入後程式就會自動設定好了，而這次因為沒有安裝所以就沒有設定。在未設定email的情況下git會產生一個local的email。所以github對應不到就直接拿commit username來當基準了。

解決的方式要在本機將github上註冊的email建立起來，github網頁上上是這樣寫
{% codeblock %}
$ git config --global user.email "your_email@example.com"
{% endcodeblock %}
設定完後可以這樣檢查

{% codeblock %}
$ git config --global user.email
{% endcodeblock %}
出現設定的email就成功了。

這樣是設定全域的email，也可以針對不同的git資料夾建立個別的email，在該資料夾中把指令的--global移除即可。

為什麼設定email很重要呢？如果有參與其他開源專案的話，沒有與github帳號連結是不會在歷史紀錄中顯示出來的。無法在其他專案中留下足跡還是有點難過的啊。

# Reference:
[Setting your email in Git][setting_email_in_git]

[github-desktop]: https://desktop.github.com/
[setting_email_in_git]: https://help.github.com/articles/setting-your-email-in-git/
