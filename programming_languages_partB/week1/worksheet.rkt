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

(define (sum2 xs)
  (if (null? xs)
      0
      (if (number? (car xs))
          (+ (car xs) (sum2 (cdr xs)))
          (if (list? (car xs))
              (+ (sum2 (car xs)) (sum2 (cdr xs)))
              (sum2 (cdr xs))))))

(define (sum3 xs)
  (cond [(null? xs) 0]
        [(number? (car xs)) (+ (car xs) (sum3 (cdr xs)))]
        [#t (+ (sum3 (car xs)) (sum3 (cdr xs)))]))

(define (sum4 xs)
  (cond [(null? xs) 0]
        [(number? (car xs)) (+ (car xs) (sum4 (cdr xs)))]
        [(list? (car xs)) (+ (sum4 (car xs)) (sum4 (cdr xs)))]
        [#t (sum4 (cdr xs))]))

(define (max-of-list xs)
  (cond [(null? xs) (error "max-of-list given empty list")]
        [(null? (cdr xs)) (car xs)]
        [#t (let ([tlans (max-of-list (cdr xs))])
              (if (> tlans (car xs))
                  tlans
                  (car xs)))]))

; Be carefull with top level bindings
(define b 3)

; We can make local copy of 'b' to avoid someones set!
(define f
  (let ([b b])
    (lambda (x) (* 1 (+ x b)))))

; car is #1 , cdr is #2
(define pr (cons 1 (cons #t "hi"))) ; inproper list (pair)

(define lst (cons 1 (cons #t (cons "hi" null)))) ; proper list (list)
