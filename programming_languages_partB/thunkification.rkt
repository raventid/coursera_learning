#lang racket
(define (my-mult x y-thunk)
  (cond [(= 0 x) 0]
        [(= 1 x) (y-thunk)]
        [#t (+ (y-thunk) (my-mult (- x 1) y-thunk))]))

;; With this function we are constructing promise and return mutable list with #f
;; means not evalu
(define (my-delay th)
  (mcons #f th)) ;; a one-of "type" we will update /in place/

(define (my-force p)
  (if (mcar p)
      (mcdr p)
      (begin (set-mcar! p #t)
             (set-mcdr! p ((mcdr p)))
             (mcdr p))))

(define x 0)

(println "First call")
; Let's use this stuff
; p for promise
; first we create p(promise)
(my-mult x (let ([p (my-delay (lambda  () (+ 3 4)))])
             (lambda () (my-force p))))