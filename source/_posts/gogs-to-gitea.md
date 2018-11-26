title: 從 Gogs 轉移至 Gitea
date: 2018-11-26 17:11:42
tags: 
- gogs
- gitea
---
Gitea 雖然源自於 Gogs ，不過要從 Gogs 轉移到 Gitea 卻是十分困難。官方給的教學中 Gogs 的版本要在 `0.9.146` 或是更舊才能轉移。目前使用的版本已經太新(`0.11.29.0727`)。想說直接按照官方的文件做，結果遇到 Gitea 在 `1.0` 中不支援 MSSQL 的窘境。 
後來在自己試一試的情況下成功了，這邊紀錄一下是如何轉上去的。

環境
- Microsoft Windows Server 2012 R2
- Microsoft SQL Server 2012
- gogs 0.11.29.0727
- gitea 1.6.0

1. 乾淨安裝 gitea 1.6.0
2. 第一次設定就正常設定，但是不要設定系統管理員帳號
3. 直接將 gogs 資料庫中的資料匯入 gitea 資料庫（啟用識別插入，然後最後應該會失敗，不過大部分的資料都會成功）
4. 接下來應該就可以用了，但是選取任何資源庫的時候會 404 error。
5. 執行這段 SQL
```
insert into repo_unit (repo_id, type, config, created_unix) 
select repository.id, types.*, '{}', repository.created_unix from repository
left join repo_unit on repository.id=repo_id 
left join (
  select 1 as col1, 1 as col2
  UNION ALL select 2,2
  UNION ALL select 3,3
  UNION ALL select 4,4
  UNION ALL select 5,5) as types on (1=1)
where repo_id is null;
```
6. 收工

大致上可以用，不過沒有 webhook 之類的（先前的失敗停止的部分）
流程應該可以在更好才是。（例如僅匯入該匯入的資料表）

# Reference
[Error while displaying public repo (404)](https://github.com/go-gitea/gitea/issues/1794#issuecomment-347831784)