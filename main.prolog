#!/usr/bin/env swipl

:- use_module(parser).
:- use_module(eval).
:- use_module(run).
:- use_module(check).


:-
    ( current_prolog_flag(argv, [File | _])
    ; write(user_error, "Missing filename\n"), halt),
    
    ( parse(File, Tree)
    ; write(user_error, "Parsing error\n"), halt ),
    
    ( check(Tree)
    ; write(user_error, "Type checking failed\n"), halt ),
    
    run(Tree),
    
    halt.

:- halt. % exit, do not fall back to prompt on exceptions
