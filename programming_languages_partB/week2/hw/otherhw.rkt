
#lang racket

(provide (all-defined-out)) ;; so we can put tests in a second file

;; put your code below

(define (sequence low high stride)
  (if(> low high)
     null
     (cons low (sequence (+ low stride) high stride))))

(define (string-append-map xs suffix)
  (map (lambda (i) (string-append i suffix)) xs))

(define (list-nth-mod xs n)
  (cond [(< n 0) (error "list-nth-mod: negative number")]
        [(empty? xs) (error "list-nth-mod: empty list")]
        [#t (car (list-tail xs (remainder n (length xs))))]))

(define (stream-for-n-steps s n)
    (if (= n 0)
        null
        (cons (car (s)) (stream-for-n-steps (cdr (s)) (- n 1)))))

(define funny-number-stream
  (letrec ([f (lambda (x) (cons (if(= 0 (remainder x 5)) (- x) x) (lambda () (f (+ x 1)))))])
    (lambda () (f 1))))

(define dan-then-dog
  (letrec ([dan (lambda () (cons "dan.jpg" dog))]
           [dog (lambda () (cons "dog.jpg" dan))])
    dan))
              

(define (stream-add-zero s)
  (letrec ([f (lambda(st) (cons (cons 0 (car st)) (lambda() (f ((cdr st))))))])
    (lambda () (f (s)))))

(define (cycle-lists xs ys)
  (letrec ([f (lambda (n)
                (cons (cons (list-nth-mod xs n) (list-nth-mod ys n))
                      (lambda () (f (+ n 1)))))])
    (lambda () (f 0))))

(define (vector-assoc v vec)
  (letrec ([le (vector-length vec)]
           [f (lambda(n)
               (if(= n le)
                  #f
                  (let ([el (vector-ref vec n)])
                    (if(pair? el)
                       (if(equal? (car el) v) el (f (+ n 1)))
                       (f (+ n 1))))))])
    (f 0)))

(define (cached-assoc xs n)
  (letrec ([memo (make-vector n #f)]
           [i 0])
           (lambda (v)
                (let ([ans (vector-assoc v memo)])
                  (if ans
                      ans
                      ( let ([new-ans (assoc v xs)])
                             (begin
                               (vector-set! memo i new-ans)
                               (set! i (remainder (+ i 1) n))
                               new-ans)
                             ))))))
