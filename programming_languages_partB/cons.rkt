#lang racket
(define x (cons 14 null))

(define y x)

; You can mutate x
(set! x 45)

; But you cannot mutate (cons x)
; It was possible in Scheme with a set-car! function.
; Racket do not support this behaviour
; But if you want, you can use another built-in type
(define mpr (mcons 1 (mcons #t "hi")))

(mcar mpr)
(mcdr mpr)

(set-mcdr! mpr 47) ; with mcons we can mutate cdr
(set-mcar! mpr 2) ; and car
