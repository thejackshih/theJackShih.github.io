+++
title = "Clojure 開發環境設定"
author = ["Jack Shih"]
date = 2025-11-04T00:00:00+08:00
draft = false
+++

## 前言 {#前言}

之前參加 clojure meetup 並沒有簡單的文件輔助設定流程。這邊簡單列一下要怎麼設定環境。大致上是湊合網路上的資訊再加上一些自己的筆記。希望可以幫助大家加快上手的速度。


## 目標 {#目標}

在各環境安裝 clojure repl，並可以使用常用的編輯器操作 structure editing 及 interactive programming


## 安裝 clojure repl {#安裝-clojure-repl}

大致上分成兩種

1.  透過官方的 `clojure cli`
2.  透過 `Leiningen` 安裝

這邊建議是透過 `Leiningen` 安裝，原因是

1.  比較簡單使用
2.  各大平台都有提供 leiningen package，這也是 leiningen 官方推薦的安裝方式。
3.  雖然老派，但 leiningen 提供了一個好的 clojure 專案的出發點。
4.  如果是按照 Clojure for the brave and true，書中也是以 leiningen 當作基礎。

備註：如果編輯器是用 `intellij` 且沒有打算要用 terminal 操作可以略過這一步。因為 cursive 會獨立安裝 leiningen。


### MacOS {#macos}

```shell
brew install leiningen
```


### Linux {#linux}


#### dnf (fedora) {#dnf--fedora}

```shell
sudo dnf install leiningen
```


#### apt (debian / ubuntu) {#apt--debian-ubuntu}

```shell
sudo apt install leiningen
```


#### pacman (arch) {#pacman--arch}

```shell
sudo pacman -S leiningen
```


### Windows {#windows}


#### chocolatey {#chocolatey}

```powershell
choco install leiningen
```


#### install script {#install-script}

<https://leiningen.org/#install>


#### installer {#installer}

<https://bitbucket.org/djpowell/leiningen-win-installer/src/bitbucket-master/>


### REPL {#repl}

執行 `lein repl` ，第一次執行會需要等一下。
結束方式為 `ctrl-D (linux/macos)`, `ctrl-C (windows)`, `(exit)`, `(quit)`


#### 常見問題 {#常見問題}

`java.io.IOException: Permission denied. Please check your access rights for ...`
在 home directory 建立 `.lein` 資料夾

```shell
mkdir ~/.lein
```


## 編輯器設定 {#編輯器設定}


### emacs {#emacs}


#### 安裝 cider {#安裝-cider}

`M-x package-install <RET> cider <RET>`

```emacs-lisp
(use-package cider
  :ensure t)
```


#### 安裝 paredit {#安裝-paredit}

`M-x package-install <RET> paredit <RET>`

```emacs-lisp
(use-package paredit
  :ensure t)
```


#### interactive programming {#interactive-programming}

`M-x cider <RET> cider-jack-in-clj <RET>`

| 操作       | 快捷鍵  |
|----------|------|
| evaluation | C-x C-e |


#### structure editing {#structure-editing}

<http://danmidwood.com/content/2014/11/21/animated-paredit.html>

| 操作           | 快捷鍵            |
|--------------|----------------|
| Slurp forward  | C-&lt;right&gt;   |
| Barf forward   | C-&lt;left&gt;    |
| Slurp backward | C-M-&lt;left&gt;  |
| barf backward  | C-M-&lt;right&gt; |


### vim / neovim {#vim-neovim}


#### vim-fireplace + vim-sexp {#vim-fireplace-plus-vim-sexp}

-   <https://github.com/tpope/vim-fireplace>
-   <https://github.com/guns/vim-sexp>
-   <https://github.com/tpope/vim-sexp-mappings-for-regular-people>

<!--listend-->

```vimrc
Plug 'tpope/vim-fireplace'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
```


#### interactive programming {#interactive-programming}

`:FireplaceConnect`

<https://github.com/tpope/vim-fireplace>

| 操作       | 快捷鍵 |
|----------|-----|
| evaluation | cpp |


#### structure editing {#structure-editing}

<https://github.com/tpope/vim-sexp-mappings-for-regular-people>

| 操作           | 快捷鍵 |
|--------------|-----|
| Slurp forward  | &gt;) |
| Barf forward   | &lt;) |
| Slurp backward | &lt;( |
| barf backward  | &gt;( |


### neovim {#neovim}


#### conjure + vim-sexp {#conjure-plus-vim-sexp}

-   <https://github.com/Olical/conjure>
-   <https://github.com/guns/vim-sexp>
-   <https://github.com/tpope/vim-sexp-mappings-for-regular-people>

<!--listend-->

```vimrc
Plug 'Olical/conjure'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
```


#### interactive programming {#interactive-programming}

| 操作       | 快捷鍵                |
|----------|--------------------|
| evaluation | &lt;localleader&gt;ee |
| evaluation | \ee                   |


#### structure editing {#structure-editing}

<https://github.com/tpope/vim-sexp-mappings-for-regular-people>

| 操作           | 快捷鍵 |
|--------------|-----|
| Slurp forward  | &gt;) |
| Barf forward   | &lt;) |
| Slurp backward | &lt;( |
| barf backward  | &gt;( |


### vscode {#vscode}


#### 安裝 Calva {#安裝-calva}

<https://calva.io/>


#### interactive programming {#interactive-programming}

command palette -&gt; `Calva: Start a project REPL and connect`

| 操作       | 快捷鍵                       |
|----------|---------------------------|
| evaluation | shift + option (alt) + enter |


#### Structure editing {#structure-editing}

<https://calva.io/paredit/>

| 操作           | 快捷鍵                               |
|--------------|-----------------------------------|
| Slurp forward  | cmd + option + &lt;right&gt;         |
| Barf forward   | cmd + option + &lt;left&gt;          |
| Slurp backward | cmd + shift + option + &lt;left&gt;  |
| barf backward  | cmd + shift + option + &lt;right&gt; |


### intellij {#intellij}


#### 安裝 cursive {#安裝-cursive}

<https://cursive-ide.com/>


#### interactive programming {#interactive-programming}

<https://cursive-ide.com/userguide/repl.html#interaction-with-the-editor>

| 操作       | 快捷鍵          |
|----------|--------------|
| evaluation | shift + cmd + p |

<!--list-separator-->

-  常見問題

    No JDK Module for ...

    `project structure (cmd + ;)` -&gt; `sdk`


#### structure editing {#structure-editing}

<https://cursive-ide.com/userguide/paredit.html>

| 操作           | 快捷鍵            |
|--------------|----------------|
| Slurp forward  | cmd + shift + k   |
| Barf forward   | cmd + shift + j   |
| Slurp backward | cmd + control + j |
| barf backward  | cmd + control + k |


## References {#references}
