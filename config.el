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
(setq doom-theme 'ef-dream)

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
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(display-time-mode -1)

(use-package! fuzzy-clock
  :config
  (setq fuzzy-clock-fuzziness 'part-of-day)
  (setq fuzzy-clock-update-interval 3600)  
  (fuzzy-clock-mode 1))


(let ((local-bin (expand-file-name "~/.local/bin")))
  (when (file-directory-p local-bin)
    (setenv "PATH" (concat local-bin path-separator (getenv "PATH")))
    (add-to-list 'exec-path local-bin)))

;; Comment out not to skip over underscores when moving by word
;; For a majority of programming languages, an underscore is part of a word or symbol.
;;(modify-syntax-entry  ?_ "w" (standard-syntax-table))

(let ((splash-image "/home/alkc/.config/emacs/modules/ui/doom-dashboard/M-x_butterfly.png"))
  (when (file-exists-p splash-image)
    (setq fancy-splash-image splash-image)))

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
(use-package! heaven-and-hell
  :config
  (setq heaven-and-hell-theme-type 'dark) ;; Omit to use light by default
  (setq heaven-and-hell-themes
        '(
          (light . (modus-operandi))
          (dark . (ef-dream))
          )
        ) 
  (setq heaven-and-hell-load-theme-no-confirm t)
  :hook (after-init . heaven-and-hell-init-hook)
  :bind ("C-c t h" . heaven-and-hell-toggle-theme))

(setq confirm-kill-emacs nil)

(setq projectile-project-search-path '("~/projects/" ))
(setopt display-fill-column-indicator-column 100)

(use-package! python-mode 
  :hook (python-mode . display-fill-column-indicator-mode))

;; NEXTFLOW:

(use-package! nextflow-mode
  :config
  (set-docsets! 'nextflow-mode "Groovy")
  :init
  (add-hook 'nextflow-mode-hook #'lsp-deferred)
  )

(use-package! lsp-mode
  :config
  (setq lsp-nextflow-server-file "/home/alkc/.config/emacs/.local/etc/lsp/nextflow-language-server-26.04.0.jar")
  )


;; Connect to `main` workspace in new emacsclient sessions
(setq persp-emacsclient-init-frame-behaviour-override "main")

;; Use the docker compose plugin instead if docker-compose
(eval-after-load 'docker-compose
  '(setq docker-compose-command "docker compose"))

(use-package! nov
  :config
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
  )


;; MIXED KEYBINDS
;; TODO: rebind:
(global-set-key (kbd "M-n") 'forward-paragraph)
(global-set-key (kbd "M-p") 'backward-paragraph)

(after! vterm
  (add-to-list 'vterm-environment "EMACS_VTERM=1")

  ;; TODO: Sometimes opens non-login shell? W/O sourcing .bashrc + precious aliases
  (setq vterm-tramp-shells '(("docker" "sh")
                             ("ssh" "bash -l"))))


(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "C-<tab>") 'next-buffer)
(global-set-key (kbd "C-<iso-lefttab>") 'previous-buffer)

;; Free up C-'
(global-set-key (kbd "M-'") 'consult-imenu)

(use-package! avy
  :ensure t
  :init
  (define-key isearch-mode-map (kbd "C-'") 'avy-isearch)
  :bind (("C-ä"     . avy-goto-char      )
         ("C-'"     . avy-goto-char-2    )
         ("M-ä"     . avy-goto-char-timer)
         ("M-g g"   . avy-goto-line      )
         ("M-g M-g" . avy-goto-line      )
         ("M-g w"   . avy-goto-word-1    )
         ("M-g e"   . avy-goto-word-0    )
         ("M-g k r" . avy-kill-region    )
         )
  )

(with-eval-after-load 'gptel
  (setq gptel-backend (gptel-make-openai-oauth "OpenAI-sub"))
  (add-hook 'gptel-post-response-functions 'gptel-end-of-response)
  (add-hook 'gptel-post-stream-hook 'gptel-auto-scroll)
  )

(with-eval-after-load 'gptel-magit
  (setq gptel-magit-model "gpt-5.3-codex")
  )

(after! embark
  (keymap-set embark-general-map "?" #'gptel-quick)
  (keymap-set embark-identifier-map "o" #'xref-find-definitions-other-window)
  (keymap-set embark-file-map "SPC" #'view-file-other-window)
  )


(use-package! agent-shell
  :config
  (setq agent-shell-openai-authentication
        (agent-shell-openai-make-authentication :login t))
  :bind
  ("C-c o a" . agent-shell)
  )

;; Org:
(defun alkc/soppa ()
  "Dive straight into soup"
  (interactive)
  (find-file "~/org/soppa.org"))

(use-package! org
  :init
  (remove-hook! 'org-mode-hook #'display-line-numbers-mode)
  :bind
  ("C-c o s" . alkc/soppa)
  :config
  (require 'org-habit)
  (setq calendar-week-start-day 1)
  (setq org-archive-location  "./archive/%s_archive::")
  (setq org-default-notes-file     (concat org-directory "soppa.org"    ))
  (setq +org-capture-notes-file    (concat org-directory "soppa.org"    ))
  (setq +org-capture-todo-file     (concat org-directory "soppa.org"    ))
  (setq +org-capture-calendar-file (concat org-directory "calendar.org" ))
  (setq +org-capture-projects-file (concat org-directory "soppa.org"    ))
  (setq org-capture-templates
        '(("t" "TODO Inbox" entry (file+headline +org-capture-todo-file "Inbox")
           "* TODO %?\n%i" :prepend t)
          ("T" "TODO Inbox w/ link" entry (file+headline +org-capture-todo-file "Inbox")
           "* TODO %?\n%i\n%a" :prepend t)
          ("i" "IDEA Inbox" entry (file+headline +org-capture-todo-file "Inbox")
           "* IDEA %?\n%i" :prepend t)
          ("c" "Calendar" entry (file+headline +org-capture-calendar-file "Inbox")
           "* %?\n%i" :prepend t)
          ("n" "Personal notes" entry (file+headline +org-capture-notes-file "Inbox")
           "* %u %?\n%i" :prepend t)
          ("j" "Journal" entry (file+olp+datetree +org-capture-journal-file)
           "* %U %?\n%i" :prepend t)
          )
        ))


(after! ispell
  (let* ((my/ispell-dictionaries '("sv_SE" "en_US" "pl_PL"))
         (my/ispell-dictionary (mapconcat #'identity my/ispell-dictionaries ",")))
    (setq ispell-program-name "hunspell"
          ispell-really-hunspell t
          ispell-dictionary my/ispell-dictionary)
    (when (fboundp 'ispell-hunspell-add-multi-dic)
      (ispell-set-spellchecker-params)
      (let* ((available-dictionaries (mapcar #'car ispell-hunspell-dict-paths-alist))
             (installed-dictionaries
              (delq nil
                    (mapcar (lambda (dictionary)
                              (and (member dictionary available-dictionaries)
                                   dictionary))
                            my/ispell-dictionaries))))
        (setq ispell-dictionary (mapconcat #'identity installed-dictionaries ","))
        (when installed-dictionaries
          (ispell-hunspell-add-multi-dic ispell-dictionary))))))

(when (string= (system-name) "RS30211241")
  (load-file "/home/alkc/.local/SMD-dotfiles/work.el"))
(defun my/split-window-right-and-focus ()
  "Split the selected window to the right and move focus to the new window."
  (interactive)
  (split-window-right)
  (other-window 1))

(defun my/split-window-below-and-focus ()
  "Split the selected window below and move focus to the new window."
  (interactive)
  (split-window-below)
  (other-window 1))

(map!
 "C-x 2" #'my/split-window-below-and-focus
 "C-x 3" #'my/split-window-right-and-focus)

(defun my/magit-status-other-window ()
  (interactive)
  (my/split-window-right-and-focus)
  (let ((magit-window (selected-window)))
    (set-window-parameter magit-window 'magit-dedicated t)
    (magit-status)
    (let ((magit-buffer (current-buffer)))
      (add-hook 'kill-buffer-hook
                (lambda ()
                  (when (and (window-live-p magit-window)
                             (eq (window-buffer magit-window) magit-buffer))
                    (ignore-errors
                      (delete-window magit-window))))
                nil t))))

(after! magit
  (map! "C-x G" #'my/magit-status-other-window)  
  )

(after! project
  ;; Move the native project prefix from C-x p to C-x P, leaving C-x p
  ;; available for the built-in minibuffer switcher again.
  (define-key ctl-x-map (kbd "P") project-prefix-map)
  (define-key ctl-x-map (kbd "p") #'switch-to-minibuffer))
