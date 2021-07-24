#lang racket/base

(module+ test
  (require rackunit))

(require "defn.rkt")
(provide (all-from-out "defn.rkt"))
(require "parser.rkt")
(provide (all-from-out "parser.rkt"))

(module+ test
  ;; Any code in this `test` submodule runs when this file is run using DrRacket
  ;; or with `raco test`. The code here does not run when this file is
  ;; required by another module.

  (test-case
   "links"
   (check-equal?
    (gmi-link-url (car (string->gmi "=> abc/def/ghi.txt")))
    "abc/def/ghi.txt")
   (check-equal?
    (gmi-link-text (car (string->gmi "=> abc/def/ghi.txt")))
    "")
   (check-equal?
    (gmi-link-text (car (string->gmi "=> abc/def/ghi.txt A useful title")))
    "A useful title")
   )

  (test-case
   "headings"
   (check-equal?
    (gmi-heading-level (car (string->gmi "### abc")))
    3)
   (check-equal?
    (gmi-heading-level (car (string->gmi "## abc")))
    2)
   (check-equal?
    (gmi-heading-level (car (string->gmi "# abc")))
    1)
   (check-equal?
    (gmi-heading-text (car (string->gmi "### abc")))
    "abc")
   (check-equal?
    (gmi-heading-text (car (string->gmi "## abc")))
    "abc")
   (check-equal?
    (gmi-heading-text (car (string->gmi "# abc")))
    "abc")
   (check-false
    (gmi-heading? (car (string->gmi "#not a heading"))))
   )

  (test-case
   "blockquotes"
   (check-equal? (gmi-blockquote-body (car (string->gmi ">nihao")))
                 "nihao")
   (check-equal? (gmi-blockquote-body (car (string->gmi "> nihao")))
                 "nihao")
   
   (check-equal? (gmi-blockquote-body (car (string->gmi ">         nihao")))
                 "nihao")
   )

  (test-case
   "pre"
   (check-equal? (gmi-pre-alt (car (string->gmi "``` test\nnihao\n```")))
                 "test")
   (check-equal? (gmi-pre-alt (car (string->gmi "```  \nnihao\n```")))
                 "")
   (check-equal? (gmi-pre-body (car (string->gmi "``` test\nnihao\n```")))
                 (list "nihao"))
   (check-equal? (gmi-pre-body (car (string->gmi "``` test\nnihao\n  nihao\nnihao\n```")))
                 (list "nihao" "  nihao" "nihao"))
   )

  (test-case
   "list"
   (check-equal? (gmi-list-items (car (string->gmi "* dsfds1\n* dsfds2\ndsfdsf\ndsfds")))
                 (list "dsfds1"
                       "dsfds2"))
   )

  (test-case
   "combined"
   (let ([res (string->gmi (string-append
                            "# heading1\n#notheading\n## heading2\n### heading3\n"
                            "paragraph1\n    paragraph2\n"
                            "* listitem1\n* listitem2\n * notlistitem\n"
                            "``` alt-text-here\npreserve\n spaces\n  and\n\ttabs\n```\n"
                            "> blockquote1\n>blockquote2\n"
                            ))])
     (check-true (gmi-heading? (list-ref res 0)))
     (check-equal? (gmi-heading-level (list-ref res 0)) 1)
     (check-equal? (gmi-heading-text (list-ref res 0)) "heading1")

     (check-false (gmi-heading? (list-ref res 1)))
     (check-true (string? (list-ref res 1)))
     
     (check-true (gmi-heading? (list-ref res 2)))
     (check-equal? (gmi-heading-level (list-ref res 2)) 2)
     (check-equal? (gmi-heading-text (list-ref res 2)) "heading2")
     
     (check-true (gmi-heading? (list-ref res 3)))
     (check-equal? (gmi-heading-level (list-ref res 3)) 3)
     (check-equal? (gmi-heading-text (list-ref res 3)) "heading3")
     
     (check-true (string? (list-ref res 4)))
     (check-true (string? (list-ref res 5)))
     (check-equal? (list-ref res 5) "    paragraph2")

     (check-true (gmi-list? (list-ref res 6)))
     (check-equal? (length (gmi-list-items (list-ref res 6))) 2)

     (check-true (string? (list-ref res 7)))
     (check-equal? (list-ref res 7) " * notlistitem")
     
     (check-true (gmi-pre? (list-ref res 8)))
     (check-equal? (gmi-pre-alt (list-ref res 8)) "alt-text-here")
     (check-equal? (gmi-pre-body (list-ref res 8))
                   (list "preserve"
                         " spaces"
                         "  and"
                         "\ttabs"))

     (check-true (gmi-blockquote? (list-ref res 9)))
     (check-equal? (gmi-blockquote-body (list-ref res 9))
                   "blockquote1")
     
     (check-true (gmi-blockquote? (list-ref res 10)))
     (check-equal? (gmi-blockquote-body (list-ref res 10))
                   "blockquote2")
     )
   )
  )

