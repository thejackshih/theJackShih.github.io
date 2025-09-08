+++
title = "處理 emacs shell command 抓不到 nix-direnv 的問題"
author = ["Jack Shih"]
date = 2025-09-02T00:00:00+08:00
tags = ["nix", "home-manager", "emacs", "direnv", "zsh"]
draft = false
+++

通常使用 nix 來處理專案開發環境的時候，除了用 nix-shell 之外，通常會搭配 direnv + nix-direnv 來達到所謂「切進專案資料夾的時候自動切換開發環境」的功能。

在 emacs 中則是會再加上 `envrc` 跟 `exec-path-from-shell` 這兩個套件來輔助這件事情。

雖然在 eshell 或是 shell 中看起來都能正確切換環境，但是在 `M-x shell-command` 或是 `M-x async-shell-command` 執行 `printenv` 中的 PATH 一直是錯誤的。陸續看了 google search， envrc repo， nix-direnv repo 都沒看到有人提這個問題。所以只好自己來看看。


## TL;DR {#tl-dr}

問題發生在，雖然 envrc 會把環境變數帶入，但是在 zsh 執行的過程中會被 home-manager 的設定覆蓋。既然已經透過 `exec-path-from-shell` 中將全部環境變數帶入 emacs 環境中，就不需要重新執行整套的 zsh 設定，所以額外帶入 `__NIX_DARWIN_SET_ENVIRONMENT_DONE` 就可以跳過設定的步驟。另外的好處是在進 shell 的時候也不需要再度執行 direnv，速度快一點。


## 菜鳥 elisp debug {#菜鳥-elisp-debug}

說到 elisp 或是 emacs 的強項，就是整個環境都是動態的，也就是說基本上指令都可以直接 ref 到原始碼，也可以在環境中直接做修改。其中一個下斷點的方式就是直接在對應的地方呼叫 `(debug)` 在直接更新 function 這樣就行了，方便的地方還有可以定義「進入 function 點」或是「當指定變數被修改時」等等。

中斷後有幾個基本操作，就跟大部分的 debugger 差不多。

| 操作 | 說明                 |
|----|--------------------|
| c  | 相當於 resume        |
| d  | 相當於 step in       |
| b  | 相當於 step over     |
| e  | eval，相當於觀察變數或是可以直接修改 |


## emacs 中的 shell 及 shell-command {#emacs-中的-shell-及-shell-command}

回到根本變成是要了解 emacs 是怎麼操作 shell 的，這邊會遇到兩個相關的變數 `process-environment` 以及 `exec-path` ，前者決定由 emacs 啟動的 subprocess 的環境變數，後者則是相當於在 emacs 環境中的 `PATH` 。容易有疑問的地方會是 `process-environment` 中的 `PATH` 跟 `exec-path` 的區別。自己的理解會是 `exec-path` 決定 emacs 可以看到哪些 subprocess 可以被執行，而執行之後的環境變數則是由 `process-environment` 決定。基本上兩個地方的值應該要是相同的才是，但概念上是脫鉤的。

了解之後與其用 (debug) 慢慢走，不如直接用 `M-x debug-on-variable-change` 直接觀測 `process-environment` 及 `exec-path=。 在這個情境中看起來似乎是沒什麼問題。也額外測試如果我多塞了 =FOO` 這樣的變數能不能順利傳遞到 shell 中，看起來是可以，不過依然沒有反應在 PATH 上。


## bash 或 zsh 的順序 {#bash-或-zsh-的順序}

既然在進入 shell 前 `process-environment` 或是 `exec-path` 都沒什麼問題，那方向就變成：「是不是在 shell 啟動的途中 PATH 被修改了？」

從這個角度變成是要去了解 bash 或 zsh 的啟動順序，因為自己是用 zsh 所以就用 zsh 看。這邊有畫得不錯的圖可以參考 [stackoverflow](https://superuser.com/a/1840396) 。接下來就要知道是走哪個路線，就直接執行 emacs app 的方式的話， shell 是 Login Interctive， shell-command 則是 Login Non-interactive。

順著路線一路看到 `/etc/zshenv`

```shell
# /etc/zshenv: DO NOT EDIT -- this file has been generated automatically.
# This file is read for all shells.

# Only execute this file once per shell.
if [ -n "${__ETC_ZSHENV_SOURCED-}" ]; then return; fi
__ETC_ZSHENV_SOURCED=1

if [[ -o rcs ]]; then
  if [ -z "${__NIX_DARWIN_SET_ENVIRONMENT_DONE-}" ]; then
    . /nix/store/jmf87lwjf46mm4iiacrlag752mqmdj8r-set-environment
  fi

  # Tell zsh how to find installed completions
  for p in ${(z)NIX_PROFILES}; do
    fpath=($p/share/zsh/site-functions $p/share/zsh/$ZSH_VERSION/functions $p/share/zsh/vendor-completions $fpath)
  done


fi

# Read system-wide modifications.
if test -f /etc/zshenv.local; then
  source /etc/zshenv.local
fi
```

這段 `. /nix/store/jmf87lwjf46mm4iiacrlag752mqmdj8r-set-environment` 的內容終於看到一些覆蓋的動作。

知道位置之後就好下手了，由於檔案是由 nix 負責所以基本上改不動。不過看來是可以用 `__NIX_DARWIN_SET_ENVIRONMENT_DONE` 這個環境變數來做控制。接下來問題又回到像是這邊的情境 [How to fix nix "Problem with the SSL CA cert" on macOS]({{<relref "how-to-fix-problem-with-the-ssl-ca-cert-on-macos">}}) 。由於=exec-path-from-sehll= 只會匯入常見的變數，其他的要自己指定。這邊就直接額外加入這個變數就行。

```emacs-lisp
(use-package exec-path-from-shell
:ensure t
:config
(dolist (var '("LC_CTYPE" "NIX_PROFILES" "NIX_SSL_CERT_FILE" "__NIX_DARWIN_SET_ENVIRONMENT_DONE"))
  (add-to-list 'exec-path-from-shell-variables var))
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))
(when (daemonp)
  (exec-path-from-shell-initialize)))
```

測試一下，一切正常，也順便解惑了過去執行 emacs 的時候 brew 的 path 不見的問題。


## reference {#reference}

<https://superuser.com/questions/1840395/complete-overview-of-bash-and-zsh-startup-files-sourcing-order/1840396#1840396>
