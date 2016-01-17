:- module(run, [run/1]).
:- use_module(eval).

run(Stmts) :- emptyenv(Env), run(Env, Stmts), !.

run(_, []).
run(Env, [S | T]) :- 
	runStmt(Env, S, NewEnv),
	run(NewEnv, T).

runStmt( Env, decl(Type, Id, Exp), NewEnv ) :-
	eval(Env, Exp, Value),
	declareVar(Env, Id, Type, Value, NewEnv),
	writeln(Id = Value ; NewEnv).
