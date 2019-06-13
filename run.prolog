:- module(run, [run/1]).
:- use_module(eval).

:- use_module(library(dcg_core)).

run(Stmts) :-
    emptyenv(Env),
    seqmap(runStmt, Stmts, Env, _).

runStmt( decl(Type, Id, Exp) ) -->
	eval(Exp, Value),
	declareVar(Id, Type, Value),
	{ writeln(Id = Value) }.
