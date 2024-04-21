+++
title = "如何 nix-darwin 環境下更新 nix 版本"
author = ["Jack Shih"]
date = 2024-04-21T00:00:00+08:00
tags = ["nix"]
draft = false
+++

## TL;DR {#tl-dr}

簡單說因為是用 `nix-darwin` 來管理，所以就算照著[官方文件](https://nixos.org/manual/nix/stable/installation/upgrading)做升級是會有問題的。 雖然沒用過 `nixos` ，不過我想在 `nixos` 上也有相同的問題。比較正確的做法是把在 `configuratino.nix` 中將 `nix.package` 指向對的版本，

```nix
# configuration.nix
nix = {
  pacakge = pkgs.nixVersions.nix_2_21; # 指定版本
  # skip
}
```


## 前言 {#前言}

在使用 `nix` 的情況下有個一直未解的問題，就是要如何升級 `nix` 版本，比如說安裝的時候是 `2.18.3` ，隔一陣子官網上說已經更新到 `2.21.1` ，不確定是因為太簡單還是怎麼樣，網路上完全找不到該怎麼做。


## 第一次嘗試：使用官方文件 {#第一次嘗試-使用官方文件}

如果就基本關鍵字查詢，大概會先看到的是官方文件，如果按照官方文件上面更新之後，會遇到的問題是用 `nix doctor` 時，他會跳個警告說現在有多個版本

```shell
[FAIL] Multiple versions of nix found in PATH:
/nix/store/{某版號}/bin
/nix/store/{另外版號}/bin
```

雖然放著好像還好，不過如果覺得很礙眼想要修正的話。就要知道為什麼會有兩個，會有兩個的原因通常是一個是系統用的，一個是使用者自己的。
檢查的方式是比較兩個指令：

```shell
nix-env --version
# 基本上如果已經用 nix-darwin 做管理，這個不該有東西。
```

```shell
sudo nix-env --version
# 這邊應該會出現某個版號的 nix
```

要修正的話，把系統用的移除就好了。不過基本上就是回到原點。

```shell
sudo nix-env -e nix
```

網路上多說多版本的狀況還行，因為 `nix` 會按照優先序來執行。不過如果拖很久的會遇到另外一個 portocol 的問題。

```shell
[FAIL] Warning: protocol version of this client does not match the store.
While this is not necessarily a problem it's recommended to keep the client in
sync with the daemon.

Client protocol: {某版號}
Store protocol: {另外一個版號}
```

原因是在 macOS 中， nix 是用 daemon 的方式執行，所以就算更新使用者的 nix，只要 daemon 的版本沒有更新，就可能會出現版本對不上的情形。 順帶一提，要看目前執行的 daemon 的版號的話指令是

```shell
nix store ping # 舊版
nix store info # 新版
```

另外是作者有提供大概這樣的 snippet，千萬別無腦亂套，一用下去連 nix 的 PATH 都不見了，費了好大的力氣才弄回來。

```nix
{
  environment.profiles = mkForce [];
}
```


## 第二種嘗試：透過 nix-darwin 在使用者安裝新版 nix {#第二種嘗試-透過-nix-darwin-在使用者安裝新版-nix}

對 `nix` 來說 `nix` 也是其中一個 package，在 [nixos 搜尋結果](https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=nix) 就可以看到有提供很多版本像 `nixVersions.nix_2_21` 這樣。所以在使用者加入總行了吧。

```nix
# configuration.nix
home-manager.users.jack = {pkgs, ...}: {
  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    nixVersions.nix_2_21 # 直接在使用者 package 中指定
    coreutils
    emacs-unstable-pgtk
  ];
  # skip
}
```

當然這作法跟結果第一種做法一樣，只是反過來而已。


## 第三種嘗試：透過 nix-darwin 在系統安裝新版 nix {#第三種嘗試-透過-nix-darwin-在系統安裝新版-nix}

既然 daemon 是由 nix-darwin 中透過 `service.nix-daemon.enable` 設定，那就在系統中安裝。

```nix
environment.systemPackages = with pkgs; [
  nixVersions.nix_2_21
];
```

這個的結果是會 package 在建立的過程中會衝突，因為我同時指定要在同一層使用不同版本的 nix。


## 第四種嘗試：自己控制版本 {#第四種嘗試-自己控制版本}

既然知道 `service.nix-daemon.enable` 是由 nix-darwin 來控制，那就自己來控制吧。把 `service.nix-daemon.enable` 改成 `false` 之後會失敗，因為 `nix-darwin` 會偵測到， macOS 只能用 daemon 來管理，關閉沒設定是會出事的。 如果要自己管理，那還要把 `nix.useDaemon` 打開。想當然一沒弄好當然是整個 daemon 就不見了。因為沒了 daemon 所以就整個卡死了。
解決的方式是自己起 `nix-daemon` ，這邊要注意的是要用 sudo 而且還要解除 macOS 對 fork 的限制。然後把系統還原。

```shell
sudo OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES nix-daemon
```


## 第五種嘗試：看 source code {#第五種嘗試-看-source-code}

在 [nix-darwin 文件](https://daiderd.com/nix-darwin/manual/index.html#opt-services.nix-daemon.enable) 有連結到 source code 連結。算是 nix 文件的好處跟壞處吧。好處是有 source code，壞處是因為有 source code 所以文件稀缺必須要看 source code。

其中有 [這一段](https://github.com/LnL7/nix-darwin/blob/9e7c20ffd056e406ddd0276ee9d89f09c5e5f4ed/modules/services/nix-daemon.nix#L49) 大概是去 launchd 中增加這一段，對照 `/Library/LaunchDaemons/org.nixos.nix-daemon.plist` 中的內容是差不多的。 這邊發現他是去抓 `config.nix.package` 對比就是抓 `nix.package` 指定的 package。

文件指出 `nix.package` 的預設值是 `pkgs.nix` ，這邊就改成指定的版本試試。原來這邊寫 `pkgs.nixFlakes` 應該是不知道從哪邊抄來的，現在也沒這個套件了。

```nix
# configuration.nix
nix = {
  pacakge = pkgs.nixVersions.nix_2_21; # 指定版本
  # skip
}
```

`darwin-rebuild` 的訊息看起來也很正確，重新建立了新的 launchd daemon。檢查一下看來是正確的


## 心得 {#心得}

光是升級就弄懷疑人生。nix 目前還沒有達到完全抽象的高度，導致要用除了要熟系統本身的基本架構之外還要在額外疊一層 nix 的抽象，更別提要在 nix 之上在加 nix-darwin(nixos) 和 home-manager。跟 homebrew 來說使用者友善度還有很長一段路要走。 而這段期間也開始有底層掛 nix 的開發環境工具慢慢出現。 像 [flox](https://flox.dev) 就是其中之一。某些層度上也算接近自己理想的介面。可以用比較傳統的方式把環境拉出來之後在儲存，而不用去寫 nix。

當然 nix 好處就是這篇文章使用的 hugo 依然是直接用 nix-shell 跑出來的，很方便。搭配 `direnv` 還可以達到進專案進出資料夾自動 load/unload。 完全不會污染整個系統。


## reference {#reference}

<https://discourse.nixos.org/t/fail-multiple-versions-of-nix-found-in-path/19890/5>
<https://github.com/LnL7/nix-darwin/issues/655#issuecomment-1551771624>
<https://daiderd.com/nix-darwin/manual/index.html>
