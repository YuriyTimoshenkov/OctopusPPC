%%%-------------------------------------------------------------------
%%% @author yt
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Nov 2014 11:13 PM
%%%-------------------------------------------------------------------
-module(service_storage_mongodb).
-author("yt").
-include("../records.hrl").
%% API
-export([load/2]).


load(Id, Configuration) ->
  [_,{host,Host},{port,Port},{name,Name}] = Configuration,
  {ok, Connection} = mongo:connect(Host, Port, Name),
  {{_,_,_,_,_,ServiceName,_,Commision}} = mongo:find_one(Connection, <<"Service">>, {<<"Id">>,Id}),
  #service{id=Id,name=ServiceName, comission= Commision}.
