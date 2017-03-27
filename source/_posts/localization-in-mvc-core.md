title: MVC core 做 Localization
date: 2017-03-22 10:30:51
tags:
- mvc core
- c#
---

過去不曾做過多國語言的支援，更不曾在 web 界做過，研究一下之後發現 Asp.net mvc core 也有提供工具。這裡做一下筆記。

# 基本認識

一般多國語言的做法多是用替換字串的方式，然後用 Key/Value 的方式去做取代。目的是將顯示文字跟程式脫鉤，只要抽換文字檔案就可以更換顯示的文字而不需要修改程式，翻譯人員也可以直接透過這個檔案進行翻譯。基本的概念大概就是這樣。進階一點的就是某些從右讀到左的語言會需要 UI 翻轉之類的事情了。

<!-- more -->

# Setup
{% codeblock startup.cs  lang:cs %}
public void ConfigureServices(IServiceCollection services)
{
    //略
    services.AddLocalization(options => options.ResourcesPath = "Resources");
    services.AddMvc()
        .AddViewLocalization(LanguageViewLocationExpanderFormat.Suffix)
        .AddDataAnnotationsLocalization();
    services.Configure<RequestLocalizationOptions>(
        options =>
        {
             var supportedCultures = new List<CultureInfo>
             {
                 new CultureInfo("en-US"),
                 new CultureInfo("zh-CN"),
                 new CultureInfo("zh-TW")
             };

             options.DefaultRequestCulture = new RequestCulture(culture: "zh-TW", uiCulture: "zh-TW");
             options.SupportedCultures = supportedCultures;
             options.SupportedUICultures = supportedCultures;
        });
}
public void Configure(IApplicationBuilder app, IHostingEnvironment env, ILoggerFactory loggerFactory)
{
    //略
    var locOptions = app.ApplicationServices.GetService<IOptions<RequestLocalizationOptions>>();
    app.UseRequestLocalization(locOptions.Value);
}

{% endcodeblock %}

在根目錄建立 `Resources` 資料夾  
依照預設規則建立資源檔
`[views/controllers].[controller name].[action name].[language].resx`  
ex. `Views.Home.Index.zh-TW.resx`

# How to use

使用的方式為
{% codeblock Index.cshtml  lang:cshtml %}
@using Microsoft.AspNetCore.Mvc.Localization
@inject IViewLocalizer Localizer

<!-- 一般這樣用 -->
@Localizer["welcome"]

<!-- 如果遇到顯示錯誤的狀況 -->
@Localizer["welcome"].Value
{% endcodeblock %}

測試的方式為在 URL 後面加入 `culture` 參數  
`http://localhost:5000/home/?culture=zh-tw`

MVC Core 1.1 後面有支援在 URL 上加入語言選項  
ex. `http://localhost:5000/zh-tw/home/`

不過目前環境是 1.0 所以就沒再研究了，應該是要用 ActionFilter 之類的，不過就算這樣還是沒辦法用 Default Route mapping，參考連結內有更完整的教學。

# Reference
https://docs.microsoft.com/en-us/aspnet/core/fundamentals/localization
https://damienbod.com/2015/10/21/asp-net-5-mvc-6-localization/
