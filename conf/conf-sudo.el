;; 用sudo 打开当前编辑的文件或目录
(global-set-key (kbd "C-c o") 'toggle-read-only-file-with-sudo)

;;; 当切换到root 用户时，为作区别 ，外观显红色

(defface toggle-to-root-header-face
  '((t (:foreground "white" :background "red3")))
  "*Face use to display header-lines for files opened as root."
    :group 'emacs)

;;when open a file with sudo ,then change the face of the file to waring
(defun toggle-to-root-header-warning ()
  "*Display a warning in header line of the current buffer.
   This function is suitable to add to `toggle-to-root-hook'."
  (let* ((warning "WARNING: EDITING FILE AS ROOT!")
         (space (+ 6 (- (window-width) (length warning))))
         (bracket (make-string (/ space 5) ?-))
         (warning (concat bracket bracket warning bracket bracket bracket )))
    (setq header-line-format
          (propertize  warning 'face 'toggle-to-root-header-face))))

;;; 加载一个新文件时，如果是sudo 开头的文件 ，也加上红色的外观
(defun my-sudo-find-file-hook ()
  (if (string-match "^/sudo:\\||sudo" (or (buffer-file-name)  dired-directory)) (toggle-to-root-header-warning))
  (when (or (string-match "^/etc" (or (buffer-file-name)  dired-directory))
            (string-match "^/private/etc" (or (buffer-file-name)  dired-directory)))
    (find-alternate-file (concat "/sudo:root@" (get-localhost-name) ":" (or (buffer-file-name)  dired-directory)))))

(add-hook 'find-file-hooks 'my-sudo-find-file-hook);; find-file-hooks 是加载完file 之后调用的一个hook
(add-hook 'dired-mode-hook 'my-sudo-find-file-hook) ;;

(provide 'conf-sudo)

;; Local Variables:
;; coding: utf-8
;; End:

;;; conf-sudo.el ends here.
