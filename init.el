;**************************************************
;;
;;                  関数定義
;;
;;**************************************************

;;--------------------------------------------------
;; ロードパスを追加
;;--------------------------------------------------
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
	      (expand-file-name (concat user-emacs-directory path))))
	(add-to-list 'load-path default-directory)

	    (normal-top-level-add-subdirs-to-load-path)))))

;;--------------------------------------------------
;; カーソル位置のフェイスを調べる
;;--------------------------------------------------
(defun describe-face-at-point()
"Return face used at point."
(interactive)
(message "%s" (get-char-property(point)'face)))

;;--------------------------------------------------
;; perl-completionモードのフック
;;--------------------------------------------------
(defun perl-completion-hook ()
  (when (require 'perl-completion nil t)
	(perl-completion-mode t)
	(when (require 'auto-complete nil t)
	  (auto-complete-mode t)
	  (make-variable-buffer-local 'ac-sources)
	  (setq ac-sources
			'(ac-source-perl-copletion)))))


;;**************************************************
;
;;                キーバインド
;;
;;**************************************************

;;--------------------------------------------------
;; backspace
;;--------------------------------------------------
(define-key global-map (kbd "C-h") 'delete-backward-char)

;;--------------------------------------------------
;; 画面きりかえ
;;--------------------------------------------------
(define-key global-map (kbd "M-<tab>") 'other-window)

;;--------------------------------------------------
;; コメントアウト/解除
;;--------------------------------------------------
(define-key global-map (kbd "C-;") 'comment-dwim)

;;--------------------------------------------------
;; バックスラッシュを入力
;;--------------------------------------------------
(define-key global-map [?\M-¥]"\\")

;;--------------------------------------------------
;; tabを入力
;;--------------------------------------------------
(define-key global-map (kbd "C-i") '(lambda ()
				      (interactive)
				      (insert "\t")))


;;**************************************************
;;
;;                  一般設定
;;
;;**************************************************

;;--------------------------------------------------
;; 引数のディレクトリとそのサブディレクトリをロードパスに追加
;;--------------------------------------------------
(add-to-load-path "elisp" "conf" "public_repos")

;;--------------------------------------------------
;; ELPA
;;--------------------------------------------------
(when (require 'package nil t)
  ;; パッケージリポジトリにMarmaladeと開発者運営のELPAを追加
  (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
  (add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/"))
  ;; インストールしたパッケージにロードパスを通して読み込む
  (package-initialize))

;;--------------------------------------------------
;; フォント
;;--------------------------------------------------
(set-face-attribute 'default nil
                    :family "Ricty Discord"
                    :height 160)
(set-fontset-font
nil 'japanese-jisx0208
(font-spec :family "Ricty Discord"))

;;--------------------------------------------------
;; モードライン
;;--------------------------------------------------
;; カラム番号も表示
(column-number-mode t)

;; ファイルサイズを表示
(size-indication-mode t)

;; 時計を表示
(setq display-time-string-forms '((format
  "%s/%s(%s) %s:%s" month day dayname 24-hours minutes)))
(display-time-mode t)

;; バッテリー残量を表示
;; (display-battery-mode t)

;;--------------------------------------------------
;; 起動時
;;--------------------------------------------------
;; スタートアップ非表示
(setq inhibit-startup-screen t)

;; 起動時基本設定
(setq default-frame-alist
  (append (list
    '(cursor-type . bar)       ;; カーソルタイプ
    '(cursor-color . "yellow") ;; カーソルの色
    )default-frame-alist)
)

;; 起動時にフルスクリーン
(add-hook 'window-setup-hook 'ns-toggle-fullscreen)

;; 起動時にシェルを立ち上げる
(add-hook 'window-setup-hook 'multi-term)

;;--------------------------------------------------
;; その他
;;--------------------------------------------------
;; タイトルバーにファイルのフルパスを表示
(setq frame-title-format "%f")

;; 行番号を常に表示する
(global-linum-mode t)
;; 行番号フォーマット
(setq linum-format "%4d")

;; インデントにタブ文字を使用しない
(setq-default indent-tabs-mode t)
;; タブ幅
(setq-default tab-width 4)

;; 対応する括弧を強調して表示する
(show-paren-mode t) ; 有効化
(setq show-paren-delay 0) ; 表示までの秒数。初期値は0.125
;; 括弧のみ強調表示
(setq show-paren-style 'parenthsis)

;; scratchの初期メッセージを消去
(setq initial-scratch-message "")

;; ツールバー非表示
(tool-bar-mode -1)

;; エラー時の通知を消去
(setq ring-bell-function 'ignore)

;; (yes/no)を(y/n)に
(fset 'yes-or-no-p 'y-or-n-p)

;; バックアップファイルとオートセーブファイルを~/.emacs.d/backups/へ集める
(setq backup-directory-alist
	  (cons (cons ".*" (expand-file-name "~/.emacs.d/backups"))
			backup-directory-alist))
(setq auto-save-file-name-transforms
	  `((".*" ,(expand-file-name "~/.emacs.d/backups/") t)))


;;**************************************************
;;
;;                   拡張機能
;;
;;**************************************************

;;--------------------------------------------------
;; auto-install
;;--------------------------------------------------
;;(when (require 'auto-install nil t)
;;  ;; インストールディレクトリを設定する 初期値は~/.emacs.d/auto-install/
;;  (setq auto-install-directory "~/.emacs.d/elisp/")
;;  ;; EmacsWikiに登録されているelispの名前を取得する
;;  (auto-install-update-emacswiki-package-name t)
;;  ;; 必要であればプロキシの設定を行う
;;  ;; (setq url-proxy-services '(("http" . "localhost:8339")))
;;  ;; install-elispの関数を利用可能にする
;;  (auto-install-compatibility-setup))

;;--------------------------------------------------
;; color-theme
;;--------------------------------------------------
;; (when (require 'color-theme nil t)
;;   ;; テーマを読み込むための設定
;;   (color-theme-initialize))

;;--------------------------------------------------
;; anything
;;--------------------------------------------------
(when (require 'anything nil t)

  (setq
   ;; 候補を表示するまでの時間。デフォルトは0.5
   anything-idle-delay 0.3
   ;; タイプして再秒がするまでの時間。デフォルトは0.1
   anything-input-idle-delay 0.2
   ;; 候補の最大表示数。デフォルトは50
   anything-candidate-number-limit 100
   ;; 候補が多いときに体感速度を速くする
   anything-quick-update t
   ;; 選択候補ショートカットをアルファベットに
   anything-enable-shortcuts 'alphabet)

  (when (require 'anything-config nil t)
	;; ルート権限でアクションを実行するときのコマンド
	;; デフォルトは"su"
	(setq anything-su-or-sudo "sudo"))

  (require 'anything-match-plugin nil t)

  (when (and (executable-find "cmigemo")
			 (require 'migemo nil t))
	(require 'anything-migemo nil t))

  (when (require 'anything-complete nil t)
	;; lispシンボルの保管候補の再建策時間
	(anything-lisp-complete-symbol-set-timer 150))

  (require 'anything-show-complete nil t)

  (when (require 'auto-install nil t)
	(require 'anything-auto-install nil t))

  (when (require 'descbinds-anything nil t)
  	;; describe-bindingsをAnythingに置き換える
  	(descbinds-anything-install)))

;;--------------------------------------------------
;; auto-complete
;;--------------------------------------------------
(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-dictionary-directories
    "~/.emacs.d/elisp/ac-dict")
  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
  (ac-config-default))

;;--------------------------------------------------
;; multi-term
;;--------------------------------------------------
(when (require 'multi-term nil t)
  ;; 使用するシェルを指定
  (setq multi-term-program "/bin/bash"))

;; 文字コードを設定
(set-language-environment 'utf-8)
(prefer-coding-system 'utf-8)
(setq file-name-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)

;; multi-termのフック
(add-hook 'term-mode-hook
		  '(lambda ()
			 (define-key term-raw-map (kbd "C-h") 'term-send-backspace)
			 (define-key term-raw-map (kbd "C-p") 'term-send-up)
			 (define-key term-raw-map (kbd "C-n") 'term-send-down)))

;;--------------------------------------------------
;; flymake
;;--------------------------------------------------
(require 'flymake)

;; set-perl5lib
;; 開いたスクリプトのパスに応じて、@INCにlibを追加してくれる
;; 以下からダウンロードする必要あり
;; http://svn.coderepos.org/share/lang/elisp/set-perl5lib/set-perl5lib.el
(require 'set-perl5lib)

;; エラー、ウォーニング時のフェイス
(set-face-background 'flymake-errline nil)
(set-face-underline 'flymake-errline "red")
(set-face-background 'flymake-warnline nil)
(set-face-underline 'flymake-warnline "orange")

;; エラーをミニバッファに表示
;; http://d.hatena.ne.jp/xcezx/20080314/1205475020
(defun flymake-display-err-minibuf ()
  "Displays the error/warning for the current line in the minibuffer"
  (interactive)
  (let* ((line-no             (flymake-current-line-no))
         (line-err-info-list  (nth 0 (flymake-find-err-info flymake-err-info line-no)))
         (count               (length line-err-info-list)))
    (while (> count 0)
      (when line-err-info-list
        (let* ((file       (flymake-ler-file (nth (1- count) line-err-info-list)))
               (full-file  (flymake-ler-full-file (nth (1- count) line-err-info-list)))
               (text (flymake-ler-text (nth (1- count) line-err-info-list)))
               (line       (flymake-ler-line (nth (1- count) line-err-info-list))))
          (message "[%s] %s" line text)))
      (setq count (1- count)))))
;; Perl用設定
;; http://unknownplace.org/memo/2007/12/21#e001
(defvar flymake-perl-err-line-patterns
  '(("\\(.*\\) at \\([^ \n]+\\) line \\([0-9]+\\)[,.\n]" 2 3 nil 1)))

(defconst flymake-allowed-perl-file-name-masks
  '(("\\.pl$" flymake-perl-init)
    ("\\.pm$" flymake-perl-init)
    ("\\.t$" flymake-perl-init)))

(defun flymake-perl-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list "perl" (list "-wc" local-file))))

(defun flymake-perl-load ()
  (interactive)
  (defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
    (setq flymake-check-was-interrupted t))
  (ad-activate 'flymake-post-syntax-check)
  (setq flymake-allowed-file-name-masks (append flymake-allowed-file-name-masks flymake-allowed-perl-file-name-masks))
  (setq flymake-err-line-patterns flymake-perl-err-line-patterns)
  (set-perl5lib)
  (flymake-mode t))

(add-hook 'cperl-mode-hook 'flymake-perl-load)

;;--------------------------------------------------
;; html-mode
;;--------------------------------------------------
(add-hook 'html-mode-hook
		  '(lambda ()
			 (set-face-foreground 'font-lock-function-name-face "DodgerBlue")))

;;--------------------------------------------------
;; html-helper-mode
;;--------------------------------------------------
(autoload 'html-helper-mode "html-helper-mode" "Yay HTML" t)
;; HTML編集のデフォルトモードをhtml-helper-modeにする
;;(setq auto-mode-alist (cons '("\\.html$" . html-helper-mode) auto-mode-alist))
(setq html-helper-item-continue-indent 2)
(setq html-helper-basic-offset 2)
;; html-helper-modeのフック
(add-hook 'html-helper-mode-hook
          '(lambda ()
		    (set-face-foreground 'html-tag-face "RoyalBlue")
			(set-face-bold-p 'html-tag-face nil)))

;;--------------------------------------------------
;; web-mode
;;--------------------------------------------------
(when (require 'web-mode nil t)  
  (setq auto-mode-alist (cons '("\\.html$" . web-mode) auto-mode-alist))
  (set-face-foreground 'web-mode-html-tag-face "DodgerBlue")
  (set-face-foreground 'web-mode-doctype-face "DodgerBlue")
  (set-face-foreground 'web-mode-html-attr-name-face "orange"))

;;--------------------------------------------------
;; js2-mode
;;--------------------------------------------------
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; js2-modeのフック
(add-hook 'js2-mode-hook
          '(lambda ()
			(set-face-foreground 'js2-function-param "white")
			(set-face-foreground 'js2-external-variable "white")
			(set-face-foreground 'js2-jsdoc-tag "green")
			(set-face-foreground 'js2-jsdoc-type "green")
			(set-face-foreground 'js2-jsdoc-value "green")
			(set-face-foreground 'js2-error nil)
			(set-face-underline 'js2-error "red")))

;;--------------------------------------------------
;; cperl-mode
;;--------------------------------------------------
(defalias 'perl-mode 'cperl-mode)
;; インデント設定
(setq cperl-indent-level 4
	  cperl-continued-statement-offset 4
	  cperl-brace-offset -4
	  cperl-label-offset -4
	  cperl-indent-parens-as-block t
	  cperl-close-paren-offset -4
	  cperl-tab-always-indent t
	  cperl-highlight-variables-indiscriminately t
	  cperl-comment-column 40)
;; cperl-modeのフック
(add-hook 'cperl-mode-hook
          '(lambda ()
		    (set-face-foreground 'cperl-nonoverridable-face "purple1")
			(set-face-foreground 'cperl-array-face "white")
			(set-face-foreground 'cperl-hash-face "white")
			(set-face-background 'cperl-array-face "black")
			(set-face-background 'cperl-hash-face "black")
			(set-face-underline-p 'underline nil)
			(setq indent-tabs-mode nil)
			(perl-completion-hook)))

;;--------------------------------------------------
;; color-moccur
;;--------------------------------------------------
(when (require 'color-moccur nil t)
  ;; M-oにoccuurを割り当て
  (define-key global-map (kbd "M-o") 'occur-by-moccur)
  ;; スペース区切りでAND検索
  (setq moccur-split-word t)
  ;; ディレクトリ検索のとき除外するファイル
  ;;(add-to-list 'dmoccur-exclusion-mask "¥¥.DS_Store")
  ;;(add-to-list 'dmoccur-exclusion-mask "^#.+#$")
  ;; Migemoを利用できる環境であばMigemoを使う
  (when (and (executable-find "cmigemo")
             (require 'migemo nil t))
    (setq moccur-use-migemo t)))

;;--------------------------------------------------
;; moccur-edit
;;--------------------------------------------------
(require 'moccur-edit nil t)

;;--------------------------------------------------
;; wgrep
;;--------------------------------------------------
(require 'wgrep nil t)

;;--------------------------------------------------
;; tabbar
;;--------------------------------------------------
(when (require 'tabbar nil t)
  (tabbar-mode t)
  ;; マウスホイール無効
  (tabbar-mwheel-mode -1)
  ;; グループ化無効
  (setq tabbar-buffer-groups-function nil)
  ;;
  (setq tabbar-auto-scroll-flag nil)
  ;; 左に表示されるボタンを削除
  (dolist (btn ' (tabbar-buffer-home-button
				  tabbar-scroll-left-button
				  tabbar-scroll-right-button))
	(set btn (cons (cons "" nil)
				   (cons "" nil))))
  ;; タブ間の長さ
  (setq tabbar-separator '(1.5))
  ;; 色設定
  (set-face-attribute
   'tabbar-default nil
   :background "blak")
  (set-face-attribute
   'tabbar-selected nil
   :foreground "yellow"
   :background "black"
   :weight 'bold
   :box nil
   :height 1.05)
  (set-face-attribute
   'tabbar-unselected nil
   :foreground "gray25"
   :background "black"
   :weight 'normal
   :box nil)
  ;; キーバインド
  (define-key global-map (kbd "C-<tab>") 'tabbar-forward-tab)
  (define-key global-map (kbd "C-S-<tab>") 'tabbar-backward-tab)
  )


;;**************************************************
;;
;;                  色設定
;;
;;**************************************************

;;--------------------------------------------------
;; 文字色
;;--------------------------------------------------
(add-to-list 'default-frame-alist '(foreground-color . "white"))
(set-face-foreground 'font-lock-comment-face "green")
(set-face-foreground 'font-lock-string-face "red")
(set-face-foreground 'font-lock-constant-face "red")
(set-face-foreground 'font-lock-keyword-face "DodgerBlue")
(set-face-foreground 'font-lock-function-name-face "orange")
(set-face-foreground 'font-lock-variable-name-face "white")
(set-face-foreground 'font-lock-type-face "white")
(set-face-foreground 'font-lock-builtin-face "white")
(set-face-foreground 'font-lock-constant-face "white")
(set-face-foreground 'font-lock-warning-face "white")
(set-face-foreground 'font-lock-doc-face "green")
(set-face-foreground 'show-paren-match-face "black")
;; (set-face-foreground 'show-paren-mismatch "white")
(set-face-foreground 'show-paren-mismatch "black")
(set-face-foreground 'lazy-highlight "yellow")
(set-face-foreground 'isearch "yellow")
(set-face-foreground 'isearch-fail "red")
(set-face-foreground 'ac-candidate-mouse-face "black")
(set-face-foreground 'ac-selection-face "black")
(set-face-foreground 'mode-line-inactive "gray25")
(set-face-foreground 'show-paren-mismatch "black")

;;--------------------------------------------------
;; 背景色
;;--------------------------------------------------
(add-to-list 'default-frame-alist '(background-color . "black"))
(set-face-background 'font-lock-comment-face "black")
(set-face-background 'font-lock-string-face "black")
(set-face-background 'font-lock-keyword-face "black")
(set-face-background 'font-lock-function-name-face "black")
(set-face-background 'font-lock-variable-name-face "black")
(set-face-background 'font-lock-type-face "black")
(set-face-background 'font-lock-builtin-face "black")
(set-face-background 'font-lock-constant-face "black")
(set-face-background 'font-lock-warning-face "black")
(set-face-background 'show-paren-match-face "gray70")
;; (set-face-background 'show-paren-mismatch "purple")
(set-face-background 'show-paren-mismatch "red4")
(set-face-background 'region "SkyBlue4")
(set-face-background 'lazy-highlight "black")
(set-face-background 'isearch "black")
(set-face-background 'isearch-fail "black")
(set-face-background 'ac-candidate-mouse-face "LightSkyBlue4")
(set-face-background 'ac-selection-face "LightSkyBlue3")
(set-face-background 'popup-tip-face "DarkGray")
(set-face-background 'mode-line "gray50")
(set-face-background 'mode-line-inactive "gray10")

;;--------------------------------------------------
;; 太字
;;--------------------------------------------------
(set-face-bold-p 'show-paren-match-face t)
(set-face-bold-p 'isearch t)
(set-face-bold-p 'isearch-fail t)
(set-face-bold-p 'ac-candidate-mouse-face t)
(set-face-bold-p 'ac-selection-face t)
(set-face-bold-p 'mode-line t)
;; (set-face-bold-p 'show-paren-mismatch t)

;;--------------------------------------------------
;; 下線
;;--------------------------------------------------
(set-face-underline-p 'isearch t)
;; (set-fae-underline-p 'show-paren-mismatch t)

;;--------------------------------------------------
;; その他
;;--------------------------------------------------
(set-face-attribute 'mode-line-inactive
nil :box nil)

;;--------------------------------------------------
;; シェル
;;--------------------------------------------------
(custom-set-variables
'(term-default-fg-color "white")
'(term-default-bg-color "black"))
