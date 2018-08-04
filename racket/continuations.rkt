(define saved-k #f)

(define (save-it!)
  (call-with-composable-continuation
   (lambda(k) ; k is the captured continuation
     (set! saved-k k)
     0)))

(+ 1 (+ 1 (+ 1 (save-it!))))

;; The continuation saved in save-k encapsulates the program context (+ 1 (+ 1 (+ 1 ?))),
;; where ? represents a place to plug in a result value—because that was the expression context
;; when save-it! was called. The continuation is encapsulated so that it behaves
;; like the function (lambda (v) (+ 1 (+ 1 (+ 1 v))))

(saved-k 0)

(saved-k 10)

(saved-k (saved-k 0))
