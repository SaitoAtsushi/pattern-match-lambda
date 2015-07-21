# pattern-match-lambda for R7RS-Scheme

## Introduction

This package is easy pattern match library for R7RS.
It provide a macro pattern-match-lambda only one.

## Install

This package don't contain install script.
How to install depends on each Scheme implementation.
Please see document of each Scheme implementation.

## Syntax
A pattern-match-lambda's syntax is following.

```scheme
(pattern-match-lambda (<pattern literal> ...) <clause> ...)
```

Each &lt;clause&gt; is of the form (&lt;pattern&gt; &lt;body&gt;), where &lt;pattern&gt; and &lt;body&gt; have the syntax that be similar to syntax-rules.

It is an error if &lt;clause&gt; is not of the form
```scheme
(<pattern> <body>)
```
The &lt;pattern&gt; in a &lt;clause&gt; is a list &lt;pattern&gt;.

A &lt;pattern&gt; is either an identifier, a constant, or one of the following.

```scheme
(<pattern> ...)
(<pattern> <pattern> ... . <pattern>)
#(<pattern> ...)
```

## Semantics

A pattern-match-lambda expression evaluates to a procedure that accepts a variable number of arguments and is lexically scoped in the same manner as a procedure resulting from a lambda expression. When the procedure is called, the first &lt;clause&gt; for which the arguments match with &lt;pattern&gt; is selected, where argument is specified as for the &lt;pattern&gt; of a syntax-rules like expression.

Difference between &lt;pattern&gt; of syntax-rules and pattern-match-lambda is ellipsis. Ellipsis is not able to use in pattern-match-lambda's &lt;pattern&gt;.

The variables of &lt;pattern&gt; are bound to fresh locations, the values of the arguments are stored in those locations, the &lt;body&gt; is evaluated in the extended environment, and the results of &lt;body&gt; are returned as the results of the procedure call. It is an error for the arguments not to match with the &lt;pattern&gt; of any &lt;clause&gt;.

An identifierappearing within a &lt;pattern&gt; can be an underscore (_), a literal identifier listed in the list of &lt;pattern-literal&gt;. All other identifiers appearing within a &lt;pattern&gt; are variables.

Variables in &lt;pattern&gt; match arbitrary input elements and are used to refer to elements of the input in the body. It is an error for the same variable to appear more than once in a &lt;pattern&gt;. Underscores also match arbitrary input elements but are not variables and so cannot be used to refer to those elements. If an underscore appears in the &lt;pattern literal&gt; list, then that takes precedence and underscores in the &lt;pattern&gt; match as literals. Multiple underscores can appear in a &lt;pattern&gt;.

Identifiers that appear in (&lt;pattern literal&gt; ...) are interpreted as literal identifiersto be matched against corresponding elements of the input. An element in the input matches a literal identifiers if and only if it is an symbol and equal to literal identifier in the sense of the eqv? procedure.

## License

Copyright (c) 2014 SAITO Atsushi

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
3. Neither the name of the authors nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

