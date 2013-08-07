%%
%% Copyright (C) 2011 by krasnop@bellsouth.net (Alexei Krasnopolski)
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License. 
%%

%% @since 2011-06-13
%% @copyright 2011 Alexei Krasnopolski
%% @author Alexei Krasnopolski <krasnop@bellsouth.net> [http://crasnopolski.com/]
%% @version {@version}
%% @doc 
%% This is a main module of AOP for Erlang tool. 
%% The module contains exported function compile/2 and compile/3.
%%
%% @reference [http://static.springsource.org/spring/docs/2.0.8/reference/aop.html]
%% @headerfile "aop.hrl"
-module(aop).

%%
%% Include files
%%

-include("rebar.hrl").

%%
%% Import modules
%%
-import(compile, []).
-import(filelib, []).
-import(file, []).
-import(lists, []).

%%
%% Exported Functions
%%
-export([read_adf/1]).

%%
%% API Functions
%%

%% @spec read_adf(Files::list()) -> list(#aspect{})
%% @throws nothing
%% @doc reads adf file and converts its content to Erlang term.
read_adf(File) ->
    ?DEBUG("AOP adf file  = ~p~n", [File]),
    As = {'Aspect', fun(Ad, Pcs) -> {aspect, Ad, Pcs} end},
    Pc = {'Pointcut', fun(M,F,A,S) -> {pointcut, M, F, A, S} end},
    Ad = {'Advice', fun(T, M, F) -> {advice, T, M, F} end},
    Bindings = [Ad,As,Pc],
    case file:script(File, Bindings) of
        {ok, S} ->
            ?DEBUG("AOP config = ~p~n", [S]),
            S;
        {error, Error} -> 
            ?DEBUG("Read adf error = ~p~n~p~n~p~n", [Error, File, Bindings]), 
            []
    end.

