;; Author  : Raveendra Soori
;; Created : 7th April 2023

;; load early-init.el in earlier versions
(when (version< emacs-version "27")
  (load (concat user-emacs-directory "early-init.el")))

(setq-default custom-file (concat user-emacs-directory "custom-file.el")
	      indent-tabs-mode nil
	      create-lockfiles nil)

;; Set font size. This might need adjustment
(set-face-attribute 'default nil :height 130)

;; Use y-or-n instead of yes-or-no
(defalias 'yes-or-no-p 'y-or-n-p)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Initialize package sources
(require 'package)

;; Enable obtaining packages from melpa and elpa devel (required for compat-28.x)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("elpa-devel" . "https://elpa.gnu.org/devel/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)

;; No need to ensure each package
(setq use-package-always-ensure t)

;; Show keystrokes in a buffer
(use-package command-log-mode
  :commands command-log-mode)

;; Vim you shall
(use-package evil
  :init
  (setq evil-want-integration t
	evil-want-keybinding nil
	evil-want-C-u-scroll t
	evil-want-C-i-jump nil)
  :config (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

;; ivy completion framework
(use-package ivy
  :config (ivy-mode 1))

;; ivy enhanced versions of common Emacs commands
(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history)))

;; Better sorting for ivy
(use-package ivy-prescient
  :after counsel
  :custom
  (ivy-prescient-enable-filtering t)
  :config
  (prescient-persist-mode 1)
  (ivy-prescient-mode 1))

;; Pretty themes
(use-package doom-themes
  :init (load-theme 'doom-dracula t))

(use-package all-the-icons)

;; Pretty mode-line
(use-package doom-modeline
  :init (doom-modeline-mode 1))

;; Apparently the best git interface
(use-package magit
  :bind ("C-x g" . magit-status))

;; Better help
(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; Morreee Vim
(use-package evil-collection
  :after evil
  :config (evil-collection-init))

(use-package pulsar)

(use-package which-key
  :defer 0
  :config (which-key-mode))

;; Frame wide text scaling
(use-package default-text-scale
  :config (default-text-scale-mode 1))

;; Load custom configuration
(load-file custom-file)
