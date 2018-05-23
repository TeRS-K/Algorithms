#lang racket
(require "generate.rkt")

(define (merge l1 l2 <)
  (generate
   (list l1 l2 empty)
   (lambda (x) (or (empty? (first x)) (empty? (second x))))
   (lambda (x) (if (< (first (first x)) (first (second x)))
                   (list (cdr (first x))
                         (second x)
                         (cons (first (first x)) (third x)))
                   (list (first x)
                         (cdr (second x))
                         (cons (first (second x)) (third x)))))
   (lambda (x) (if (empty? (first x))
                   (append (reverse (third x)) (second x))
                   (append (reverse (third x)) (first x))))))

(define (my-sort l <)
  (generate
   (list (map list l) empty)
   (lambda (x) (and (empty? (first x))
                    (or (= 1 (length (second x)))
                        (empty? (second x)))))
   (lambda (x) (cond
                 [(empty? (first x)) (list (second x) empty)]
                 [(empty? (cdr (first x))) (list empty
                                                 (append (first x) (second x)))]                 
                 [else (list (cddr (first x))
                             (cons (merge (first (first x)) (second (first x)) <) (second x)))]))
   (lambda (x) (if (and (empty? (first x)) (empty? (second x))) empty (first (second x))))))
   
