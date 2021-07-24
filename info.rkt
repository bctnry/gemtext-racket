#lang info
(define collection "gemtext")
(define deps '("base"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/gemtext.scrbl" ())))
(define pkg-desc "A text/gemini parser for Racket")
(define version "0.1")
(define pkg-authors '(bctnry))
