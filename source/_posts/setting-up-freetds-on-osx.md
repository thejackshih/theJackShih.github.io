title: 在 OSX 設定 FreeTDS 
date: 2017-08-23 11:40:21
tags:
- freetds
- osx
- mssql
---
過去一直以來 Unix-like 要跟 MSSQL 連線就是不容易，如果要跟舊版 MSSQL 連線就更難了，雖然有 unixODBC 和 FreeTDS 但這兩個設定的方式也不算容易。這裡當作筆記記錄下來。

<!-- more -->


# OSX:
1.  `brew install unixodbc`
2.  `brew install freetds --with-unixodbc  --with-msdblib`

# freetds:

檢查設定:  `tsql -C`   
嘗試連線:  `tsql -H <HostName> -p <port> -U <username> -P <password>`  
設定檔案:  `~/.freetds.conf`  
example:  
```
  [ExampleServer]
  host = ExampleServerIP
  port = 1433
  tds version = 7.0
```  
# unixODBC:
嘗試連線:  `isql -v <DSN> <username> <password> `  
嘗試連線除錯: `osql -S <DSN> -U <username> -P <password>`    
查看設定:  `odbcinst -j`

## Driver 設定:
`.odbcinst.ini `  
```
  [FreeTDS]  
  Description =FreeTDS  
  Driver =/usr/local/Cellar/freetds/1.00.26/lib/libtdsodbc.so  
```
注意 "=" 之後不要有空格  
unix環境應該在 /etc/ 之類的

## DSN 設定:
`.odbc.ini`  
```
  [ExampleServer]  
  Driver = FreeTDS  
  Description = MyExample  
  ServerName = ExampleServer  
  UID = <username>  
  PWD = <pasaword>
```
# connectingString:
  `"DRIVER={ExampleServer};DSN=;UID=;PWD=;Database="`

# Github
[https://github.com/randomdize/freetds-example](https://github.com/randomdize/freetds-example)
