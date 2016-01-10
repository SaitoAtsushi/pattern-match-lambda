# pattern-match-lambda for R7RS-Scheme

## Introduction

This package is easy pattern match library for R7RS.  It provides only one
macro named `pattern-match-lambda`.

## Install

This package doesn't contain install scripts.  The installation procedure
depends on the Scheme implementation you're using.  Please see document of
the implementation.

## How to use

The following examples shows how to use `pattern-match-lambda`.

```scheme
(define fact
  (pattern-match-lambda ()
   ((0) 1)
   ((n) (* n (fact (- n 1))))))

(fact 5) ;; -> 120

(define string-input?
  (pattern-match-lambda ()
    ((x) (string? x) x)
    ((x) 'not-string)))

(string-input? "ok") ;; -> "ok"
(string-input? 'ng)  ;; ->  not-string
```

[test.scm](test.scm) contains more examples.

## Syntax

The `pattern-match-lambda`'s syntax is the following.

```scheme
(pattern-match-lambda (<pattern literal> ...) <clause> ...)
```

`(_<pattern literal>_ ...)` must be either null or a list of unique
identifiers. If this is not null, then specified identifiers are treated as
if they are keyword of the `pattern-match-lambda` macro.

```scheme
(define literal
  (pattern-match-lambda (foo)
    ((foo x) x)
    ((_   x) 'ng)))

(literal 'foo 'x) ;; -> x
(literal 'bar 'x) ;; -> ng
```

Literal matching are done against mere symbols not syntax identifiers. This
is because `pattern-match-lambda` macro creates an procedure not a macro.

_`<clause>`_ must have one of the following forms:

- ```(<pattern> <expr>)```
- ```(<pattern> <fender> <expr>)```

A _`<pattern>`_ is either an identifier, a constant, or one of the
followings.

```scheme
(<pattern> ...)
(<pattern> <pattern> ... . <pattern>)
#(<pattern> ...)
```

A _`<fender>`_ is an expression which is evaluated when _`<pattern>`_ is
matched.  If the result of evaluation is true value, then the following
_`<expr>`_ is evaluated, otherwise `pattern-match-lambda` continues
matching. The following example shows how it works:

```scheme
(define foo
  (pattern-match-lambda ()
    ((a) (eq? a 'fender) 'fender)
    ((a) 'fallback)))

(foo 'fender) ;; -> fender
(foo 'a)      ;; -> fallback
```

## Semantics

A `pattern-match-lambda` expression evaluates to a procedure that accepts a
variable number of arguments and is lexically scoped in the same manner as
a procedure resulting from a lambda expression. When the procedure is
called, the first _`<clause>`_ for which the arguments match with
_`<pattern>`_ is selected, where argument is specified as for the
_`<pattern>`_ of a `syntax-rules` like expression.

Difference between _`<pattern>`_ of `syntax-rules` and
`pattern-match-lambda` is ellipsis. Ellipsis is not able to use in
pattern-match-lambda's _`<pattern>`_.

The variables of _`<pattern>`_ are bound to fresh locations, the values of
the arguments are stored in those locations, the _`<expr>`_ is evaluated in
the extended environment, and the results of _`<expr>`_ are returned as the
results of the procedure call. It is an error for the arguments not to
match with the _`<pattern>`_ of any _`<clause>`_.

An identifier appearing within a _`<pattern>`_ can be an underscore (`_`),
a literal identifier listed in the list of _`<pattern-literal>`_. All other
identifiers appearing within a _`<pattern>`_ are variables.

Variables in _`<pattern>`_ match arbitrary input elements and are used to
refer to elements of the input in the body. It is an error for the same
variable to appear more than once in a _`<pattern>`_. Underscores also
match arbitrary input elements but are not variables and so cannot be used
to refer to those elements. If an underscore appears in the _`<pattern
literal>`_ list, then that takes precedence and underscores in the
_`<pattern>`_ match as literals.  Multiple underscores can appear in a
_`<pattern>`_.

Identifiers that appear in `(_<pattern literal>_ ...)` are interpreted as
literal identifiers to be matched against corresponding elements of the
input.  An element in the input matches a literal identifiers if and only
if it is an symbol and equal to literal identifier in the sense of the
`eqv?` procedure.

## License

Copyright (c) 2014 SAITO Atsushi

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, 
   this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice, 
   this list of conditions and the following disclaimer in the documentation 
   and/or other materials provided with the distribution.
3. Neither the name of the authors nor the names of its contributors may be 
   used to endorse or promote products derived from this software without 
   specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

