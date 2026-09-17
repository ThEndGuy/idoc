;;; idoc-mode --- Major mode for idoc files

;;;###autoload
(define-derived-mode idoc-mode fundamental-mode "Idoc"
  "Major mode for idoc files"
  (setq-local font-lock-defaults '((idoc-font-lock-keywords))))


(defconst idoc-font-lock-keywords
  '(
    ;; Sections (keywords)
    ("\\_<\\([[:word:]_-]+\\):" 1 font-lock-keyword-face)
    ;; Booleans
    ("=[[:space:]]*\\(true\\|false\\)\\_>" 1 font-lock-keyword-face)
    ;; Comments
    ("#.*$" . font-lock-comment-face)
    ))


(add-to-list 'auto-mode-alist '("\\.idoc\\'" . idoc-mode))

(provide 'idoc-mode)
