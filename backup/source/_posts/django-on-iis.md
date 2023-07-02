title: 在 IIS 上架設 django
date: 2017-07-12 08:37:39
tags:
- windows server
- iis
- django
- python
- wfastcgi
---
# 前言
在 IIS 上執行 python 跟是一回事，在 IIS 上架設 django 又是另外一回事。而網路上的資源又更少了一點，經過各種搜尋後在這裡記下一些筆記。

執行環境如下，每一項都會可能因為版本不同而有些許不同。這也是網路資源較難使上力的原因，因為解決方式的版本跟所用的版本可能不同而不適用。
- windows server 2012 R2
- iis 8.5
- python 3.6
- django 1.11.3

<!-- more -->

# 強者版
  步驟 1 -> 2 -> 11 -> 12 -> 13

# 詳細版
1. 安裝 wfastcgi `pip install wfastcgi`
2. 啟用 wfastcgi `wfastcgi-enable`
3. 安裝 django `pip install Django==1.11.3`
4. `機器首頁 -> IIS -> FastCGI 設定` 這應該要有 python.exe，如果沒有點選`右側新增應用程式`。
5. 完整路徑為python執行檔位置如：`<python安裝路徑>\python.exe` 引數為wfastcgi.py如：`<python安裝路徑>\lib\site-packages\wfastcgi.py`
6. 新增網站
7. `網站設定頁面中 -> IIS -> 處理常式對應 -> 新增模組對應`
8. 要求路徑： `*`，模組：`FastCgiModule`，執行檔：`<python安裝路徑>\python.exe|<python安裝路徑>\lib\site-packages\wfastcgi.py`，名稱：`Django Handler`（或是隨意）
9. 要求限制 -> 取消勾選 `只有當要求對應到下列項目時才啟動處理常式`
10. IIS manager 可能會問你是否要建立 fastcgi 應用程式，選否 (選是應該也是可以)
11. 看一下網站資料夾下面有無 `web.config`，參考下面的範例，如果前面有照著做應該只要加入 appSettings 即可。
{% codeblock %}
<?xml version="1.0" encoding="UTF-8"?>
    <configuration>
        <system.webServer>
            <handlers>
                <add name="Django Handler" 
                     path="*" 
                     verb="*" 
                     modules="FastCgiModule" 
                     scriptProcessor="<python安裝路徑>python.exe|<python安裝路徑>\Lib\site-packages\wfastcgi.py" 
                     resourceType="Unspecified" />
            </handlers>
        </system.webServer>
        <appSettings>
            <add key="WSGI_HANDLER" value="django.core.wsgi.get_wsgi_application()" />
            <add key="PYTHONPATH" value="<網站資料夾路徑>" />
            <add key="DJANGO_SETTINGS_MODULE" value="<Django App>.settings" />
        </appSettings>
    </configuration>
{% endcodeblock %}
12. 在 **網站資料夾** 跟 **python資料夾** 中給予`IUSR` 跟 `IIS_USRS` 權限
13. 用瀏覽器測試看看是否成功

# 心得
原理不難，設定也還好，主要的問題都出在權限，這也是大部分教學比較少提到的。當然不要在 iis 上跑這些東西才是最佳解。

# 常用指令
django 開新專案
{% codeblock %}
django-admin startproject mysite
{% endcodeblock %}
django 測試伺服器
{% codeblock %}
python manage.py runserver
{% endcodeblock %}
# 常見問題
## 0x8007010b 錯誤
檢查 **python** 目錄中的權限是否正確 **IUSR** 及 **IIS_USRS**

## 找不到指令 (pip 或 python)
環境變數沒有設定 
1. `控制台 -> 系統及安全性 -> 系統 -> 進階系統設定 -> 環境變數 -> 系統變數` 
2. path 末端加入 `;<python安裝路徑>;<python安裝路徑>\Scripts`

# 參考資料
[Running a Django app on Windows IIS](http://kronoskoders.logdown.com/posts/1074588-running-a-django-app-on-windows-iis)
[Running a Django Application on Windows Server 2012 with IIS](http://blog.mattwoodward.com/2016/07/running-django-application-on-windows.html)
[WindowsServer2012R2 + IIS + Django + wfastcgiの環境構築](http://errormaker.blog74.fc2.com/blog-entry-24.html)
[django](https://www.djangoproject.com)
[IIS7.5中的IUSR與IIS_IUSRS區別](http://blog.fhps.tp.edu.tw/fhpsmis/?p=1015)
