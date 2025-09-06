+++
title = "處理 emacs 讀不到主題的問題"
author = ["Jack Shih"]
date = 2025-09-06T00:00:00+08:00
tags = ["emacs"]
draft = false
+++

一般來說如果在 emacs 套用主題都會直接使用內建的套件管理器直接從社群維護的資源庫 mepla 下載。不過如果是比較新的主題或是有熱心人士從其他平台移植的主題，多數情況會是以檔案的方式分享，而且完整度可能就不會這麼高。有時候就會遇到跑不起來的問題，而錯誤訊息只有「讀取失敗」，甚至會是沒有錯誤訊息但在 \`M-x load-theme \`就是沒出現選項這樣，這邊記錄一下簡單的障礙排除。

首先先用 \`describe-variable (C-h v)\` 確認 \`load-path\` 跟 \`custom-theme-load-path\`
是不是都有該主題的位置。

如果沒有的話，就變成需要手動讀取

```emacs-lisp
(load-file "{file_path}")
(add-to-list 'custom-theme-laod-path "{file_path}")
```

再來看看原始碼，這邊參考一下 emacs 的說明手冊

> A Custom theme file should be named foo-theme.el, where foo is the theme name. The first Lisp form in the file should be a call to deftheme, and the last form should be a call to provide-theme.

幾個要點

-   檔案名稱的結尾必須是 \`-theme\`
-   從 deftheme 開始，以 provide-theme 結束，有些人會用 \`autothemer\` 的 \`autothemer-deftheme\`，這邊就要額外安裝 \`autothemer\`
-   注意一下有沒有 autoload

<!--listend-->

```emacs-lisp
;;;###autoload
(and load-file-name
     (boundp 'custom-theme-load-path)
     (add-to-list 'custom-theme-load-path
                  (file-name-as-directory
                   (file-name-directory load-file-name))))
```

要是沒有 autoload 這一段的話，就變成要用上面的方法手動讀取。

如果不想要手動讀取的話，是可以直接把上面的程式碼直接加進去就好了。
