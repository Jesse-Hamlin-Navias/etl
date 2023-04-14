#lang brag
etl-program: rules expressions

rules: () | rule | rules2 rule
@rules2: rule | rules2 rule
rule: /RULE /VARIABLE rlist /ARROW rlist
rlist: /LEFT-PAREN r-exp2 r-exp2 /RIGHT-PAREN | r-variable | r-op
@r-exp2: rlist | r-variable | r-op
r-variable: VARIABLE | /LEFT-PAREN VARIABLE /RIGHT-PAREN
r-op: OP

@expressions: () | expression | expressions2 expression
@expressions2: expression | expressions2 expression
/expression: /LEFT-PAREN e-exp2 e-exp2 /RIGHT-PAREN | e-variable | OP
/elist: /LEFT-PAREN e-exp2 e-exp2 /RIGHT-PAREN | e-variable | OP
@e-exp2: elist | e-variable | OP
@e-variable: VARIABLE | /LEFT-PAREN VARIABLE /RIGHT-PAREN
