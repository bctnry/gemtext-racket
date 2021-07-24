#lang racket/base
(require racket/string)
(require "defn.rkt")
(provide (all-defined-out))

(define (string->gmi v)
  (unless (string? v)
    (error "string->gmi: Argument is not a string"))
  (let ([res (list)]
        ;; pre bookkeeping
        [in-pre? #f]
        [pre-buffer (list)]
        [pre-alt ""]
        ;; list bookkeeping
        [in-list? #f]
        [list-buffer (list)])
    ;; too bad this kind of stuff is easier with imperative style.
    (for ([i (in-list (string-split v "\n" #:trim? #f))])
      (cond
        (in-pre?
         (if (string-prefix? i "```")
             (begin
               (set! in-pre? #f)
               (set! res (cons (gmi-pre (reverse pre-buffer) pre-alt) res))
               (set! pre-buffer (list)))
             (set! pre-buffer (cons i pre-buffer))))
        (else
         (when (and in-list? (not (string-prefix? i "* ")))
           (begin
               (set! in-list? #f)
               (set! res (cons (gmi-list (reverse list-buffer)) res))
               (set! list-buffer (list))))           
         (cond
           ((string-prefix? i "=>")
            ;; link.
            (let* ([i (string-trim (substring i 2))]
                   [url (car (string-split i))]
                   [alt (string-trim (substring i (string-length url)))])
              (set! res (cons (gmi-link url alt) res))))
           ((string-prefix? i "```")
            ;; pre.
            (let* ([alt (string-trim (substring i 3))])
              (set! in-pre? #t)
              (set! pre-alt alt)
              (set! pre-buffer (list))))
           ((string-prefix? i ">")
            ;; blockquotes.
            (set! res (cons (gmi-blockquote (string-trim (substring i 1))) res)))
           ((string-prefix? i "### ")
            ;; h3.
            (set! res (cons (gmi-heading 3 (string-trim (substring i 4) i)) res)))
           ((string-prefix? i "## ")
            ;; h2.
            (set! res (cons (gmi-heading 2 (string-trim (substring i 3) i)) res)))
           ((string-prefix? i "# ")
            ;; h1.
            (set! res (cons (gmi-heading 1 (string-trim (substring i 2) i)) res)))
           ((string-prefix? i "* ")
            ;; list.
            (if in-list?
                (set! list-buffer (cons (string-trim (substring i 2)) list-buffer))
                (let ([first-item-text (string-trim (substring i 2))])
                  (set! in-list? #t)
                  (set! list-buffer (list first-item-text)))))
           (else
            (set! res (cons i res)))))))
    (when (not (null? pre-buffer))
      (set! res (cons (gmi-pre (reverse pre-buffer) pre-alt) res)))
    (when (not (null? list-buffer))
      (set! res (cons (gmi-list (reverse list-buffer)) res)))
    (reverse res)))
                     