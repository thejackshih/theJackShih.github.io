title: No Fragment ， One Activity - Custom View 架構 - 續
date: 2017-04-12 19:17:43
tags:
- android
---
距離過去寫 no-fragment 架構的文章也快一年了，那當然最好測試新架構的方式就是直接實戰，那種比 HelloWorld 程式更為複雜的程式。這次回過頭來看看當時候遇到的問題。

<!-- more -->

# BackStack 比想像中還要複雜多了
在當時寫的時候並沒有套用 Flow ，覺得是不必要的框架。但事實上 Mobile APP 比一般網頁還要複雜多了。在頁面不同的跳轉中要如何管理 UI State 並不是一件簡單的事情。到最後變成自己實作一個很像 Life Cycle 的東西。

# Share State
一般寫 Android 最容易遇到的問題大概就是我該如何在 Activity 或 Fragment 間傳遞訊息。這部分要如何做到很好也不是很容易。自己是直接在上層 Activity 開個 HashMap 直接存值，但這樣的解法略顯簡陋，應該有更好的方式。

# MVP
雖然 MVP 提供的一個大方向，但要如何將職責切開來也是一門學問，在遇到 RecyclerView 這樣複雜的 View 時又會是一個問題。原本以為 Presenter 只需要知道 View 就好，但最後搞到必須要將 activity 注入到每個 Presenter 中，感覺有更好的做法。

# AlertDialog
在原來的架構下應該同一時間應該只能有一個主要 View ，可是遇到像 Dialog 這種要疊加 View 的時候似乎就還是一定要用到 Fragment 雖然要用 CustomView 做也不是不行，但還是太麻煩了，最後這變成在 APP 中唯一會使用到 Fragment 的例外。

# CustomView Preview
使用 CustomView + MVP 會遇到 Preview 時會出現錯誤訊息的問題，需要用 isInEditMode 這樣的布林值來為 Preview 做判斷。

# Android M 權限問題
Android M 增加了即時詢問權限的問題，必須要來往 Activity 做。

# 總結
實務上的 APP 總是比較複雜，不過當自己動手做一些原本靠套件所辦到的事情確實是學習到很多東西。
