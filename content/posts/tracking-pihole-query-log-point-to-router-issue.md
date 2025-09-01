+++
title = "查 pihole query log 都指向路由器的問題"
author = ["Jack Shih"]
date = 2025-09-01T00:00:00+08:00
tags = ["pihole"]
draft = false
+++

近期整理完 pihole 環境之後發現 query log 的裝置全部都變成路由器的 ip，於是開始查是哪邊設定有問題，這邊做個簡單的紀錄。

首先是先確認路由器的設定，這邊看起來都沒什麼問題。無論是 ipv4 或是 ipv6 的 dns 都有指向 pihole。因為配置上是由 pihole 擔任 DHCP 的功能，所以這邊也確認路由器中的 DHCP 是關閉的。

路由器看起來沒問題之後就是看電腦在連線後拿到什麼樣的設定。這邊讓人意外的是，ipv4 的 dns 雖然是正確的。但是 ipv6 的位置一直都指向同一個沒看過的 link-local 的位置，這邊測試了幾個裝置都是一樣的狀況。（後來想想這個應該是 路由器的 link-local address）

之後在電腦這邊做簡單的測試，直接手動把 dns 的位置改成 pihole 的 link-local address 後測試一下，看起來 query log 有正確的抓到對的裝置。

簡單來說，這台路由器(小米路由器)雖然在 ipv4 的情境下會直接給設定的 dns 位置，但是在 ipv6 的情況下會給路由器的 link-local 位置，之後由路由器統一向設定的 dns 位置詢問資料。從這裡來看就能理解為什麼 pihole 的 query log 都是看到路由器的 ip 了。

以圖來說大概就像是這樣

```nil
ipv4:
  電腦 -> pihole dns -> 網路
ipv6:
  電腦 -> 路由器 -> pihole dns -> 網路
```

因為行為上是看路由器的實作，所以能做的並不多，雖然可以每台裝置手動設定，不過太麻煩了，這邊就把 ipv6 的功能關起來了。
