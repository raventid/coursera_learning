;;; init.el --- description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2020 Julian Pokrovsky
;;
;; Author: Julian Pokrovsky <http://github/raventid>
;; Maintainer: Julian Pokrovsky <john@doe.com>
;; Created: October 18, 2020
;; Modified: October 18, 2020
;; Version: 0.0.1
;; Keywords:
;; Homepage: https://github.com/raventid/init
;; Package-Requires: ((emacs 27.1) (cl-lib "0.5"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  description
;;
;;; Code:

;; Do Not show welcome screen with tutorials and other stuff
(setq inhibit-startup-message t)

(scroll-bar-mode -1) ;disables visible scrollbar
(tool-bar-mode -1) ;disables the toolbar
(tooltip-mode -1) ;disables tooltip mode

(set-fringe-mode 10) ;TODO: what is this?

(menu-bar-mode -1) ;disable menu bar

(setq visible-bell t) ;enable visible bell (not sure I need this so far)

(set-face-attribute 'default nil :family "JetBrains Mono" :height 150)

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package command-log-mode)

(column-number-mode)
(global-display-line-numbers-mode t)

;disable display-lines for some modes
(dolist (mode'(org-mode-hook
	       term-mode-hook
	       eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package counsel
    :config
    (counsel-mode 1))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))
