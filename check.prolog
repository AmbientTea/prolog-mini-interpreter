:- module(check, [check/1]).
:- use_module(eval).

check(Tree) :- emptyenv(Env), check(Tree, [Env], _), !.

check([]) --> [].
check([S|T]) --> checkStmt(S), check(T).

checkStmt(decl(Type, Id, Exp)) -->
	( declareVar(Id, Type, _) ; { format("variable ~s already declared\n", [Id]), fail } ), !,
	( typeExp(Exp, EType) ; { format("cannot type expression ~w\n", [Exp]), fail } ), !,
	{ Type = EType ; format("assignment ~s <- ~s\n", [Type, EType]), fail }, !.

% typeExp(Env, Exp, Type)
typeExp(str(_), str) --> [].
typeExp(int(_), int) --> [].
typeExp(E1 + E2, int) --> typeExp(E1, int), typeExp(E2, int).
typeExp(E1 * E2, int) --> typeExp(E1, int), typeExp(E2, int).
typeExp(var(V), Type) --> varType(V, Type).
