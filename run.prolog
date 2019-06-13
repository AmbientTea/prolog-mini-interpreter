:- module(run, [run/1]).
:- use_module(eval).

run(Stmts) :- emptyenv(Env), run(Stmts, [Env], _), !.

run([]) --> [].
run([S | T]) --> runStmt(S), !, run(T).

runStmt( decl(Type, Id, Exp) ) -->
	eval(Exp, Value),
	declareVar(Id, Type, Value),
	{ writeln(Id = Value) }.
