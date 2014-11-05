%%%-------------------------------------------------------------------
%%% @author yt
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. Nov 2014 18:10
%%%-------------------------------------------------------------------
-module(service).
-author("yt").
-export([load/1,register_payment/1]).

-include("records.hrl").

%% API
-export([]).

load(Id) ->
  #service{id=Id,name=lol, comission= 10}.

register_payment(#payment{}) ->
  ok.
