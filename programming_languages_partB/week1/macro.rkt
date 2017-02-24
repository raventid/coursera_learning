#lang racket

; if then else like in SML, much better
(define-syntax my-if
  (syntax-rules (then else)
    [(my-if e1 then e2 else e3)
     (if e1 e2 e3)]))

(define-syntax comment-out
  (syntax-rules ()
    [(comment-out ignore instead) instead]))

; Let's create promise with a macro. Now we can do really cool thing
; (f (my-delay e)) - woooooooooo!
; Racket eager evaluate params to function, so macro is the only option to avoid
; (f (my-delay (lambda () e))))
(define-syntax my-delay
  (syntax-rules ()
    [(my-delay e)
     (mcons #f (lambda () e))]))

(define-syntax my-force ; do we really need macro here?
  (syntax-rules ()
    [(my-force e)
     (let ([x e]) ; we evaluate e and then save result to x, to avoid recomputation
       (if (mcar x)
           (mcdr x)
           (begin (set-mcar! x #t)
                  (set-mcdr! x ((mcdr x)))
                  (mcdr x))))]))

(define-syntax for
  (syntax-rules (to do)
    [(for lo to hi do body)
     (let ([l lo]
           [h hi])
       (letrec ([loop (lambda (it)
                        (if (> it h)
                            #t
                            (begin body (loop (+ it 1)))))])
         (loop l)))]))