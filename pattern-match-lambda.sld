(define-library (pattern-match-lambda)
  (export pattern-match-lambda)
  (import (scheme base))
(begin

(define-syntax if-identifier
  (syntax-rules ()
    ((_ condition seq alt)
     (let-syntax ((foo (syntax-rules () ((_) seq))))
       (let-syntax ((test (syntax-rules ()
                            ((_ condition) (foo))
                            ((_ x) alt))))
         (test foo))))))

(define-syntax if-vector
  (syntax-rules ()
    ((_ #(x ...) seq alt) seq)
    ((_ x seq alt) alt)))

(define-syntax if-literal
  (syntax-rules ()
    ((_ p (literals ...) seq alt)
     (let-syntax ((bar (syntax-rules () ((_) seq))))
       (let-syntax ((foo (syntax-rules (literals ...)
                         ((_ literals) (bar)) ...
                         ((_ x) alt))))
       (foo p))))))

(define-syntax %if-match-vector
  (syntax-rules ()
    ((_ (literals ...) #() ind e seq alt) seq)
    ((_ (literals ...) #(p r ...) ind e seq alt)
     (%if-match (literals ...) p (vector-ref e ind)
       (let ((i ind))
         (%if-match-vector (literals ...) #(r ...) (+ i 1) e seq alt))
       alt))))

(define-syntax %if-match
  (syntax-rules ()
    ((_ (literals ...) #(p ...) e seq alt)
     (if (and (vector? e) (= (vector-length '#(p ...)) (vector-length e)))
         (%if-match-vector (literals ...) #(p ...) 0 e seq alt)
         (alt)))
    ((_ (literals ...) ((p . r1) . r2) e seq alt)
     (let ((temp e))
       (if (pair? temp)
           (%if-match (literals ...) (p . r1) (car temp)
             (%if-match (literals ...) r2 (cdr temp) seq alt)
             alt)
           (alt))))
    ((_ (literals ...) (p . r) e seq alt)
     (let ((temp e))
       (if (pair? temp)
           (if-identifier p
             (if-literal p (literals ...)
               (if (equal? 'p (car temp))
                   (%if-match (literals ...) r (cdr temp) seq alt)
                   (alt))
               (let ((p (car temp)))
                 (%if-match (literals ...) r (cdr temp) seq alt)))
             (%if-match (literals ...) p (car temp)
               (%if-match (literals ...) r (cdr temp) seq alt)
               alt))
           (alt))))
    ((_ (literals ...) () e seq alt)
     (if (null? e) seq (alt)))
    ((_ (literals ...) p e seq alt)
     (if-identifier p
       (if-literal p (literals ...)
         (if (equal? 'p e) seq (alt))
         (let ((p e)) seq))
       (if-vector p
         (%if-match-vector (literals ...) p e seq alt)
         (if (equal? p e) seq (alt)))))))

(define-syntax if-match
  (syntax-rules ()
    ((_ (literals ...) pattern lst seq alt)
     (let ((alt-thunk (lambda() alt)))
       (%if-match (literals ...) pattern lst seq alt-thunk)))))

(define-syntax %pattern-match-lambda
  (syntax-rules (else)
    ((_ (literals ...) lst) (if #f #t))
    ((_ (literals ...) lst (else expr))
     expr)
    ((_ (literals ...) lst (pattern expr) (rest-pattern rest-expr) ...)
     (if-match (literals ...) pattern lst
       expr
       (%pattern-match-lambda (literals ...) lst
         (rest-pattern rest-expr) ...)))))

(define-syntax pattern-match-lambda
  (syntax-rules ()
    ((_ (literals ...) (pattern expr)  ...)
     (lambda lst
       (%pattern-match-lambda (literals ...) lst (pattern expr) ...)))))

))
