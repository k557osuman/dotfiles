(setq custom-file "~/.emacs.custom")
(load custom-file)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode 0)
(show-paren-mode 1)
(column-number-mode 1)
(global-display-line-numbers-mode)
(setq display-line-numbers-type 'relative)
(setq inhibit-startup-screen t)
(setq tab-bar-close-button-show nil
      tab-bar-show 1
      tab-bar-select-tab-modifiers '(meta)
      tab-bar-hints t)

(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

(pdf-tools-install) ; Standard activation command

(savehist-mode 1)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq package-enable-at-startup nil)
(straight-use-package 'el-patch)
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;; Straight Packages (Programming)
(straight-use-package 'javadoc-lookup)
(straight-use-package 'javadoc-help)

;; Straight Packages (Misc.)

(straight-use-package 's)
(straight-use-package 'dash)
(straight-use-package 'nov.el)
(straight-use-package 'doom-themes)
(straight-use-package 'visual-fill-column)
(straight-use-package 'dirvish)
(straight-use-package 'which-key)

(load-theme 'doom-dracula t)

(which-key-mode)

(dirvish-override-dired-mode t)

;; eww browser config


(defun mozilla-readability (start end)
  (shell-command-on-region start end "node /home/mrbeats/readability.js" nil t))

(use-package justify-kp
  :straight '(:type git :host github :repo "Fuco1/justify-kp"
                    :files (:defaults))
  )

(require 'justify-kp)
(setq nov-text-width 190)

(defun my-nov-window-configuration-change-hook ()
  (my-nov-post-html-render-hook)
  (remove-hook 'window-configuration-change-hook
               'my-nov-window-configuration-change-hook
               t))

(defun my-nov-post-html-render-hook ()
  (if (get-buffer-window)
      (let ((max-width (pj-line-width))
            buffer-read-only)
        (save-excursion
          (goto-char (point-min))
          (while (not (eobp))
            (when (not (looking-at "^[[:space:]]*$"))
              (goto-char (line-end-position))
              (when (> (shr-pixel-column) max-width)
                (goto-char (line-beginning-position))
                (pj-justify)))
            (forward-line 1))))
    (add-hook 'window-configuration-change-hook
              'my-nov-window-configuration-change-hook
              nil t)))

(add-hook 'nov-post-html-render-hook 'my-nov-post-html-render-hook)
