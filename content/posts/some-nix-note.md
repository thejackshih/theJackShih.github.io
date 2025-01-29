+++
title = "nix 的一點筆記"
author = ["Jack Shih"]
date = 2025-01-29T00:00:00+08:00
tags = ["nix"]
draft = false
+++

年假期間想說來整理一下以前寫的 nix-darwin 的設定。然後想說這次不要用 nix flake，但是也還是不想用 channel。沒想到一改下去就開始折騰。親身體會為何 flake 的接受度為什麼會很高。當慢慢開始偏離預設的路徑得時候就痛苦。於是乎就回去看了 nix language。這邊就簡單記錄一下這次學習到的一點心得，希望有緣人不要走這個冤望路。


## .nix 檔案只放一個 nix-expression {#dot-nix-檔案只放一個-nix-expression}

沒錯，一個檔案只是一個 expression，可以想像就是一個 one-liner 的概念。對這次我來說可以說是很重要的啟發，畢竟會想要在 .nix 裡面做很多事情，的確可以，只要你有辦法寫成 one-line 就可以。


## everything is attribute set {#everything-is-attribute-set}

有點誇大，不過 attribute set 在 nix 中是很重要的東西，attribute set 可當作像 python 的 dict 或是 js 的 object，只是在語法上常跟其他語言搞混。

```nix
{}:{}
```

這是一個 function，參數是一個 attribute set ，回傳一個 attribute set。後面的 `{}` 並不是 code block。

至於兩個參數的 function 是這樣 `x:y:{}` ，是 curry 式的寫法。

早點了解相關語法跟縮寫會輕鬆很多，行走江湖會看到各種混用。表面上會看起來很複雜，其實不然。例如

```nix
{
  a = {
    b = c;
  }
}
```

```nix
{
  a.b = c;
}
```

這兩個是一樣的。


## nix repl 是好朋友 {#nix-repl-是好朋友}

以前沒有使用 repl 的習慣，雖然現在也是還沒習慣（個人還是覺得體驗不是很好），但對於這種一定要跑一遍才知道內容的語言來說。還是得用。


## nix path 是獨立的 type {#nix-path-是獨立的-type}

對於 nix 來說 path 是獨立的型別。也就是說 path 跟 string path 是完全不同的東西，也不相容。轉換的方式是用 `/. + "/path"` 或 `./. + "/path"` 這種寫法。(path + string = path)


## nix 的生態系 {#nix-的生態系}

nix 語言本身並不複雜。困難的是了解生態系的 convention。這次過程中常在問自己一個問題：「寫成這樣怎麼知道能不能動」。結果答案大概就是：「對，你不知道。」官方文件上大概就是這個意思。除非你看原始碼，不然你不太會知道任何一個 function 到底是要餵怎麼樣的東西。這時候就只能靠 convention 了。這點越早知道越不會覺得很混亂。因為就是這樣。越早接受越不會作無謂的掙扎。


## resource {#resource}

我不確定跟過去有差，但這次看的確是文件好了許多。

-   [nix.dev tutorials](https://nix.dev/tutorials/#tutorials)

    我覺得這個教學比看操作手冊容易多了。如果如果不知道 nix 能做些什麼。可以從 `First steps` 開始看。這邊會帶你走過幾個常見的情境。如果決定要開始用了，建議先把 `Nix language basics` 章節讀過一遍，章節會帶你走過大部分的語法，並且有實際的範例。一開始大概讀到這邊就好了。與其到處 google 不如先了解基本語法到底在做什麼。


## 結語 {#結語}

有了這些知識之後，快速把這個部落格用的 flake 改成傳統 nix 的寫法。不過在跑 hugo 的時候發現 hugo 已經更新到 `v0.141.0` 然後跳了一堆錯誤訊息。要是用 flake 就不會有這些問題。但沒關係，看個一下 flake.lock 的 hash commit，速速把 nixpkgs pin 在同樣的版本，然後就可以弄到當年的版本 (`v0.120.4`)。再次執行，一切正常，順便驗證了 reproducibility 的重要性，文章先出，之後有時間再來搞升級。
