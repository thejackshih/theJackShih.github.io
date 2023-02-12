title: 如何重設 launchpad
date: 2023-02-12 18:56:43
tags:
- macos
- launchpad
---
因為最近用 nix 在嘗試東西，刪刪改改之後發現 launchpad 的連結壞了，導致就算把 `/Applications` 或 `~/Applications` 中的程式移除後 launchpad 還會看到那個檔案。這邊記錄一下要怎麼重設 launchpad。  

舊版的教學會說 launchpad 的 db 位置在 `~/Library/Application\ Support/Dock`。  

不過在 macOS Sierra 之後已經被移到其他地方，原來的位置只剩下 picture.db。  

而新的位置在 `/private/var/folders` 下，如果打開來會看到裡面有被編碼的資料夾檔名，這邊可以透過 `getconf DARWIN_USER_DIR` 這個指令去查使用者的資料夾的路徑，執行的結果應該會是 `/var/folders/...`(雖然這邊是 `/var` 不過實際上是 `/private/var`)。知道之後就可以直接去資料夾下面的 `com.apple.dock.launchpad` 中把 db 檔案刪除。  

或是直接 `cd $(getconf DARWIN_USER_DIR)/com.apple.dock.launchpad/db` 到資料夾內刪除，刪完後用指令`killall Dock`重開 Dock

若是大膽也可以直接執行刪除並重啟指令  
`rm $(getconf DARWIN_USER_DIR)/com.apple.dock.launchpad/db/*.db;killall Dock`  

執行後重新開機應該就沒問題了。  

註：db 檔案實際上是 sqlite，所以有興趣也可以用 sqlite viewer 之類的程式直接開起來看看內容。檔案實際存放位置也會在裡面。  
