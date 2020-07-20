[![Build Status](https://travis-ci.com/jcs-elpa/multi-shell.svg?branch=master)](https://travis-ci.com/jcs-elpa/multi-shell)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

# multi-shell
> Managing multiple shell buffers.

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

## Contribution

If you would like to contribute to this project, you may either
clone and make pull requests to this repository. Or you can
clone the project and establish your own branch of this tool.
Any methods are welcome!
