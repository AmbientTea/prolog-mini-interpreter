:- module(check, [check/1]).
:- use_module(eval).

:- use_module(library(dcg_core)).

check(Tree) :-
    emptyenv(Env),
    seqmap(checkStmt, Tree, Env, _).

checkStmt(decl(Type, Id, Exp)) -->
	( declareVar(Id, Type, _)
	; { format("variable ~s already declared\n", [Id]), fail } ), !,
	
	( typeExp(Exp, EType)
	; { format("cannot type expression ~w\n", [Exp]), fail } ), !,
	
	{ Type = EType
	; format("assignment ~s <- ~s\n", [Type, EType]), fail }, !.

% typeExp(Env, Exp, Type)
typeExp(str(_), str) --> nop.
typeExp(int(_), int) --> nop.
typeExp(E1 + E2, int) --> typeExp(E1, int), typeExp(E2, int).
typeExp(E1 * E2, int) --> typeExp(E1, int), typeExp(E2, int).
typeExp(var(V), Type) --> varType(V, Type).
