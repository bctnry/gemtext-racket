#lang scribble/manual
@require[@for-label[gemtext
                    racket/base]]

@title{gemtext: A text/gemini parser for Racket}
@author[(author+email "Sebastian René Higgins" "bctnry@outlook.com" #:obfuscate? #t)]

@defmodule[gemtext]

text/gemini is the markup language used by the @hyperlink["https://gemini.circumlunar.space/"]{Gemini protocol}.

@section{Datatypes}
@defstruct[gmi-link ([url string?] [text string?]) #:transparent]
@defstruct[gmi-heading ([level exact-positive-integer?] [text string?]) #:transparent]
@defstruct[gmi-list ([items (listof string?)]) #:transparent]
@defstruct[gmi-blockquote ([body string?]) #:transparent]
@defstruct[gmi-pre ([body (listof string?)] [alt string?]) #:transparent]

@defproc[(gmi-datum? [v any/c]) boolean?]{
 Defined as:
 @codeblock{
  (define (gmi-datum? v)
    (or (string? v)
        (gmi-link? v)
        (gmi-heading? v)
        (gmi-list? v)
        (gmi-blockquote? v)
        (gmi-pre? v)))
 }
}

@section{Parsing}

@defproc[(string->gmi [v string?]) (listof gmi-datum?)]{
 Parse a string into a list of text/gemini elements.
}

