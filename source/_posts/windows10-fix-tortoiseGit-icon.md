title: Windows10 TortoiseGit icon未顯示問題
date: 2015-10-28 15:01:12
tags: windows
---
雖然使用Git最好的方式是使用Command-Line，而這也是自己在Unix-like環境下的做法。不過在Windows底下自己依然是比較習慣使用GUI介面。而TortoiseGit是目前用最順手的。
而這次在Windows10安裝完TortoiseGit後卻發現那方便的確認status的小icon消失了。實在是太不方便。上網找了解法後記在這裡，畢竟未來Windows還是無法避免要去用的。而Git對程式設計師來說又是如此重要。

＊能盡量用GUI就用GUI，算是個Windows腦袋
<!--more-->
1. 進入TortoiseGit 設定選單
2. 在Icon Overlay中的Overlay Handlers選擇"Start registry editor"
3. 將"ShellIconOverlayIdentifiers"中TortoiseGit相關檔案提升到最上層。
註：Windows10很賊，將Onedrive跟Skydrive前面補了一個空格所以永遠都在最上層。那我們也將TortoiseGit的檔案也補空白和0來確保這些檔案在最上層
4. 進入工作管理員把"windows檔案總管"和"TortoiseGit status cache"強制關閉
5. 重新啟動"windows檔案總管"和"TortoiseGit status cache" （個人是直接重新啟動電腦）
6. 小icon應該會出現了。 :)
