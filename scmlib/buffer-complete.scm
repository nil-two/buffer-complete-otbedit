(define (load-kusabashira-buffer-complete)
  (define (current-line)
    (editor-get-row-string (editor-get-cur-row)))

  (define (current-line-until-current-col)
    (substring (current-line) 0 (editor-get-cur-col)))

  (define (last-word str)
    (let ((m (rxmatch-substring (rxmatch #/[\w!?-]+$/ str))))
      (if (string? m) m "")))

  (define (current-word)
    (last-word (current-line-until-current-col)))

  (define (delete-current-word)
    (editor-backward-char (string-length (current-word)) #t)
    (editor-delete-selected-string))

  (define (get-all-words str)
    (let ((hash (make-hash-table 'string=?))
          (words '()))
      (regexp-replace-all
        #/[\w!?-]+/
        str
        (lambda (m)
          (hash-table-put! hash (rxmatch-substring m) #t)))
      (hash-table-for-each
        hash
        (lambda (k v)
          (set! words (cons k words))))
      words))

  (define (select-if proc ls)
    (let loop ((old-ls ls)
               (new-ls '()))
      (if (null? old-ls)
        (reverse new-ls)
        (loop (cdr old-ls)
              (if (proc (car old-ls))
                (cons (car old-ls) new-ls)
                new-ls)))))

  (define (has-prefix? str prefix)
    (let ((str-length (string-length str))
          (pre-length (string-length prefix)))
      (and
        (< pre-length str-length)
        (string=? prefix (substring str 0 pre-length)))))

  (define (get-possible-completion-list word)
    (select-if (lambda (s) (has-prefix? s word))
               (get-all-words (editor-get-all-string))))

  (define complete-now #f)
  (define complete-list '())
  (define target-word "")

  (app-set-event-handler
    "on-cursor-moved"
    (lambda ()
      (set! complete-now #f)))

  (define (buffer-complete)
    (app-status-bar-msg "")
    (cond
      ((not complete-now)
       (set! target-word (current-word))
       (set! complete-list (get-possible-completion-list (current-word)))))
    (delete-current-word)
    (cond
      ((null? complete-list)
       (editor-paste-string target-word)
       (set! complete-now #f))
      (else
        (editor-paste-string (car complete-list))
        (set! complete-list (cdr complete-list))
        (set! complete-now #t))))

  (define buffer-complete-key
    (if (symbol-bound? 'buffer-complete-key)
      buffer-complete-key
      "Ctrl+SPACE"))

  (app-set-key
    buffer-complete-key
    buffer-complete))

(load-kusabashira-buffer-complete)
