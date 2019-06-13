:- module(parser, [parse/2, tokenize//1]).
:- use_module(library(dcg/basics)).

:- use_module(library(dcg_core)).

parse( File, Tree ) :-
	phrase_from_file(tokenize(Tokens), File),
	( phrase(stmts(Tree), Tokens)
	; phrase(exp(Tree), Tokens) )
	.

token(str(T)) --> "\""	, string(S), "\"", {!, atom_chars(T, S)}.
token(T) --> { member(TS, ["+", "-", "*", "/", "=", "(", ")", "{", "}", ";"]), atom_chars(T, TS) }, TS, {!}.
token(T) --> integer(T), {!}.
token(T) --> string_without("\n\t +-*/=;\"", TS), { TS \= "", atom_chars(T, TS), ! }.


% tokenize(T) --> blank, {!}, tokenize(T).
tokenize(X) --> blank, {!}, tokenize(X).
tokenize([]) --> [].
tokenize([Tok | Tail]) --> token(Tok), tokenize(Tail).



% expressions
exp(E) --> aexp(E) ; mexp(E) ; sexp(E).

% simple
sexp(E) --> ['('], exp(E), [')'].
sexp(int(I)) --> [I], { integer(I) }.
sexp(int(I)) --> [-, IN], { integer(IN), I is -IN }.
sexp(str(S)) --> [str(S)], {!}.
sexp(var(V)) --> [V], {!}.

% additive
aexp(E) --> mexp(E).
aexp(E1 + E2) --> mexp(E1), [+], aexp(E2).

% multiplicative
mexp(E) --> sexp(E).
mexp(E1 * E2) --> sexp(E1), [*], mexp(E2).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% statements
stmts(Stmts) --> seqmap(stmt, Stmts).

stmt(block(S)) --> ['{'], stmts(S), ['}'].

stmt(decl(Type, Id, Exp)) --> [Type, Id, =], exp(Exp), [;].
