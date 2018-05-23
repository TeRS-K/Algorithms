#lang racket
(λ (a b)
    ((a ((b (λ (x) (λ (y) y)))
          (λ (x) (λ (y) x)))) b))

;; (If a (Not b) b)
;;
;; ((a (If b False True)) b))
;;