title: gogs 轉移 gitea - part3：gogs-git hooks
date: 2019-07-10 20:24:44
tags:
- gitea
- gogs
---
tl;dr: gogs 轉移 gitea 後記得清掉 git hooks.

在經過一次資料庫維護之後發現一部分的 repo 變得無法 push。出現了奇怪的錯誤訊息。
類似 `gogs failed, git pre-receive hook declined`之類的。

一開始以為是哪裡出錯，後來才發現明明是用 gitea 怎麼會出現 gogs 的錯誤訊息，不過又覺得 gitea 本來就是從 gogs fork 出來的所以也不疑有他。到後來才發現原來問題還是跟 gogs 有關。  

原來是 gogs 本身預設會建立很多 git hooks，那這些 script 是放在 .git 之中，所以過去在轉移的時候也跟個轉移過去了。由於伺服器環境並不乾淨，所以 script 還是可以將 gogs 跑起來做該做的事情。而在資料庫維護之後就無法執行了。也就是為什麼錯誤訊息會提到 gogs。

gitea 有預設的 git hooks ，所以去相對應的地方將 git hooks 移除就好了。
