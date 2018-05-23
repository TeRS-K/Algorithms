#lang lazy
(require "Gen.rkt")
(require "IOStream.rkt")
(define Nats
  (Gen -1 0 (λ (in state cont)
             (cont (add1 in)
                   0
                   (list (add1 in))))))
(define (Kill k s)
  (Gen s 0 (λ (in state cont)
             (if (empty? in) empty
                 (cont (cdr in)
                       0
                       (if (integer? (/ (car in) k)) empty (list (car in))))))))

(define primes
  (cons 2 (Gen (Kill 2 (cdr (cdr Nats))) 0 (λ (in state cont)
                                             (cont (Kill (car in) in)
                                                   0
                                                   (list (car in)))))))

(define twinprimes
  (Gen primes 0 (λ (in state cont)
                  (cont (cdr in)
                        0
                        (if (= (- (car (cdr in)) (car in)) 2)
                            (list (list (car in) (car (cdr in)))) empty)))))