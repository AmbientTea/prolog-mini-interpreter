:- module(eval, [eval//2, emptyenv/1, declareVar//3, varValue//2, setValue//2, varType//2, nonmember/2]).

:- use_module(library(dcg_core)).

nonmember(_, []) :- !.
nonmember(X, [H|T]) :- X \= H, nonmember(X, T).

% var = ( name, (type, value))
emptyenv([]).
declareVar(Id, Type, Value) -->
	get(Env),
	{ nonmember((Id, _), Env) },
	set([(Id, Type, Value) | Env]).

varValue(Id, Val) -->
    get(Env),
    { member((Id, _, Val), Env) }.

setValue(Id, Val) -->
    get(Env),
    { selectchk((Id, Type, _), Env, Env2) },
    set([ (Id, Type, Val) | Env2 ]).

varType(Id, Type) -->
    get(Env),
    { member((Id, Type, _), Env) }.

% eval( Env, Exp, Val ).
eval( int(I), I ) --> nop.
eval( str(S), S ) --> nop.
eval( var(V), Val ) --> varValue(V, Val).
eval( E1 + E2, V ) -->
	eval(E1, V1),
	eval(E2, V2),
	{ V is V1 + V2 }.
eval( E1 * E2, V ) -->
	eval(E1, V1),
	eval(E2, V2),
	{ V is V1 * V2 }.
