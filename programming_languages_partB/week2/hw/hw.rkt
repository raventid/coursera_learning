;; Programming Languages, Homework 5

#lang racket
(provide (all-defined-out)) ;; so we can put tests in a second file

;; definition of structures for MUPL programs - Do NOT change
(struct var  (string) #:transparent)  ;; a variable, e.g., (var "foo")
(struct int  (num)    #:transparent)  ;; a constant number, e.g., (int 17)
(struct add  (e1 e2)  #:transparent)  ;; add two expressions
(struct ifgreater (e1 e2 e3 e4)    #:transparent) ;; if e1 > e2 then e3 else e4
(struct fun  (nameopt formal body) #:transparent) ;; a recursive(?) 1-argument function
(struct call (funexp actual)       #:transparent) ;; function call
(struct mlet (var e body) #:transparent) ;; a local binding (let var = e in body) 
(struct apair (e1 e2)     #:transparent) ;; make a new pair
(struct fst  (e)    #:transparent) ;; get first part of a pair
(struct snd  (e)    #:transparent) ;; get second part of a pair
(struct aunit ()    #:transparent) ;; unit value -- good for ending a list
(struct isaunit (e) #:transparent) ;; evaluate to 1 if e is unit else 0

;; a closure is not in "source" programs but /is/ a MUPL value; it is what functions evaluate to
(struct closure (env fun) #:transparent) 

;; Problem 1

(define (racketlist->mupllist xs)
  (if (null? xs)
      (aunit)
      (apair (car xs) (racketlist->mupllist (cdr xs)))))

(define (mupllist->racketlist xs)
  (if (aunit? xs)
      null
      (cons (apair-e1 xs) (mupllist->racketlist (apair-e2 xs)))))

;; Problem 2

;; lookup a variable in an environment
;; Do NOT change this function
(define (envlookup env str)
  (cond [(null? env) (error "unbound variable during evaluation" str)]
        [(equal? (car (car env)) str) (cdr (car env))]
        [#t (envlookup (cdr env) str)]))
  

;; Do NOT change the two cases given to you.  
;; DO add more cases for other kinds of MUPL expressions.
;; We will test eval-under-env by calling it directly even though
;; "in real life" it would be a helper function of eval-exp.
(define (eval-under-env e env)
  (cond
    ;; A variable evaluates to the value associated with it in the environment.
    [(var? e) 
     (envlookup env (var-string e))]
    ;; An addition evaluates its subexpressions and assuming they both produce integers, produces the
    ;; integer that is their sum
    [(add? e) 
     (let ([v1 (eval-under-env (add-e1 e) env)]
           [v2 (eval-under-env (add-e2 e) env)])
       (if (and (int? v1)
                (int? v2))
           (int (+ (int-num v1) 
                   (int-num v2)))
           (error "MUPL addition applied to non-number")))]
    ;; All values (including closures) evaluate to themselves.
    [(or (aunit? e) (int? e) (closure? e)) e]
    ;; Functions are lexically scoped:
    ;; A function evaluates to a closure holding the function and the current environment.
    [(fun? e) (closure env e)]
    ;; An ifgreater evaluates its first two subexpressions to values v1 and v2 respectively.
    [(ifgreater? e) 
     (let ([v1 (eval-under-env (ifgreater-e1 e) env)]
           [v2 (eval-under-env (ifgreater-e2 e) env)])
       (if (and (int? v1)
                (int? v2))
           (if (> (int-num v1) (int-num v2))
               (eval-under-env (ifgreater-e3 e) env)
               (eval-under-env (ifgreater-e4 e) env))
           (error "MUPL ifgreater applied to non-number")))]
    ;; An mlet expression evaluates its first expression to a value v.
    ;; Then it evaluates the second expression to a value, in an environment extended
    ;; to map the name in the mlet expression to v.
    [(mlet? e)
     (let* ([identifier (mlet-var e)]
            [exp (mlet-e e)]
            [body (mlet-body e)]
            [value (eval-under-env exp env)]
            [extended-env (cons (cons identifier value) env)])
       (eval-under-env body extended-env))]
    ;; A call evaluates its first and second subexpressions to values.
    ;; If the first is not a closure, it is an error.
    [(call? e)
     (let ([closure-to-apply (eval-under-env (call-funexp e) env)]
           [arg (eval-under-env (call-actual e) env)])
       (if (closure? closure-to-apply)
           (let* ([env (closure-env closure-to-apply)]
                  [function (closure-fun closure-to-apply)]
                  [body (fun-body function)]
                  [nameopt (fun-nameopt function)]
                  [param (fun-formal function)]
                  [rec-env (if nameopt
                               (cons (cons nameopt closure-to-apply) env)
                               env)])
             (eval-under-env body (cons (cons param arg) rec-env)))
           (error "MUPL operand is not a callable: call")))]
    ;; A pair expression evaluates its two subexpressions and produces a (new) pair holding the results.
    [(apair? e)
     (let ([v1 (eval-under-env (apair-e1 e) env)]
           [v2 (eval-under-env (apair-e2 e) env)])
       (apair v1 v2))]
    ;; A fst expression evaluates its subexpression. If the result for the subexpression is a pair, then the
    ;; result for the fst expression is the e1 field in the pair.
    [(fst? e)
     (let ([pair (eval-under-env (fst-e e) env)])
       (if (apair? pair)
           (apair-e1 pair)
           (error "MUPL call 'fst' on not a pair")))]
    ;; A snd expression evaluates its subexpression. If the result for the subexpression is a pair, then
    ;; the result for the snd expression is the e2 field in the pair.
    [(snd? e)
     (let ([pair (eval-under-env (snd-e e) env)])
       (if (apair? pair)
           (apair-e2 pair)
           (error "MUPL call 'snd' on not a pair")))]
    ;; An isaunit expression evaluates its subexpression.
    ;; If the result is an aunit expression, then the result for the isaunit expression is the mupl value (int 1),
    ;; else the result is the mupl value (int 0).
    [(isaunit? e)
     (let ([unit (eval-under-env (isaunit-e e) env)])
       (if (aunit? unit)
           (int 1)
           (int 0)))]
    [#t (error (format "bad MUPL expression: ~v" e))]))

;; Do NOT change
(define (eval-exp e)
  (eval-under-env e null))
        
;; Problem 3

(define (ifaunit e1 e2 e3)
  (ifgreater (isaunit e1) (int 0) e2 e3))

;; ’((s1 . e1) ...(si . ei) ...(sn . en))
;; si is a racket string
(define (mlet* lstlst e2)
  (if (null? lstlst)
      e2
      (let([pair (car lstlst)])
        (mlet (car pair) (cdr pair) (mlet* (cdr lstlst) e2)))))

(define (ifeq e1 e2 e3 e4)
  (mlet* (list (cons "_x" e1) (cons "_y" e2))
         (ifgreater (var "_x")
                    (var "_y")
                    e4
                    (ifgreater (var "_y")
                               (var "_x")
                               e4
                               e3))))

;; Problem 4

(define mupl-map
  (fun #f "callback"
       (fun "map" "list"
            (ifaunit (var "list")
                     (var "list")
                     (apair (call (var "callback") (fst (var "list")))
                            (call (var "map") (snd (var "list"))))))))

(define mupl-mapAddN 
  (mlet "map" mupl-map
        (fun #f "i"
             (call (var "map") (fun #f "x" (add (var "x") (var "i")))))))

;; Challenge Problem

(struct fun-challenge (nameopt formal body freevars) #:transparent) ;; a recursive(?) 1-argument function

;; We will test this function directly, so it must do
;; as described in the assignment
(define (compute-free-vars e)
   (struct res (e fvs))
    (define (f e) 
    (cond [(var? e) (res e (set (var-string e)))]
          [(int? e) (res e (set))]
          [(add? e) (let ([r1 (f (add-e1 e))]
                          [r2 (f (add-e2 e))])
                      (res (add (res-e r1) (res-e r2))
                           (set-union (res-fvs r1) (res-fvs r2))))]
          [(ifgreater? e) (let ([r1 (f (ifgreater-e1 e))]
                                [r2 (f (ifgreater-e2 e))]
                                [r3 (f (ifgreater-e3 e))]
                                [r4 (f (ifgreater-e4 e))])
                            (res (ifgreater (res-e r1) (res-e r2) (res-e r3) (res-e r4))
                                 (set-union (res-fvs r1) (res-fvs r2) (res-fvs r3) (res-fvs r4))))]
          [(fun? e) (let* ([r (f (fun-body e))]
                           [fvs (set-remove (res-fvs r) (fun-formal e))]
                           [fvs (if (fun-nameopt e) (set-remove fvs (fun-nameopt e)) fvs)])
                      (res (fun-challenge (fun-nameopt e) (fun-formal e) (res-e r) fvs)
                           fvs))]
          [(call? e) (let ([r1 (f (call-funexp e))]
                           [r2 (f (call-actual e))])
                      (res (call (res-e r1) (res-e r2))
                           (set-union (res-fvs r1) (res-fvs r2))))]
          [(mlet? e) (let* ([r1 (f (mlet-e e))]
                            [r2 (f (mlet-body e))])
                       (res (mlet (mlet-var e) (res-e r1) (res-e r2))
                            (set-union (res-fvs r1) (set-remove (res-fvs r2) (mlet-var e)))))]
          [(apair? e) (let ([r1 (f (apair-e1 e))]
                            [r2 (f (apair-e2 e))])
                      (res (apair (res-e r1) (res-e r2))
                           (set-union (res-fvs r1) (res-fvs r2))))]
          [(fst? e) (let ([r (f (fst-e e))])
                      (res (fst (res-e r))
                           (res-fvs r)))]
          [(snd? e) (let ([r (f (snd-e e))])
                      (res (snd (res-e r))
                           (res-fvs r)))]
          [(aunit? e) (res e (set))]
          [(isaunit? e) (let ([r (f (isaunit-e e))])
                          (res (isaunit (res-e r))
                               (res-fvs r)))]))
  (res-e (f e)))

;; ATTENTION. THIS CODE DOES NOT WORK YET!!! SORRY! :)

;; Do NOT share code with eval-under-env because that will make
;; auto-grading and peer assessment more difficult, so
;; copy most of your interpreter here and make minor changes
(define (eval-under-env-c e env)
   (cond 
        [(fun-challenge? e)
         (closure (set-map (fun-challenge-freevars e)
                           (lambda (s) (cons s (envlookup env s))))
                  e)]
        ;; A variable evaluates to the value associated with it in the environment.
        [(var? e) 
         (envlookup env (var-string e))]
        ;; An addition evaluates its subexpressions and assuming they both produce integers, produces the
        ;; integer that is their sum
        [(add? e) 
         (let ([v1 (eval-under-env (add-e1 e) env)]
               [v2 (eval-under-env (add-e2 e) env)])
           (if (and (int? v1)
                    (int? v2))
               (int (+ (int-num v1) 
                       (int-num v2)))
               (error "MUPL addition applied to non-number")))]
        ;; All values (including closures) evaluate to themselves.
        [(or (aunit? e) (int? e) (closure? e)) e]
        ;; Functions are lexically scoped:
        ;; A function evaluates to a closure holding the function and the current environment.
        [(fun? e) (closure env e)]
        ;; An ifgreater evaluates its first two subexpressions to values v1 and v2 respectively.
        [(ifgreater? e) 
         (let ([v1 (eval-under-env (ifgreater-e1 e) env)]
               [v2 (eval-under-env (ifgreater-e2 e) env)])
           (if (and (int? v1)
                    (int? v2))
               (if (> (int-num v1) (int-num v2))
                   (eval-under-env (ifgreater-e3 e) env)
                   (eval-under-env (ifgreater-e4 e) env))
               (error "MUPL ifgreater applied to non-number")))]
        ;; An mlet expression evaluates its first expression to a value v.
        ;; Then it evaluates the second expression to a value, in an environment extended
        ;; to map the name in the mlet expression to v.
        [(mlet? e)
         (let* ([identifier (mlet-var e)]
                [exp (mlet-e e)]
                [body (mlet-body e)]
                [value (eval-under-env exp env)]
                [extended-env (cons (cons identifier value) env)])
           (eval-under-env body extended-env))]
        ;; A call evaluates its first and second subexpressions to values.
        ;; If the first is not a closure, it is an error.
        [(call? e)
         (let ([closure-to-apply (eval-under-env (call-funexp e) env)]
               [arg (eval-under-env (call-actual e) env)])
           (if (closure? closure-to-apply)
               (let* ([env (closure-env closure-to-apply)]
                      [function (closure-fun closure-to-apply)]
                      [body (fun-body function)]
                      [nameopt (fun-nameopt function)]
                      [param (fun-formal function)]
                      [rec-env (if nameopt
                                   (cons (cons nameopt closure-to-apply) env)
                                   env)])
                 (eval-under-env body (cons (cons param arg) rec-env)))
               (error "MUPL operand is not a callable: call")))]
        ;; A pair expression evaluates its two subexpressions and produces a (new) pair holding the results.
        [(apair? e)
         (let ([v1 (eval-under-env (apair-e1 e) env)]
               [v2 (eval-under-env (apair-e2 e) env)])
           (apair v1 v2))]
        ;; A fst expression evaluates its subexpression. If the result for the subexpression is a pair, then the
        ;; result for the fst expression is the e1 field in the pair.
        [(fst? e)
         (let ([pair (eval-under-env (fst-e e) env)])
           (if (apair? pair)
               (apair-e1 pair)
               (error "MUPL call 'fst' on not a pair")))]
        ;; A snd expression evaluates its subexpression. If the result for the subexpression is a pair, then
        ;; the result for the snd expression is the e2 field in the pair.
        [(snd? e)
         (let ([pair (eval-under-env (snd-e e) env)])
           (if (apair? pair)
               (apair-e2 pair)
               (error "MUPL call 'snd' on not a pair")))]
        ;; An isaunit expression evaluates its subexpression.
        ;; If the result is an aunit expression, then the result for the isaunit expression is the mupl value (int 1),
        ;; else the result is the mupl value (int 0).
        [(isaunit? e)
         (let ([unit (eval-under-env (isaunit-e e) env)])
           (if (aunit? unit)
               (int 1)
               (int 0)))]
        [#t (error (format "bad MUPL expression: ~v" e))]))

;; Do NOT change this
(define (eval-exp-c e)
  (eval-under-env-c (compute-free-vars e) null))
