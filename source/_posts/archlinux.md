title: arch linux 筆記 - 安裝篇 
date: 2019-01-23 14:02:37
tags: 
- linux
---
最近再度挑戰使用 arch linux
這次感覺比較成功，也慢慢讓系統進步到堪用的狀態，每次挑戰都學了一點東西，現在看起來終於發了芽。

安裝上基本上跟著 https://wiki.archlinux.org/index.php/Installation_guide 走就好。
這裡做個筆記補充一下東西，下次就不用查東查西。

# 無線網路
這裡是用 `netctl` 這個軟體。還要加上 `wpa_supplicant` 及 `dhcpcd` 這兩個相依。

`/etc/netctl/{profile name}`
```
Description='A simple WPA encrypted wireless connection using 256-bit PSK'
Interface=wlp2s2
Connection=wireless
Security=wpa
IP=dhcp
ESSID=your_essid
Key=\"64cf3ced850ecef39197bb7b7b301fc39437a6aa6c6a599d0534b16af578e04a
```

不用被加密過得 key 嚇到，輸入明碼也可以。
Interface 欄位可以用 `ip link show` 來取得

之後用 `netctl start {profile name}` 連線，現在用 `ping` 指令應該可以ping到東西了。

# 切硬碟
基本上採單一配置（純粹懶），網路上研究一下似乎獨立切 SWAP 效益不太大，用 SWAP file 就好。
Boot 切大一點比較重要，無論是 BIOS 或是 EFI 都不建議太低。自己是用 UEFI 直接切建議的最大值 512Mib(Mib 跟 MB 不太一樣，但差不多。) 原因在於過去經驗每次更新 kernel 它會把相關檔案放在 boot 下面，之前曾經切的太小導致更新一直失敗之後要定期去清把舊的 kernal 刪除。
還有 sector 大小（應該 fdisk 會問你）就用 `fdisk -l` 給的資訊去設定，如果沒有對齊會在後面的時候跳出警告。所以這邊就先設定好。

# 掛載
記得把 /boot 掛上去
`# mount /dev/sdX2 /mnt`
`# mkdir /mnt/efi`
`# mount /dev/sdX1 /mnt/efi`

# Boot Loader
依照自己使用的主機板系統(BIOS or UEFI)跟檔案系統做選擇，基本上功能都大同小異。
自己是使用 `GRUB` 因為使用 `ext4` 這個檔案系統

# microcode
安裝完記得裝上 microcode ，這是 CPU 廠商的一些 patch。
依照廠商安裝 `amd-ucode` 或是 `intel-ucode`

`GRUB** 有自帶偵測更新`
`# grub-mkconfig -o /boot/grub/grub.cfg`

或是按照 wiki 的教學手動加也是可以。

# 必要的東西
重開機前記得將之後要用的工具像是無線網路的程式，有些系統軟體在 usb 內有但是不會安裝到硬碟內，如果忘記了可以之後再用 usb 開機後 重新掛載後安裝

# 設定開機
如果有找不到 bootloader 的情況可能是這邊BIOS要設定
參照 {% post_link how-to-boot-into-linux-on-v3-372 %}

# 安裝後
預設是 root 所以要先新增自己的帳號。
`# useradd -m {name}`
`# passwd {name}`

基本上 `sudo` 是必備的
`# pacman -S sudo` 

裝好之後用 `visudo` 進入設定檔
把相關設定的註解移除
基本上應該是開啟 `wheel` 或 `sudo` 這兩個群組的權限，都開也可以。
建立這兩個群組
`# groupadd sudo`
`# groudadd wheel`
在將自己的使用者加入
`# gpasswd -a {user} {group}`

# 最後
這樣差不多就可以用了，接下來就是安裝自己的環境了。
其實 arch wiki 已經寫得很清楚，大部分的資料都看 wiki 就可以解了。
