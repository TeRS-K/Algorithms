#lang racket
(require "RAM.rkt")
;; Gen behaves like Gen from A11, except
;;   -- it does not require lazy Racket
;;   -- inp is a list, not a stream
;;   -- result is a list, not a stream
;;   -- (step inp state step) can access only 1st element of inp
;;
;; (accum s) uses Gen to compute the cumulative sum of a list
;;
;; Example:
;;  (accum (build-list 6 (lambda(x)(quotient x 2)))) ; '(0 0 1 1 3 3)

(define (Gen inp state step)
  (define (cont newinp state out)
     (append out (Gen (append newinp (cdr inp)) state step)))
  (step (if (empty? inp) empty (take inp 1)) state cont))


(define (accum s) (Gen s start step))

(define start
  ((λ()
  (define r1 (ram-store ram 0 3)) ;; cursor
  (define r2 (ram-store r1 1 0))  ;; length
  (define r3 (ram-store r2 2 0))  ;; sum
  r3)))

(define (Ram-add1 r)
  (ram-store r 0 (add1 (ram-fetch r 0))))

(define (step inp state cont)
  (cond
    [(empty? inp) empty]
    [(> (- (ram-fetch state 0) 2) (ram-fetch state 1))
     (cont (cdr inp)
           ((λ()
              (define r1 (ram-store state 0 3)) ;; cursor back to 3
              (define r2 (ram-store r1 1 (add1 (ram-fetch r1 1)))) ;; (add1 length)
              (define r3 (ram-store r2 2 (+ (ram-fetch r2 2) (car inp)))) ;; (+ (car inp) sum)               
              (define r4 (ram-store r3 (+ 2 (ram-fetch r3 1)) (car inp))) ;; cons (car inp) to ram
              r4))
           (list (+ (ram-fetch state 2) (car inp))))]
    [(= (car inp) (ram-fetch state (ram-fetch state 0)))
     (cont (cdr inp) (ram-store state 0 3) (list (ram-fetch state 2)))]
    [else (cont inp (Ram-add1 state) empty)]))
