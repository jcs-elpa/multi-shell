[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![CELPA](https://celpa.conao3.com/packages/multi-shell-badge.svg)](https://celpa.conao3.com/#/multi-shell)
[![JCS-ELPA](https://raw.githubusercontent.com/jcs-emacs/jcs-elpa/master/badges/multi-shell.svg)](https://jcs-emacs.github.io/jcs-elpa/#/multi-shell)

# multi-shell
> Managing multiple shell buffers.

[![CI](https://github.com/jcs-elpa/multi-shell/actions/workflows/test.yml/badge.svg)](https://github.com/jcs-elpa/multi-shell/actions/workflows/test.yml)

Simple and completely compatible to Emacs' built-in `shell` implementation.
This also works with `eshell`.

## Differences from other alternatives

* [mutli-term](https://www.emacswiki.org/emacs/MultiTerm)
  - Doesn't work in Windows.

## Usage

`multi-shell` provides the following interactive functions

* `multi-shell` - Create a new shell buffer.
* `multi-shell-select` - Switch to shell buffer.
* `multi-shell-next` - Switch to next shell buffer.
* `multi-shell-prev` - Switch to previous shell buffer.
* `multi-shell-kill` - Kill the current shell buffer.
* `multi-shell-kill-all` - Kill all shell buffers.

## Customization

Add these two lines in your configuration file if you do use any package
management tool. (Like, [use-package](https://github.com/jwiegley/use-package))

```el
(require 'multi-shell)
(setq multi-shell-prefer-shell-type 'shell)  ; Also accept `eshell`.
```

If you are using [use-package](https://github.com/jwiegley/use-package)
for package management.

```el
(use-package multi-shell
  :init
  (setq multi-shell-prefer-shell-type 'shell))  ; Also accept `eshell`.
```

## Contribute

[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)
[![Elisp styleguide](https://img.shields.io/badge/elisp-style%20guide-purple)](https://github.com/bbatsov/emacs-lisp-style-guide)
[![Donate on paypal](https://img.shields.io/badge/paypal-donate-1?logo=paypal&color=blue)](https://www.paypal.me/jcs090218)

If you would like to contribute to this project, you may either
clone and make pull requests to this repository. Or you can
clone the project and establish your own branch of this tool.
Any methods are welcome!
