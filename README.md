[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![JCS-ELPA](https://raw.githubusercontent.com/jcs-emacs/badges/master/elpa/v/multi-shell.svg)](https://jcs-emacs.github.io/jcs-elpa/#/multi-shell)
<a href="https://jcs-emacs.github.io/"><img align="right" src="https://raw.githubusercontent.com/jcs-emacs/badges/master/others/built-with/dark.svg" alt="Built with"></a>

# multi-shell
> Managing multiple shell buffers.

[![CI](https://github.com/jcs-elpa/multi-shell/actions/workflows/test.yml/badge.svg)](https://github.com/jcs-elpa/multi-shell/actions/workflows/test.yml)

Simple and completely compatible to Emacs' built-in `shell` implementation.
This also works with `eshell`.

## ❓ Differences from other alternatives

* [mutli-term](https://www.emacswiki.org/emacs/MultiTerm)
  - Doesn't work in Windows.

## 🔧 Usage

`multi-shell` provides the following interactive functions

* `multi-shell` - Create a new shell buffer.
* `multi-shell-select` - Switch to shell buffer.
* `multi-shell-next` - Switch to next shell buffer.
* `multi-shell-prev` - Switch to previous shell buffer.
* `multi-shell-kill` - Kill the current shell buffer.
* `multi-shell-kill-all` - Kill all shell buffers.

## 🧪 Customization

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

## 🛠️ Contribute

[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)
[![Elisp styleguide](https://img.shields.io/badge/elisp-style%20guide-purple)](https://github.com/bbatsov/emacs-lisp-style-guide)
[![Donate on paypal](https://img.shields.io/badge/paypal-donate-1?logo=paypal&color=blue)](https://www.paypal.me/jcs090218)
[![Become a patron](https://img.shields.io/badge/patreon-become%20a%20patron-orange.svg?logo=patreon)](https://www.patreon.com/jcs090218)

If you would like to contribute to this project, you may either
clone and make pull requests to this repository. Or you can
clone the project and establish your own branch of this tool.
Any methods are welcome!

### 🔬 Development

To run the test locally, you will need the following tools:

- [Eask](https://emacs-eask.github.io/)
- [Make](https://www.gnu.org/software/make/) (optional)

Install all dependencies and development dependencies:

```sh
$ eask install-deps --dev
```

To test package's installation:

```sh
$ eask package
$ eask install
```

To test compilation:

```sh
$ eask compile
```

**🪧 The following steps are optional, but we recommend you follow these lint results!**

The built-in `checkdoc` linter:

```sh
$ eask lint checkdoc
```

The standard `package` linter:

```sh
$ eask lint package
```

*📝 P.S. For more information, find the Eask manual at https://emacs-eask.github.io/.*

## ⚜️ License

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.

See [`LICENSE`](./LICENSE.txt) for details.
