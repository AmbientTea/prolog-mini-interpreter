#!/usr/bin/env swipl

:- use_module(parser).
:- use_module(eval).
:- use_module(run).
:- use_module(check).


:-
    current_prolog_flag(argv, [File | _]),
    ( parse(File, Tree) ; halt ),
    ( check(Tree) ; halt ),
    run(Tree),
    halt.

:- halt.
