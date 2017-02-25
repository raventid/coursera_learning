
#lang racket

(provide (all-defined-out)) ;; so we can put tests in a second file

;; put your code below

;; 1
(define (sequence low high stride)
  (if (<= low high)
      (cons low (sequence (+ low stride) high stride))
      null))

;; 2
(define (string-append-map xs suffix)
  (map (lambda(s) (string-append s suffix)) xs))

;; 3
(define (list-nth-mod xs n)
  (cond
    [(< n 0) (error "list-nth-mod: negative number")]
    [(null? xs) (error "list-nth-mod: empty list")]
    [#t (car (list-tail xs (remainder n (length xs))))]))

;; 4
(define (stream-for-n-steps s n)
  (if (= n 0)
      null
      (let ([evaluated-stream (s)])
        (cons (car evaluated-stream) (stream-for-n-steps (cdr evaluated-stream) (- n 1))))))
  
;; 5
(define funny-number-stream
  (letrec ([iterator
            (lambda(x) (cons (if (= 0 (remainder x 5)) (* -1 x) x) (lambda () (iterator (+ x 1)))))])
    (lambda () (iterator 1))))

;; 6
(define dan-then-dog
  (letrec ([iterator
            (lambda(x) (cons x (lambda () (iterator (if (string=? "dan.jpg" x) "dog.jpg" "dan.jpg")))))])
    (lambda () (iterator "dan.jpg"))))

;; 7
(define (stream-add-zero s)
    (lambda ()
      (let ([evaluated-stream (s)])
         (cons (cons 0 (car evaluated-stream)) (stream-add-zero (cdr evaluated-stream))))))
  
;; 8
(define (cycle-lists xs ys)
  (letrec ([iterator
         (lambda(n) (cons (cons (list-nth-mod xs n) (list-nth-mod ys n)) (lambda () (iterator (+ n 1)))))])
    (lambda () (iterator 0))))

;; 9
(define (vector-assoc v vec)
  (letrec ([max-ref (- (vector-length vec) 1)]
           [f (lambda (pos)
                (if (> pos max-ref)
                    #f
                    (let ([current (vector-ref vec pos)])
                      (if (and (pair? current) (equal? v (car current)))
                          current
                          (f (+ pos 1))))))])
    (f 0)))

;; 10
(define (cached-assoc xs n)
  (letrec ([memo (make-vector n #f)]
           [memo-insert-index 0]
           [update-memo-insert-index (lambda()
                                       (set! memo-insert-index
                                             (if (= (+ 1 memo-insert-index) n)
                                                 0
                                                 (+ 1 memo-insert-index))))]
           [f (lambda(x)
                (let ([cache-hit (vector-assoc x memo)])
                  (if cache-hit
                      cache-hit
                      (let ([result (assoc x xs)])
                        (if result
                            (begin
                              (vector-set! memo memo-insert-index result)
                              (update-memo-insert-index)
                              result)
                            #f)))))])
    f))

;; 11
(define-syntax while-less
  (syntax-rules (do)
    ((while-less x do y)
     (let ([z x])
       (letrec ([loop (lambda ()
                        (let ([w y])
                          (if (or (not (number? w)) (>= w z))
                              #t
                              (loop))))])
         (loop))))))