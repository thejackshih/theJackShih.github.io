+++
title = """
  How to fix nix "Problem with the SSL CA cert" on macOS
  """
author = ["Jack Shih"]
date = 2023-05-26T07:59:00+08:00
tags = ["nix", "emacs", "eshell"]
draft = false
+++

When using nix operations inside emacs sometime it will show this warning during install packages.

```shell
warning: error: unable to download '{SOME_URL}': Problem with the SSL CA cert (path? access rights?) (77); using cached version
```

This warning occur because emacs gui on macOS use system defaut environment variable instead of shell environment variable. Most people on macOS use `exec-path-from-shell` to fix the path problem. Luckly `exec-path-from-shell` provide a variable call `exec-path-from-shell-variables` to import any other environment variables other than `PATH`.

So we can import `NIX_PROFILES` and `NIX_SSL_CERT_FILE` like below to solve the issue.

```emacs-lisp
(use-package exec-path-from-shell
  :ensure t
  :config
  (dolist (var '("LC_CTYPE" "NIX_PROFILES" "NIX_SSL_CERT_FILE"))
    (add-to-list 'exec-path-from-shell-variables var))
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))
```
