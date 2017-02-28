#lang racket
; This file is not going to be a valid racket code
; it's more like kitchen sink for homework
; ATTENTION!!! ATTENTION!!! ATTENTION!!!
;(define (eval-under-env e env)
;  (cond ...
;   ))

(struct hello (e) #:transparent)

; How to implement closure?
; Pretty straightforward, save env inside of a function
(struct closure (env fun) #:transparent)