#lang racket
(define fibonacci
  (letrec ([memo null] ;;list of pairs (args . result)
           [f (lambda (x)
                (let ([ans (assoc x memo)]) ; not sure we need ans variable, mb just use assoc in if stmt
                  (if ans
                      (cdr ans)
                      (let ([new-ans (if (or (= x 1) (= x 2))
                                         1
                                         (+ (f (- x 1))
                                            (f (- x 2))))])
                        (begin
                          (set! memo (cons (cons x new-ans) memo))
                          new-ans)))))])
    f))
                                    