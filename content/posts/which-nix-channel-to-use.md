+++
title = "該用哪個 Nix Channel"
author = ["Jack Shih"]
date = 2024-07-17T00:00:00+08:00
tags = ["nix"]
draft = false
+++

在 nix 中，除了一般常見的 stable 跟 unstable 的 channel 之外，還會看到 unstable 還有分 `nixpkgs-unstable` 、 `nixos-unstable` 跟 `nixos-unstable-small` 。
而 stable 則是有 `nixos-24.05` 、 `nixos-24.05-small` 跟 `nixpkgs-24.05-darwin` 。
那這時候就會開始想到底這些 channel 到底差在哪裡，該用哪個？

ˋ簡單來說，可以想像每一個 nix channel 都是在不同時間點的 nixpkgs-master，只是測試的項目不太一樣。
例如 `nixos-*` 的測試項目就會多測試屬於 nixos 相關的項目，確保從這個 channel 出去的版本不會把 nixos 弄壞。

`*-small` 則是因為測試的項目較一般的少，所以更新的速度較快。

stable 的部分則是對應 nixos 而生，所以有區分 nixos 跟 darwin(macOS) 的不同。
大概是因為有 `nix-darwin` 所以要有個跟 `nixos` 來對應。比如說 `nixos` 不需要去考慮 macOS 相關 package 的東西。

知道這些之後，要用哪個 channel 大致可以做決定，因為不同 channel 就差在更新速度不同，所以要使用哪個 channel 就取決於更新要多快，以及東西壞掉的機率。
如果想要走 rolling release 的話就使用 unstable 相關的 channel。
雖然就上面敘述來說，如果想要是可以在 nixos 中使用 nixpkgs-unstable，不過因為沒有針對 nixos 的測試，所以系統可能會壞掉。
因此是不建議這麼做，nixos 就使用 nixos-\* 相關的 channel。

macOS 的部分，如果想要有像 nixos 差不多的體驗就走 `nixpkgs-*.*-darwin` ，如果沒有的話就直接用 `nixpkgs-unstable` 。

看了這麼多，可能會想到為什麼沒有 `nixpkgs-stable` 之類的版本，可能是因為一來 linux-based 就直接用 nixos 的 stable channel 就好。二來仔細想想，如果純粹把 nix 當作 package manager (naapm) 的話，穩定版好像沒有什麼意義。

如果是走 nix flake，那麼混搭也沒有這麼困難了，可以輕鬆做到「大部分的套件都用穩定版，但就這個我想要用最新版」 的情境。


## reference {#reference}

[https://gist.github.com/grahamc/c60578c6e6928043d29a427361634df6#which-channel-is-right-for-me](https://gist.github.com/grahamc/c60578c6e6928043d29a427361634df6#which-channel-is-right-for-me)
<https://status.nixos.org>
<https://discourse.nixos.org/t/differences-between-nix-channels/13998>
<https://discourse.nixos.org/t/difference-between-channels/579>
