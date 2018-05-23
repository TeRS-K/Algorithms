#lang racket

((λ (f)
    ((λ (self)(f(self self)))(λ (self)(f(self self)))))
 (λ (f)
    (λ (x)
      (((x (λ (Yes) (λ (No) (λ (yes) (λ (no) no))))) 
        (λ (selector)
          ((selector (λ (yes) (λ (no) yes)))
           (λ (Yes) (λ (yes) (λ (no) yes)))))) 
     (((x (λ (yes) (λ (no) yes)))
       (λ (selector) ((selector (λ (yes) (λ (no) no))) (f (x (λ (yes) (λ (no) no))))))) 
       (λ (selector) ((selector (λ (yes) (λ (no) yes))) (x (λ (yes) (λ (no) no))))))))))

 