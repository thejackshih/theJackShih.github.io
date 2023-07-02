title: Use the Source - 解決 Api doc missing comma error  
date: 2017-05-03 13:46:31
tags:
- apidoc
---
最近想要試試 api doc 產生器，於是 Google 一下後找到看起來很不錯的工具 Api doc。結果按照教學設定完之後一執行馬上就出現 
`Can not read: apidoc.json, please check the format (e.g. missing comma)`

我百思不得其解，也確認了 apidoc.json 有存在，逗號也都在。以為是自己格式弄錯，結果直接複製官方的文字也是出錯。

遇到無法解決的問題，身為一位程式設計師當然趕緊 Google 一下，StackOverflow 一下，再上 github 看看 issue list。

結果還是找不到什麼有用的資訊，要不就是有點鬼打牆的回覆。不過好在開發者有個 Debug log 模式，一看雖然不知道哪裡有問題，但似乎是拋出了一個例外。

最後正當要放棄的時候去看了一下 source code，一看才發現原來只是個簡單的 Json parse.

{% codeblock lang:js %}
PackageInfo.prototype._readPackageData = function(filename) {
    var result = {};
    var dir = this._resolveSrcPath();
    var jsonFilename = path.join(dir, filename);

    // Read from source dir
    if ( ! fs.existsSync(jsonFilename)) {
        // Read from config dir (default './')
        jsonFilename = path.join(app.options.config, filename);
    }
    if ( ! fs.existsSync(jsonFilename)) {
        app.log.debug(jsonFilename + ' not found!');
    } else {
        try {
            result = JSON.parse( fs.readFileSync(jsonFilename, 'utf8') );
            app.log.debug('read: ' + jsonFilename);
        } catch (e) {
            throw new Error('Can not read: ' + filename + ', please check the format (e.g. missing comma).');
        }
    }
    return result;
};
{% endcodeblock %}

這時候就是使用古老的印出變數的方法了（感謝JavaScript 可以直接去改 source code 而不用重新 Build），直接把 parse 的字串輸出，結果發現原來是 Visual Studio 在建立檔案的時候前面插入了一些多餘的資料(也許是BOM? 還是其他的之類的)，導致 parse 失敗，改用記事本建立 apidoc.json 之後就解決了，可喜可賀。

學到幾個經驗
1. ~~notepad > Visual Studio~~ 純文字就用編輯器最保險
2. 在 Windows 上使用在 unix 系統開發的東西時很容易遇到奇怪的問題
3. `Use the Source, Luke`
