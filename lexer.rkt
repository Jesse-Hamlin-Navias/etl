#lang br
(require brag/support)

(define-lex-abbrev all-oths (:+ (char-set "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")))

(define etl-lexer
  (lexer-srcloc
   ["\n" (token lexeme #:skip? #t)]
   [whitespace (token lexeme #:skip? #t)]
   ["rule" (token 'RULE lexeme)]
   ["(" (token 'LEFT-PAREN lexeme)]
   [")" (token 'RIGHT-PAREN lexeme)]
   ["->" (token 'ARROW lexeme)]
   [(:: "!" (:+ all-oths)) (token 'OP lexeme)]
   ;[(from/stop-before "!" whitespace) (token 'OP lexeme)]
   [all-oths (token 'VARIABLE (string->symbol lexeme))]))
    
(provide etl-lexer)