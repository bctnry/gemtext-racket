#lang racket/base
(provide (all-defined-out))

(struct gmi-link (url text)
  #:guard (λ (url text name)
            (unless (and (string? url) (string? text))
              (error "Wrong argument types for gmi-link"))
            (values url text))
  #:extra-constructor-name make-gmi-link
  #:transparent)

(struct gmi-heading (level text)
  #:guard (λ (level text name)
            (unless (and (exact-positive-integer? level)
                         (>= level 1)
                         (<= level 6)
                         (string? text))
              (error "Wrong argument types for gmi-heading"))
            (values level text))
  #:extra-constructor-name make-gmi-heading
  #:transparent)

(struct gmi-list (items)
  #:guard (λ (items name)
            (unless (and (list? items))
              (error "Wrong argument types for gmi-list"))
            (values items))
  #:extra-constructor-name make-gmi-list
  #:transparent)

(struct gmi-blockquote (body)
  #:guard (λ (body name)
            (unless (and (string? body))
              (error "Wrong argument types for gmi-blockquote"))
            (values body))
  #:extra-constructor-name make-gmi-blockquote
  #:transparent)

(struct gmi-pre (body alt)
  #:guard (λ (body alt name)
            (unless (and (list? body)
                         (string? alt))
              (error "Wrong argument types for gmi-pre"))
            (values body alt))
  #:extra-constructor-name make-gmi-pre
  #:transparent)

(define (gmi-datum? v)
  (or (string? v)
      (gmi-link? v)
      (gmi-heading? v)
      (gmi-list? v)
      (gmi-blockquote? v)
      (gmi-pre? v)))
