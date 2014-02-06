(import (scheme base)
        (scheme write)
        (pattern-match-lambda))

(define-syntax exam
  (syntax-rules ()
    ((_ form expect)
     (begin
       (display 'form)
       (display " ... ")
       (display (if (equal? form expect) 'ok 'ng))
       (newline)))))

(define fact
  (pattern-match-lambda ()
   ((0) 1)
   ((n) (* n (fact (- n 1))))))

(exam (fact 5) 120)

(define example
  (pattern-match-lambda ()
    ((x y z) (list 'case1 x y z))
    ((x (y z)) (list 'case2 x y z))
    (((x y) z) (list 'case3 x y z))
    (else 'case3)))

(exam (example 1 2 3) '(case1 1 2 3))
(exam (example 4 '(5 6)) '(case2 4 5 6))
(exam (example '(7 8) 9) '(case3 7 8 9))
(exam (example 10 11 12 13) 'case3)

(define example2
  (pattern-match-lambda (foo bar baz)
    ((foo 1) 'foo-case-1)
    ((foo 2) 'foo-case-2)
    ((foo (x #(y z))) (list 'foo-case x y z))
    ((bar x) (list 'bar-case x))
    ((baz x) (list 'baz-case x))
    (else 'else-case)))

(exam (example2 'foo 1) 'foo-case-1)
(exam (example2 'foo '(1 #(2 3))) '(foo-case 1 2 3))
(exam (example2 'foo 2) 'foo-case-2)
(exam (example2 'baz 4) '(baz-case 4))
