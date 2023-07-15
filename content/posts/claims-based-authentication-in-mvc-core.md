+++
title = "Claims-Based authentication in MVC Core"
author = ["Jack Shih"]
date = 2016-11-30T00:00:00+08:00
tags = ["asp-net-core", "mvc-core", "c-sharp"]
draft = false
+++

MVC5 以前時使用的 form authentication 在 MVC Core 被 Claims-based authentication 取代了。

首先加入 Middleware.

```csharp
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
```

登入方式為

```csharp
var myclaims = new List<Claim>(new Claim[] { new Claim("Id", user.Id.ToString())});
var claimsPrincipal = new ClaimsPrincipal(new ClaimsIdentity(myclaims, "MyCookieMiddlewareInstance"));
HttpContext.Authentication.SignInAsync("MyCookieMiddlewareInstance", claimPrincipal).Wait();
```

登出方式

```csharp
HttpContext.Authentication.SignOutAsync("MyCookieMiddlewareInstance").Wait();
```

取得 Claim 內容

```csharp
var userId = User.FindFirst("Id").Value;
```


## Reference {#reference}

<https://docs.microsoft.com/en-us/aspnet/core/security/authentication/cookie>
