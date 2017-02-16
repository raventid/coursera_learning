#lang racket

(provide (all-defined-out))

(define xs (list 4 5 6))
(define ys (list (list 1 2) 3 4))

(define (sum1 xs)
  (if (null? xs)
      0
      (if (number? (car xs))
          (+ (car xs) (sum1 (cdr xs)))
          (+ (sum1 (car xs)) (sum1 (cdr xs))))))