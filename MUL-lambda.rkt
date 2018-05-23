#lang lazy
(require "Lambda.rkt")
(provide MUL)
(define (MUL a b)
  (If (Or (Z? a) (Z? b))
      Z
      (If (Car a) (ADD (MUL (Cons False (Cdr a)) b) b)
          (Cons False (MUL (Cdr a) b)))))