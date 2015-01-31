%%%-------------------------------------------------------------------
%%% @author yt
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Nov 2014 11:13 PM
%%%-------------------------------------------------------------------
-module(payment_gate_storage_mongodb).
-author("yt").
-include("../records.hrl").
%% API
-export([load/2]).


load(Id, Configuration) ->
  [_,{host,_},{port,_},{name,Name}] = Configuration,
  {ok, Connection} = mongo:connect(Name),
  {{_,_,_,PaymentGateName,_,Commission,_,_}} = mongo:find_one(Connection, <<"PaymentGate">>, {<<"Id">>,Id}),
  %gen_server:call(Connection,{stop, bob}),
  #payment_gate{id=Id,name=PaymentGateName, comission=Commission}.
