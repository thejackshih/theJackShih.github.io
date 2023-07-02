title: Single Page Application session-based 驗證
date: 2019-05-09 21:23:43
tags:
- asp.net core
- mvc core
- javascript
---
基本上談到 SPA 大部分人推崇的會是使用 JWT 做驗證，不過要用 JWT 做驗證要考慮到的事情可多的。是不是值得把原本 session 作的事情拿回來自己做也是需要考慮的。
後來才發現其實也是可以直接使用原來的 cookie-session 的驗證也是 ok，而且反而簡單很多。
也許是因為太簡單所以網路上查不太到資料吧，所以在這邊紀錄一下。

直接參照 M$ 官方網站的教學

在 `startup.cs` 內的 `ConfigureService` 中加入
```
services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
    .AddCookie(options => {
        options.Cookie.name = "CookieName";
        options.Cookie.path = "/";
        options.Events.OnRedirectToLogin = (context) =>
        {
            // 把未登入的自動轉頁複寫掉
            context.Response.StatusCode = 401;
            return Task.CompletedTask;
        }
    });
```

然後在 `Configure` 中加在 `usespaservice` 上面

```
app.UseAuthentication();
```

基本上就跟 MVC 平常一樣。

# 登入
```
var claims = new List<Claim>
{
    new Claim(ClaimTypes.Name, user.Email),
    new Claim("FullName", user.FullName),
    new Claim(ClaimTypes.Role, "Administrator"),
};

var claimsIdentity = new ClaimsIdentity(
    claims, CookieAuthenticationDefaults.AuthenticationScheme);

await HttpContext.SignInAsync(
    CookieAuthenticationDefaults.AuthenticationScheme,
    new ClaimsPrincipal(claimsIdentity));
```

# 登出
```
await HttpContext.SignOutAsync(
    CookieAuthenticationDefaults.AuthenticationScheme);
```

# JS fetch
```
fetch(url, {
  credentials: "same-origin"
}).then(...);
```

# Reference
http://cryto.net/~joepie91/blog/2016/06/13/stop-using-jwt-for-sessions
https://docs.microsoft.com/zh-tw/aspnet/core/security/authentication/cookie
https://stackoverflow.com/questions/46247163/net-core-2-0-cookie-authentication-do-not-redirect
https://stackoverflow.com/questions/34558264/fetch-api-with-cookie
