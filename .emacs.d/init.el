;;; load-path の設定
;; user-emacs-directoryが未定義な場合は追加
(when (> emacs-major-version 23)
  (defvar user-emacs-directory "~/.emacs.d"))

;; load-path追加関数の定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
              (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

;; load-pathの追加
(add-to-load-path "elisp" "conf" "repos")

;;; elpa の設定
(when (require 'package nil t)
  (add-to-list 'package-archives
               '("marmalade" . "http://marmalade-repo.org/packages/"))
  (add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/"))
  (package-initialize))


;; スタートアップメニューの非表示
(setq inhibit-startup-screen t)

;;; 環境変数
;; 文字コードの指定
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

;; 日本語ファイル名の扱い
(when (eq system-type 'darwin)
  (require 'ucs-normalize)
  (set-file-name-coding-system 'utf-8-hfs)
  (setq locale-coding-system 'utf-8-hfs)
 )

;;; キーバインドの設定
(global-set-key (kbd "C-m") 'newline-and-indent)
(global-set-key (kbd "C-c l") 'toggle-truncate-line)
(global-set-key (kbd "C-t") 'other-window)

;;; フレームの設定
;; タイトルにファイルのフルパスを表示
(setq frame-title-format "%f")

;; 行表示
(global-linum-mode t)
(setq linum-format "%5d")

;;; モードラインの設定
;; カラム数の表示
(column-number-mode t)
;; 行数の表示
;;(line-number-mode 0)
;; ファイルサイズの表示
(size-indication-mode t)
;; 時刻を24時間表記で表示
(setq display-time-24hr-format t)
(display-time-mode t)

;;; インデントの設定
;; タブの表示幅
(setq-default tab-width 4)
;; インデントにタブ文字を利用しない
(setq-default indent-tabs-mode nil)

;;; フェイスの設定
;; color-themeの設定
;; (when (require 'color-theme nil t)
;;   (color-theme-initialize)
;;   (color-theme-hober))

;;; フォントの設定
(when (eq window-system 'ns)
  (set-face-attribute 'default nil
					  :family "Menlo"
					  :height 120)
  
  (set-fontset-font
   nil 'japanese-jisx0208
   (font-spec :family "ヒラギノ明朝 Pro"))

  ;; (setq face-font-rescale-alist
  ;; 		'((".*Menlo.*" . 1.0)
  ;; 		  (".*Hiragino_Mincho_Pro.*" . 1.0)
  ;; 		  ("-cdac$" . 1.0)))
  )

;;; ハイライトの設定
;; 現在行
(defface my-hl-line-face
  '((((class color) (background dark))
     (:background "NavyBlue" t))
    (((class color) (background light))
     (:background "LightGoldenrodYellow" t))
    (t (:bold t)))
  "hl-line's my face")
(setq hl-line-face 'my-hl-line-face)
(global-hl-line-mode t)

;; 括弧
(setq show-paren-delay 0)
(show-paren-mode t)
(setq show-paren-style 'expression)
(set-face-background 'show-paren-match-face nil)
(set-face-underline-p 'show-paren-match-face "blue")

;;; バックアップファイルとオートセーブファイル設定
;; 各ファイルの作成場所
(add-to-list 'backup-directory-alist
             (cons "." "~/.emacs.d/backups/"))
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "~/.emacs.d/backups/") t)))

;; (setq auto-save-timeout 15)
;; (setq auto-save-interval 60)

;;; 拡張インストール
;; auto-installの設定
;; curl -O http://www.emacswiki.org/emacs/download/auto-install.el
(when (require 'auto-install nil t)
  (setq auto-install-directory "~/.emacs.d/elisp/")
  (auto-install-update-emacswiki-package-name t)
  ;; (setq url-proxy-services '(("http" . "localhost:8339")))
  (auto-install-compatibility-setup))

;; redo+.elの設定
(when (require 'redo+ nil t)
  (global-set-key (kbd "C-M-_") 'redo)
  (global-set-key (kbd "C-?") 'redo)
  )

;; anythingの設定
(when (require 'anything nil t)
  (setq
   anything-idle-delay 0.3
   anything-input-idle-delay 0.2
   anything-candidate-number-limit 100
   anything-quick-update t
   anything-enable-shortcuts 'alphabet)

  (when (require 'anything-config nil t)
    (setq anything-su-or-sudo "sudo"))

  (require 'anything-match-plugin nil t)

  (when (and (executable-find "cmigemo")
             (require 'migemo nil t))
    (require 'anything-migemo nil t))

  (when (require 'anything-complete nil t)
    (anything-lisp-complete-symbol-set-timer 150))

  (require 'anything-show-completion nil t)

  (when (require 'auto-install nil t)
    (require 'anything-auto-install nil t))

  (when (require 'descbinds-anything nil t)
    (descbinds-anything-install))
  )

;; M-yにanything-show-kill-ringを割り当て
(define-key global-map (kbd "M-y") 'anything-show-kill-ring)

;; anything-c-moccur
(when (require 'anything-c-moccur nil t)
  (setq
   anything-c-moccur-anything-idle-delay 0.1
   anything-c-moccur-higligt-info-line-flag t
   anything-c-moccur-enable-auto-look-flag t
   anything-c-moccur-enable-initial-pattern t)
  (global-set-key (kbd "C-M-o") 'anything-c-moccur-occur-by-moccur))

;; auto-complete
(when (require 'auto-complete-config nil t)
  ;; (setq ac-auto-show-menu 0.1)
  (add-to-list 'ac-dictionary-directories 
    "~/.emacs.d/elisp/ac-dict")
  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
  (ac-config-default))

;; color-moccur
(when (require 'color-moccur nil t)
  (define-key global-map (kbd "M-o") 'occur-by-moccur)
  (setq moccur-split-word t)
  (add-to-list 'dmoccur-exclusion-mask "\\.DS_Store")
  (add-to-list 'dmoccur-exclusion-mask "^#.+#$")
  (when (and (executable-find "cmigemo")
             (require 'migemo nil t))
    (setq moccur-use-migemo t)))

;; scala-mode
(when (require 'scala-mode-auto nil t)
  ;; (add-to-list 'auto-mode-alist '("\\.scala$" . scala-mode))
  ;; (add-hook 'scala-mode-hook
  ;; 			(lambda ()
  ;;  			  (define-key scala-mode-map (kbd "RET") 'newline-and-indent)
  ;;  			  ))
  )
