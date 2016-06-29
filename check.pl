:- module(check, [check/1]).
:- use_module(eval).

check(Tree) :- emptyenv(Env), check(Env, Tree), !.

check(_, []) :- !.
check(Env, [S|T]) :-
	checkStmt(Env, S, NewEnv),
	check(NewEnv, T).

checkStmt(Env, decl(Type, Id, Exp), NewEnv) :-
	nonmember((Id, _, _), Env) -> (
		typeExp(Env, Exp, EType),
		(Type = EType -> (
			NewEnv = [(Id, Type, _) | Env]
		) ; (
			format("assignment ~s <- ~s", [Type, EType]), !, fail
		))
	) ; (
		format("variable ~s already declared", [Id]), !, fail
	).



% typeExp(Env, Exp, Type)
typeExp(_, str(_), str).
typeExp(_, int(_), int).
typeExp(Env, add(E1, E2), int) :-
	typeExp(Env, E1, int),
	typeExp(Env, E2, int).
typeExp(Env, mul(E1, E2), int) :-
	typeExp(Env, E1, int),
	typeExp(Env, E2, int).
typeExp(Env, var(V), Type) :- member((V, Type, _), Env).
