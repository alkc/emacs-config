;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; (setq debug-on-error t)

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;; For a majority of programming languages, an underscore is part of a word or symbol.
(modify-syntax-entry  ?_ "w" (standard-syntax-table))

(setq user-full-name "Alexander Koc"
      user-mail-address "alkc@proton.me")


;; Setup central bkp dir:
(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;; SHUT UP:
(setq custom-safe-themes t)

;; Config dark/light mode switcher
(use-package heaven-and-hell
  :ensure t
  :config
  (setq heaven-and-hell-theme-type 'dark) ;; Omit to use light by default
  (setq heaven-and-hell-themes
        '((light . doom-winter-is-coming-light)
          (dark . doom-gruvbox))) ;; Themes can be the list: (dark . (tsdh-dark wombat))
  ;; Optionall, load themes without asking for confirmation.
  (setq heaven-and-hell-load-theme-no-confirm t)
  :hook (after-init . heaven-and-hell-init-hook)
  :bind (("C-c <f6>" . heaven-and-hell-load-default-theme)
         ("<f6>" . heaven-and-hell-toggle-theme)))

;; treemacs workaround thingie:
;; (add-to-list 'image-types 'svg)

(setq confirm-kill-emacs nil)

(setq projectile-project-search-path '("~/projects/" ))
(setopt display-fill-column-indicator-column 100)
(add-hook 'python-mode #'display-fill-column-indicator-mode)

(use-package! nextflow-mode
  :config
  (set-docsets! 'nextflow-mode "Groovy"))

;;(use-package keychain-environment
;;  :config (keychain-refresh-environment))

(setq persp-emacsclient-init-frame-behaviour-override "main")

;; Use the docker compose plugin instead!
(eval-after-load 'docker-compose
  '(setq docker-compose-command "docker compose"))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(nextflow-mode . ("java" "-jar" "/home/alkc/.local/bin/nextflow-language-server-all.jar"))))

(require 'nov)
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))


(global-set-key (kbd "C-ä") 'vundo)
(global-set-key (kbd "C-ö") 'comment-dwim)
(global-set-key (kbd "C-\"") 'er/mark-word)
(global-set-key (kbd "M-å") 'backward-paragraph)
(global-set-key (kbd "M-¨") 'forward-paragraph)

;; POMODORO TIMER KEYBINDS:
(global-set-key (kbd "C-c n p p") 'org-timer-set-timer)
(global-set-key (kbd "C-c n p q") 'org-timer-stop)
(global-set-key (kbd "C-c n p s") 'org-timer-pause-or-continue)


(setq vterm-tramp-shells '(("docker" "sh")
                           ("ssh" "bash")))

(require 'gptel)
(setq gptel-api-key (auth-source-pick-first-password :host "api.openai.com"))
