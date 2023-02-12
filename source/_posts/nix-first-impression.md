title: nix 初探
date: 2023-01-22 21:58:57
tags:
  - nix
---

最近一直在關注 `nix`，在旁邊看了很長一段時間最後才決定嘗試看看，考慮的點在於已經很習慣用 `homebrew` 上的 `emacs-plus`，不過看到連 `emacs-plus` 的作者都有 `nix` 的設定了那就可以直接 go 了。這邊就簡單流水帳一下一些想法。

當初注意到 `nix` 主要是因為看上了可以自由切換環境這個特點。在現今開發環境如此複雜之下，同時安裝一堆執行環境像是 `python` `ruby` 或是 `nodejs`。而在這些工具更新速度很快的情況下，相繼而來的就是會需要類似 `pyenv` `rvm` 和 `nvm` 等的版本管理工具。接下來的發展之下又會產生所謂管理版本管理的工具如 `asdf`。以個人來說是覺得太麻煩了。

當初以一個 `package manager` 出身的 `nix` 來說，發展到了現在可以說是已經比原來還要複雜太多。目前來說可以說是個人環境上的 `terraform` 也不爲過。

既然跟 `terraform` 一樣，那其實也有跟 `terraform` 一樣得問題。跟 `terraform` 用 `HCL` 當作編輯的語言一樣， `nix` 也有自己的語言 `nix`，想當然爾也會遇到一樣的問題，身為 `DSL` 的 `nix` 不太可能跟完全的程式語言一樣，到後來的發展也朝著不斷擴充的方式來逼近一般程式語言，樣子也越來越奇怪。

也跟 `terraform` 一樣，多了一層抽象並不代表可以不去理解底層，也就是說對於不熟悉原來操作的人來說除了要學會底層在做什麼事情之外還要同時多學習如何用其他的方式表達，但資源上又是比原生的處理方式還要少了一層。甚至還要去了解哪些是這些抽象層的極限哪些不是。如同其他將底層抽象的工具一樣，如果是在設定的範圍內（或是網路上有其他人已經包好的套件）都還算是可以處理，但對於設定範圍外的處理就變得更麻煩。

`nix` 常被人詬病地方在上手門檻實在太高，有一部分的原因來自於網路上的文件跟教學實在太破碎，很多時候連參數有什麼都不知道，這點在剛接觸 `terraform` 的時候也苦過一陣子。不過 `nix` 的情況更為破碎。如果網路上一般看就會看到一堆不知道在做什麼的名詞如 `nix` `home-manager` `nix-darwin` `flake`。

會說與其看文件自己從頭來，不如直接去抄現成的還要來得快。

以下是一些參考資料

- https://xyno.space/post/nix-darwin-introduction
這篇講解了從 0 開始，針對一些基礎觀念跟專有名詞都有詳盡的解釋。

- https://github.com/d12frosted/environment
直接把大神的 config 抄起來，主要是看要怎麼在 `nix` 下控制 `homebrew`

目前用的還算痛苦，就看看接下來會不會苦盡甘來。

順帶一提，這篇就是用 `nix-shell` 的做法產生。

目前的進度放在 https://github.com/thejackshih/dotfiles 可以參考參考。