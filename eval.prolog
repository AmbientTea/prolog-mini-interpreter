:- module(eval, [eval//2, emptyenv/1, declareVar//3, varValue//2, setValue//2, varType//2, nonmember/2]).

nonmember(_, []) :- !.
nonmember(X, [H|T]) :- X \= H, nonmember(X, T).

% var = ( name, (type, value))
emptyenv([]).
declareVar(Id, Type, Value), [[(Id, Type, Value) | Env]] -->
	[Env], { nonmember((Id, _), Env) }.

varValue(Id, Val), [Env] -->
    [Env], { member((Id, _, Val), Env) }.

setValue(Id, Val), [[ (Id, Type, Val) | Env2 ]] -->
    [Env], { selectchk((Id, Type, _), Env, Env2) }.

varType(Id, Type), [Env] -->
    [Env], { member((Id, Type, _), Env) }.

% eval( Env, Exp, Val ).
eval( int(I), I ) --> [].
eval( str(S), S ) --> [].
eval( var(V), Val ) --> varValue(V, Val).
eval( E1 + E2, V ) -->
	eval(E1, V1),
	eval(E2, V2),
	{ V is V1 + V2 }.
eval( E1 * E2, V ) -->
	eval(E1, V1),
	eval(E2, V2),
	{ V is V1 * V2 }.
