title: Claims-Based authentication in MVC Core
date: 2016-11-30 16:23:49
tags: 
- asp.net core
- mvc core
- c#
---
MVC5 以前時使用的 form authentication 在 MVC Core 被 Claims-based authentication 取代了。

首先加入 Middleware.

{% codeblock startup.cs  lang:cs %}
public void Configure(IApplicationBuilder app, IHostingEnvironment env, ILoggerFactory loggerFactory) {
    //略
    app.UseCookieAuthentication(new CookieAuthenticationOptions()
    {
        AuthenticationScheme = "MyCoodieMiddlewareInstance",
        LoginPath = new PathString(),
        AccessDeniedPath = new PathString(),
        AutomaticAuthenticate = true,
        AutomaticChallenge = true
    });
}
{% endcodeblock %}

登入方式為

{% codeblock lang:cs %}
var myclaims = new List<Claim>(new Claim[] { new Claim("Id", user.Id.ToString())});
var claimsPrincipal = new ClaimsPrincipal(new ClaimsIdentity(myclaims, "MyCookieMiddlewareInstance"));
HttpContext.Authentication.SignInAsync("MyCookieMiddlewareInstance", claimPrincipal).Wait();
{% endcodeblock %}

登出方式

{% codeblock lang:cs %}
HttpContext.Authentication.SignOutAsync("MyCookieMiddlewareInstance").Wait();
{% endcodeblock %}

取得 Claim 內容

{% codeblock lang:cs %}
var userId = User.FindFirst("Id").Value;
{% endcodeblock %}

Reference:
https://docs.microsoft.com/en-us/aspnet/core/security/authentication/cookie
