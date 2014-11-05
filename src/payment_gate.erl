%%%-------------------------------------------------------------------
%%% @author yt
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. Nov 2014 9:33
%%%-------------------------------------------------------------------
-module(payment_gate).
-author("yt").
-include("records.hrl").
-export([load/1]).

%% API
-export([]).

load(Id) ->
  #payment_gate{id= Id, name = pg1, comission = 5}.