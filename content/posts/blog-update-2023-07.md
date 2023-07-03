+++
title = "202307 部落格更新                                                    :misc:hexo:hugo:org-mode:"
author = ["Jack Shih"]
date = 2023-07-03T00:00:00+08:00
draft = false
+++

近期以來有個目標是希望可以將事情盡量都在 emacs 中執行。將原來部落格寫作的方式搬進 org mode 可以說是其中一步。雖然按照現況使用 markdown 也沒什麼問題，不過也趁著這個機會來試看看 emacs 的 killer feature。

既然要改用 org mode 來管理部落格，就順勢把現在在用的 `hexo` 轉成可以支援 org 的 `hugo` ，過去雖然幾度想轉移。不過最後都因為懶惰而作罷。

雖然 hugo 已經原生支援 org， 不過在部落格系統部分，以 org mode 來說又分成兩派，一派是跟 markdown 一樣一篇一個檔案，另外一派則是使用一個 org 檔案來管理全部部落格的文章。這邊是想要嘗試看看用單檔管理全部文章的機制。不過在匯出的部分會需要另外處理。好在這邊有個套件 ox-hugo 可以來幫忙做這件事情。這也算是決定轉 hugo 的其中一個原因。

就這樣終於下定決心要花一點時間將部落格從 markdown 轉到 org 上。 然後把原本一直在用的 hexo 轉移到 hugo。接下來應該會慢慢將舊的文章轉移到 org 中。 搬進 org 之後希望是能降低寫部落格的阻力，幫助未來能有多一點的產出。

轉移到 hugo 的過程中也照著教學套了一下新的 github action，算是額外的收穫吧。不過比起讓 github action 跑，我個人是比較喜歡舊的透過 hexo deploy 直接從本機產生靜態文件並推到 github 上，單純許多。

-   [How I blog: One year of posts in a single org file](https://endlessparentheses.com/how-i-blog-one-year-of-posts-in-a-single-org-file.html) 如果想知道單一檔案的好處這邊有提到一點
-   [Why ox-hugo?](https://ox-hugo.scripter.co/doc/why-ox-hugo/) 使用 ox-hugo 的好處官網自己有解釋一番

\*
