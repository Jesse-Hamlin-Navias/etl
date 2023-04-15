#lang scribble/manual

@title{Etl: Expresson Transformation Language}
@author{xSK, ported to Racket and lightly edited by Jesse P. Hamlin-Navias}

@defmodulelang[etl]

The original etl implementation can be found
@hyperlink["https://github.com/iota-xSK/etl"]{here}.

Etl (pronounced like "nettle" without the n)
is an esoteric programming language for transforming expressions.
There are three data types in Etl: pairs, varaibles and operators.
Pairs are pairs of the said datatypes.
Pairs are written with parenthesies and arguments seperated by spaces.
Operators start with a ! which is followed by any sequence of alphanumeric characters.
Variables are all other sequences of alphanumeric characters.
In other implementations of etl, a wider-variety of characters may be accepted.
Here is an example:

@verbatim{
(hello (((!0) foo) bar))}

Programs are written as a set of replacement rules
and a list of expressions to apply the rules to.
Here is the syntax and how they work:

@verbatim{
rule swap (!S (a b)) -> (b a)
(!S ((!S (a b)) c))}

which outputs

@verbatim{(c (b a))}

The general syntax for rules is:

@verbatim{rule <name> <pattern> -> <replacement>}

where <name> is replaced by a string of the name
of the rule (currently there is no use for the name,
one will be added in the future), and <pattern>
and <replacement> are replaced by expressions.

All variables that appear in <replacement> must
first appear in <pattern>. This behavior may not
appear in other implementations of etl. The behavior
of variables unique to <replacement> may be
undefined in other implementations of etl.

@section{Rule application process}

First we do a process called pattern matching
which may or may not yield a mapping between
the dummy names and actual expressions called
"bindings". For example when we match the expression
(!S (a (b c))) against the pattern (!F (a b))
we get no match because the operator !F doesn't
have the same name as the operator in its place
in the expression. However if we have the exprssion
(!F (x (y z))) it matches producing the following bindings:

@verbatim{
"a": x
"b": (y z)
}

Now that we have those bindings we can produce
a different expression. That's what the replacement
part of the rule is for. Say that we have a rule

@verbatim{
rule swap (!S (a b)) -> (b a)}

and an expression

@verbatim{
(!S (x (y z)))}

Our rule is applied recursively outside-in. So first the program generats the outermost bindings:

@verbatim{
"a": x,
"b": (y z)
}

Then the language takes the replacement expression
and replaces every instance of "a" and "b" with the
corresponding binding. In the end of evaluation
our expression we end up with

@verbatim{
((y z) x)
}

@section{Conflicting Rules}
If an expression matches the pattern of two different
rules, the top-most defined rule takes precedence.

@verbatim{
rule c1 (!C a) -> (a a)
rule c2 (!C (a a)) -> (a)
(!C (b b))}

returns

@verbatim{
((b b) (b b))}

This behavior may not be included in other implementations
of etl. Conflicting rules may result in undefined
behavior in other implementations.

@section{Example programs}

@subsection{reversing a linked list}

@verbatim{
rule r1 (!R ((x y) (z))) -> (!R ((x) (z y)))
rule r2 (!R (!0 x)) -> (x)
(!R (((((!0 a) b) c) d) !0))}

outputs:

@verbatim{
((((!0 d) c) b) a)}

@subsection{SKI}

@hyperlink["https://en.wikipedia.org/wiki/SKI_combinator_calculus"]{SKI_combinator_calculus}

@verbatim{
rule S (((!S x) y) z) -> ((x z) (y z))
rule K ((!K x) y) -> (y)
rule I (!I y) -> (y)}