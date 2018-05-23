#lang racket

(define (numorchar? x) (or (number? x) (symbol? x)))

(define (isoperand? x) (or (equal? x '+) (equal? x '*)))

(define (in->pre lst)
  (if (not (ifvalid? lst)) (error "bad expression") (in->pre-h lst)))
(define (in->pre-h lst)
  (cond
    [(numorchar? lst) lst]
    [(empty? (cdr lst)) (in->pre-h (car lst))]
    [else (helper (cdr lst) (list (second lst) (in->pre-h (first lst))))]))

(define (ifvalid? lst)
  (cond
    [(empty? lst) #f]
    [(numorchar? lst) #t]
    [(and (empty? (cdr lst)) (numorchar? (first lst)) (not (isoperand? (first lst)))) #t]
    [(and (empty? (cdr lst)) (ifvalid? (first lst))) #t]
    [(numorchar? (first lst)) (and (isoperand? (second lst))
                                   (not (isoperand? (first lst)))
                                   (ifvalid? (cddr lst)))]
    [(list? (first lst)) (and (ifvalid? (first lst))
                              (isoperand? (second lst))
                              (ifvalid? (cddr lst)))]))

(define (helper lst acc)
  (cond
    [(empty? (cdr lst)) (Addlast (in->pre-h (second lst)) acc)]
    [(empty? (cddr lst))
     (if (equal? (first lst) (first acc))
         (append acc (list (in->pre-h (second lst))))
         (Addlast (in->pre-h (second lst)) acc))]
    [(and (equal? (third lst) '+) (equal? (first acc) '+))
     (helper (cddr lst) (Addlast (in->pre-h (second lst)) acc))]
    [(and (equal? (third lst) '+) (equal? (first acc) '*))
     (helper (cddr lst) (list '+ (Addlast (in->pre-h (second lst)) acc)))]
    [(and (equal? (third lst) '*) (equal? (first acc) '*))
     (helper (cddr lst) (Addlast (in->pre-h (second lst)) acc))]
    [(and (equal? (third lst) '*) (equal? (first acc) '+))
     (if (equal? (first lst) '+)
         (if (list? (last acc)) (helper (cddr lst) (append acc (list (list '* (in->pre-h (second lst))))))
             (helper (cddr lst) (Addlast (list '* (in->pre-h (second lst))) acc)))
         (helper (cddr lst) (Addlast (in->pre-h (second lst)) acc)))]))
 
(define (Addlast x lst)
  (if (list? (last lst)) (reverse (cons (append (last lst) (list x)) (cdr (reverse lst)))) (append lst (list x))))
