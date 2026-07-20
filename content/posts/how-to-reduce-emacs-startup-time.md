+++
title = "透過最佳化 use-package 來提升 emacs 啟動速度"
author = ["Jack Shih"]
date = 2026-07-20T00:00:00+08:00
draft = false
+++

在 emacs 跟其他編輯器的比較時，最明顯的缺點大概就是啟動速度比較慢這一點了。儘管大神們都會說對於 emacs 來說啟動時間並不重要，這個是基於比起其他編輯器在編輯不同檔案時常會開開關關(編輯檔案開啟，編輯完成後關閉)， emacs 的工作習慣是一但打開基本上除了電腦關機或是 emacs 當機外大概就不會關了，如果真的想要走開開關關的模式則是建議以背景服務(daemon)的方式開啟，用輕量的客戶端(emacsclient)連線，這樣也能達到瞬間開啟的效果。如果開機只做一次的話，啟動時間長一點似乎影響就沒這個大。

雖然是這樣說，但盡可能提升速度一直一來都不是壞事，而且最近還是感覺到啟動還是慢了一點。用 `M-x emacs-init-time` 確認了一下大概4秒左右。這邊就記錄一下，大致上就是參考一下大神的建議加上一點自己筆記。

在 emacs 中使用套件最方便的就是透過 use-pacakge 這個套件來安裝跟設定。不過啟動速度會很慢的原因大多是因為在使用 use-package 時沒注意導致在啟動的時候有意或無意間載入大量自己還用不到的套件。而載入套件的基本原則不外乎就是只有在真的要用的時候才載入，而當載入的套件變少的時候速度自然會提升。


## 如何測速 {#如何測速}

除了上面所用的 `M-x emacs-init-time` 之外 use-package 本身也有提供效能檢測資訊

```emacs-lisp
;; 在設定檔加入這行，之後用 M-x use-package-report 看結果
(setq use-package-compute-statistics t)
```


## 什麼是 use-package {#什麼是-use-package}

use-package 透過巨集的方式讓我們可以直覺統一的方式來安裝設定套件，而且提供許多 :keyword 還設定，文件 (`C-h f use-package`) 上有十分詳細的介紹，這邊就幾個常用的來介紹。


## :init 及 :config {#init-及-config}

最常見的是 `:init` 跟 `:config` 一個是載入前執行另一個是載入後執行。第一次看到 `:init` 的說明的時候有一個疑問，「什麼是載入前？而 emacs 要怎麼在還沒載入的時候就知道有關於套件指令與一些設定參數。」前者簡單說就是在執行 `(use-package)` 的時候就直接執行， 後者就要提到所謂的 `autoload`


## autoload {#autoload}

autoload 可以理解成 c/c++ 的標頭檔，只定義函數而不提供實作。在 autoload 中就包含有這個函數名稱以及在實作在哪裡等等的資訊。而這個檔案會在 package 建置(自動或是手動)的時候透過 `(generate-file-autoloads)` 依據套件作者設定的 `;;;###autoload` Cookie (像 C# 中的 Attribute) 產生 ，檔名是 `xxx-autoload.el` 。 emacs 在讀取套件時會看自動看這個檔案所以能在完整載入前就知道有哪些東西。進階一點也可以直接透過 `(autoload)` 來告知 emacs ，其實 `xxx-autoload.el` 裡面也就是一堆程式產生的 `(autoload)` 而已。


## :defer 及 :demand {#defer-及-demand}

如果什麼都不指定，在讀取 `init.el` 中的 `(use-package)` 時就會依照 `:init -> 載入 package -> :config` 的順序執行。這邊 `use-package` 提供了 `:defer` 這個 keyword 來讓使用者指定是否要延遲載入。
如果想要延遲載入又不想要寫一堆 defer 的話有兩種做法

1.  `use-package` 有提供 `use-package-always-defer` 來指定預設行為，這種情況就可以搭配 `:demand` 來告訴 `use-package` 來說這個要自動載入
2.  透過隱含 `:defer` 的 keyword 來精簡寫法


## 隱含的 :defer {#隱含的-defer}

有些 keyword 像是 `:mode` (透過指定檔名啟動)  `:hook` (透過 hook 觸發)  `:commands` (透過指令觸發) `:bind` (透過快捷鍵觸發) 同時就包含了 `:defer` ，仔細想想也不難理解，既然說是要透過某種形式觸發，那也就代表不希望自動載入。背後原理其實也是 autoload，這些 keyword 也只是讓設定方便，如果想要也是可以在 `:init` 中寫對應的設定。


## 簡單的例子 {#簡單的例子}

大概知道後就可以開始調整。我的問題基本上大多都是因為沒有特別指定 `:defer` 而導致自動載入。例如最近很厲害的套用 ghostty 後端的 `ghostel`

```emacs-lisp
(use-package ghostel)
```

我需要在啟動的時候自動載入嗎？大概不需要，所以做以下調整就可以。

```emacs-lisp
;; 這是一種寫法
(use-package ghostel
  :defer t)
;; 這是用 commands (隱含 defer)的寫法
(use-package ghostel
  :commands ghostel)
```

可能會有疑問是 `(ghostel)` 本身就是已經是 autoload，那 commands 的做法是不是顯得多餘？答案是這樣沒錯，不過在語意上可能比較完整，而 `:defer` 某種程度上像是真的找不到切入點的時候的做法。理想上應該都要透過隱含的方式來做。老實說這點也還是見仁見智，所以挑喜歡的方式就好。

另外要注意的會是這種情形

```emacs-lisp
(use-package vertico
  :init
  (vertico-mode))
```

這種情形無論有沒有 `:defer` 都會被自動載入。所以要注意是不是真的希望要直接載入。


## 結語 {#結語}

剩下的問題就是一個一個 package 拿出來問問自己是不是要一開始就載入，如果不是的話又是要在什麼時候載入。簡單的調整之後把啟動時間從原來的 4 秒變成現在的 1.2 秒 (什麼都不載是 0.8 秒) 還算不錯。
