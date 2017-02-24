#lang racket
; Simplest stream that always returns number 1
; (define ones (lambda () (cons 1 ...))) - Stream is a thunk
; (define ones (lambda () (cons 1 (lambda () (cons 1 ...))) - Stream will return 1 and give us thunk that return 1
; Whoops...
; It's a bad idea. How to fix this?
; Where to get a thunk which return 1 and thunk, which return 1?
(define ones (lambda () (cons 1 ones))) ; it was here. We just need to return ourself!!!

; More complex stream
; 1 2 3 4 5 6 7 ...
(define (f x) (cons x (lambda () (f (+ x 1))))) ; f is a helper function which accepts initial num and returns
; cons with it, and also returns thunk
(define natural-numbers (lambda () (f 1)))

; 2 4 8 16 ...
(define powers-of-two
  (letrec ([f (lambda (x) (cons x (lambda () (f (* x 2)))))])
    (lambda () (f 2))))

; So stream is a thunk which return pair