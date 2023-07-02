title: gogs 轉 gitea - part2：中文 wiki 失效
date: 2018-12-18 16:39:24
tags:
- gitea
---
之前轉移至 gitea 後發現無法開啟 wiki。測試了一下發現是因為編碼的問題所導致。如果要修復必須先將 wiki 檔名轉換成 URL 使用的 UTF-8 格式。gitea是將 wiki 頁面放在 repo 目錄下以 XXX.wiki.git 存放。因為也是 git 所以可以直接 clone 下來改檔名後再 push 回去就可以了。

因為也是 .md 檔，所以乾脆把 wiki 關了也是可以。因為 gitea 並沒有提供全域的關閉 wiki 功能所以必須要一個一個設定。如果不要的話可以直接執行以下  SQL 直接移除。

```
DELETE FROM repo_unit
WHERE type = 5
-- 資料庫任何資料請自行負責，謝謝
```

接下來還有什麼問題再看看。