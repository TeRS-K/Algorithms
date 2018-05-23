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
     (define r1 (ram-store ram 0 10))
     (define r2 (ram-store r1 1 0))
     (define r3 (ram-store r2 2 0))
     (define r4 (ram-store r3 10 0))
     (define r5 (ram-store r4 11 7))
     (define r6 (ram-store r5 12 7))
     r6)))

(define (step inp state cont)
  (cond
    [(empty? inp) empty]
    [(= 0 (car inp))
     (cont (cdr inp) state (list (sum state)))]
    [(= 0 (Quotient state))
     (cont inp (ram-store state 2 (car inp)) empty)]
    [(zero? (quotient (Quotient state) 2))
     (cont (cdr inp) ((λ()
                        (define r1 (ram-store state 2 (quotient (Quotient state) 2)))
                        (define r2 (cond
                                     [(= EMPTY (ram-fetch r1 (+ 2 (cursor r1))))
                                      (ram-store (add-right-node r1 1) 1 (+ (car inp) (sum r1)))]
                                     [(and (not (= EMPTY (ram-fetch r1 (+ 2 (cursor r1)))))
                                           (zero? (ram-fetch r1 (* 3 (add1 (cursor r1))))))
                                      (ram-store (ram-store r1 (* 3 (add1 (cursor r1))) 1) 1 (+ (car inp) (sum r1)))]
                                     [else r1]))                         
                        (define r3 (ram-store r2 0 10))
                        r3))
           (if (or (= EMPTY (ram-fetch state (+ 2 (cursor state))))
                   (and (not (= EMPTY (ram-fetch state (+ 2 (cursor state)))))
                        (zero? (ram-fetch state (* 3 (add1 (cursor state)))))))
               (list (+ (car inp) (sum state)))
               (list (sum state))))]

    [(= 1 (modulo (Quotient state) 2))
     (cont inp ((λ()
                  (define r1 (ram-store state 2 (quotient (Quotient state) 2)))    ;; update [2] to the new quotient
                  (define r2 (if (= EMPTY (ram-fetch r1 (+ 2 (cursor r1))))
                                 (add-right-node r1 0)
                                 r1))
                  (define r3 (ram-store r2 0 (* 3 (add1 (cursor r2)))))
                  r3))
           empty)]
    [else (cont inp ((λ()
                        ;; update the cursor to 3n
                       (define r1 (ram-store state 2 (quotient (Quotient state) 2))) ;; update [2] to the new quotient
                       (define r2 (if (= EMPTY (ram-fetch r1 (+ 1 (cursor r1))))
                                      (add-left-node r1 0)
                                      r1))
                       (define r3 (ram-store r2 0 (* 3 (cursor r2))))
                       r3))
                empty)]))

(define (add-right-node r n) ;; n = 0 : empty or n = 1 : solid
  ((λ()
     (define r1 (ram-store r (+ 2 (cursor r)) (* 3 (add1 (cursor r)))))
     (define r2 (ram-store r1 (* 3 (add1 (cursor r1))) n))
     (define r3 (ram-store r2 (+ 1 (* 3 (add1 (cursor r2)))) EMPTY))
     (define r4 (ram-store r3 (+ 2 (* 3 (add1 (cursor r3)))) EMPTY))
     r4)))
     

(define (add-left-node r n) ;; n = 0 : empty or n = 1 : solid
  ((λ()
     (define r1 (ram-store r (+ 1 (cursor r)) (* 3 (cursor r))))
     (define r2 (ram-store r1 (* 3 (cursor r1)) n))
     (define r3 (ram-store r2 (+ 1 (* 3 (cursor r2))) EMPTY))
     (define r4 (ram-store r3 (+ 2 (* 3 (cursor r3))) EMPTY))
     r4)))

(define (cursor r) (ram-fetch r 0))
(define (sum r) (ram-fetch r 1))
(define (Quotient r) (ram-fetch r 2))
(define EMPTY 7)
