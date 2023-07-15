+++
title = "修正 macos emacs term 顯示 unicode 錯誤問題"
author = ["Jack Shih"]
date = 2023-05-24T07:30:00+08:00
tags = ["terminal", "emacs", "nix", "linux"]
draft = false
+++

最近遇到的一個奇怪的問題

在 emacs 中無論是透過 eshell 或 ansi-term 在呼叫 nix --help 時，都會有顯示 &lt;C2&gt;&lt;B7&gt; (這是 unicode 的 middle dot) 的狀況。以為是 eshell 或 ansi-term 的問題，畢竟 emacs 對於 shell 或是 terminal emulator 的支援並不完美，一直以來都這樣認為。直到最近有點看不下去就想說來瞭解看看是哪裡有問題。

{{< figure src="/images/emacs-render-incorrect.png" >}}

第一個直覺比較像是可能跟版本有關係，由於自己本身是使用 homebrew 安裝的 emacs-plus，就想說是不是裝其他編譯的版本看看是不是能解決。於是用 nix shell 安裝了 nix 上直接從 git head 編譯出來的版本。跑起來發現似乎沒有問題。於是很開心的想說試試看。結果從 emacs.app 中開啟就又有一樣的問題。

這樣一來就開始交叉測試，發現原來的 emacs-plus 只要從 terminal 中啟動就能正常顯示。而透過 emacs.app 開啟就會有顯示問題。這就怪了，不過 emacs.app 雖然對 macos 來說是應用程式，其實他只是個資料夾。下個測試就是從 terminal 中直接打開 emacs.app 中的 emacs，結果是沒有問題。 有這麼神奇從 terminal 中啟動沒問題但是從 emacs.app 中打開就有問題。於是開始交叉比較用 emacs.app 跟 emacs 啟動的設定有沒有不同。

在 emacs wiki 中有一小節 `Encoding for Terminal.app on OS X` 不過照著做並沒有解決問題。而 emacs 有提供 `describe-coding-system` ，兩邊都是 utf-8。

難道是 emacs.app 就沒辦法正確顯示 middle dot 嗎？於是直接從正常顯示的 emacs 直接複製字元然後貼到不正常顯示的 emacs.app 中，結果是 emacs.app 可以正常顯示 middle dot。不過這樣就更奇怪了。

查到最後偶然看到有人透過修改 `LC_ALL` 來修正顯示問題。於是就用 `locale` 來確認看看。果不其然兩邊的結果不太一樣。 terminal 中的 `LC_CTYPE` 是 `UTF-8` 而 emacs.app 中則是 `C` 。在 emacs.app 的 ansi-term 中執行 `export LC_CTYPE="UTF-8"` 修改變數後就正常了。

{{< figure src="/images/emacs-render-correct.png" >}}

知道問題在哪裡之後就好處理了。
首先在 `.zshrc` 中加入

```shell
export CTYPE=en_US.UTF-8
```

接下來透過 `exec-path-from-shell` 把 `LC_CTYPE` 環境變數餵進去，package 本身有提供 `exec-path-from-shell-variables` 來匯入，這邊主要是要解決 eshell 的情況。 因為 eshell 不是 zsh，所以要另外處理。下面是一種範例。

```emacs-lisp
(use-package exec-path-from-shell
  :ensure t
  :config
  (dolist (var '("LC_CTYPE"))
    (add-to-list 'exec-path-from-shell-variables var))
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))
```

看來是太久沒有用 linux 了，也許網路上資料很少是因為 LC 通常在 linux 都會設定。

至於 terminal.app 就算 `.zshrc` 沒有設定也吃得到的原因則是在 terminal.app 有個 `Set locale environment variables on startup` 是打勾的。
