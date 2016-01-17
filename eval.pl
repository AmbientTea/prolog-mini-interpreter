:- module(eval, [eval/3, emptyenv/1, declareVar/5, varValue/3, setValue/4, varType/3, nonmember/2]).

nonmember(_, []) :- !.
nonmember(X, [H|T]) :- X \= H, nonmember(X, T).

% var = ( name, (type, value))
emptyenv([]).
declareVar(Env, Id, Type, Value, NewEnv) :-
	nonmember((Id, _), Env),
	NewEnv = [(Id, Type, Value) | Env].
varValue(Env, Id, Val) :- member((Id, _, Val), Env).
setValue(Env, Id, Val, NewEnv) :-
	selectchk((Id, Type, _), Env, Env2),
	NewEnv = [ (Id, Type, Val) | Env2 ].
varType(Env, Id, Type) :- member((Id, Type, _), Env).

% eval( Env, Exp, Val ).
eval( _, int(I), I ).
eval( _, str(S), S ).
eval( Env, var(V), Val ) :- varValue(Env, V, Val).
eval( Env, add(E1, E2), V ) :-
	eval(Env, E1, V1),
	eval(Env, E2, V2),
	V is V1 + V2.
eval( Env, mul(E1, E2), V ) :-
	eval(Env, E1, V1),
	eval(Env, E2, V2),
	V is V1 * V2.
