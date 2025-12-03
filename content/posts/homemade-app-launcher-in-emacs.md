+++
title = "在 Emacs 土炮 app launcher"
author = ["Jack Shih"]
date = 2025-12-03T00:00:00+08:00
tags = ["emacs"]
draft = false
+++

emacs 一直以來有個很大的賣點就是它是一個可以完全客製化的編輯器。用 emacs 也有一段時間了感覺沒有寫點自己的小功能有點可惜。這次心血來潮就來土炮一個 app launcher 看能不能取代一下 spotlight 或 raycast （當然 spotlight 跟 raycast 有更多功能，不過最常用的還是當作 app launcher），順便當作練習。

這個功能算是網路上很多人都做過，所以應該沒有太大的問題。基本上只要能用 shell 做到的事情，emacs 都有辦法接，所以只要確認在 macos 底下能用 `open` 指令開啟程式之後剩下的就是看文件湊功能了。

實作細節也很單純，建立一個只有 minibuffer 的 child-frame，然後把相關資料夾內的 app 列出來選，選好之後就使用 `open` 指令來開啟。

```emacs-lisp
(defun my-launch-app ()
"start application"
(interactive)
(progn
  (make-frame `((parent-frame . ,(selected-frame))
                  (undecorated . t)
                  (minibuffer . only)
                  (left . ,(/ (- (frame-pixel-width (selected-frame)) (* 40 (frame-char-width))) 2))
                  (top . 0)))
  (unwind-protect
        (let* ((apps (append
                      (directory-files "/Applications" nil ".app")
                      (directory-files "~/Applications" nil ".app")
                      (directory-files "/system/Applications" nil ".app")
                      (directory-files "/system/Applications/Utilities" nil ".app")))
               (apps-no-dot (mapcar (lambda (x) (string-replace ".app" "" x)) apps))
               (vertico-count 30)
               (resize-mini-frames t)
               (max-mini-windows-height 0.8)
               (window-min-width 40)
               (user-choice (completing-read "Select a app:" apps-no-dot nil t)))
          (with-environment-variables (("__NIX_DARWIN_SET_ENVIRONMENT_DONE" ""))
            (start-process "launcher" nil "open" "-a" user-choice)))
    (delete-frame)
    )))
```

接下來就設定個快捷鍵就好了。

```emacs-lisp
(global-set-key (kbd "M-s-<SPC>") 'my-launch-app)
```

這邊有個小插曲，之前在 [處理 emacs shell command 抓不到 nix-direnv 的問題]({{<relref "fix-shell-command-path-in-emacs-with-nix-Hdirenv">}}) 的處理導致用這個方式啟動的 Termianl.app 會跳過設定環境變數的步驟。在測試了老半天之後才發現原來 Terminal.app 會吃 `start-process` 所代入 `process-environment` ，滿意外的是因為其他的 Termianl emulator 像是 Ghostty 都不會這樣。原本以為要土炮修改 `process-environment` ，後來發現 emacs 有提供 `with-environment-variables` 這個功能可以簡單處理。

雖然很 hacky 也有些小問題，不過是自己做給自己用的所以用起來還算順手。
