#lang racket
(require "RAM.rkt")
(define (Gen inp state step)
  (define (cont newinp state out)
    (append out (Gen (append newinp (cdr inp)) state step)))
  (step (if (empty? inp) empty (take inp 1)) state cont))

(define (accum s)
  (Gen s start step))

(define start
  ((λ()
     (define r1 (ram-store ram 0 0)) ; sum
     (define r2 (ram-store r1 1 0))  ; max elem in ram
     r2)))

(define (step inp state cont)
  (cond
    [(empty? inp) empty]
    [(<= (car inp) (ram-fetch state 1))
     (if (= (car inp) (ram-fetch state (+ 2 (car inp))))
         (cont (cdr inp) state (list (ram-fetch state 0)))
         (cont (cdr inp)
               ((λ()
                  (define r1 (ram-store state 0 (+ (car inp) (ram-fetch state 0))))
                  (define r2 (ram-store r1 (+ 2 (car inp)) (car inp)))
                  r2))
               (list (+ (car inp) (ram-fetch state 0)))))]
    [else 
     (cont inp
           ((λ()
              (define r1 (ram-store state 1 (add1 (ram-fetch state 1)))) ;; update max pos
              (define r2 (ram-store r1 (+ 3 (ram-fetch state 1)) 0)) ;; fill 0 from max to (car inp)
              r2))
           empty)]             
    ))