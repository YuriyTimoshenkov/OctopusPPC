-module(service).
-author("Yuriy Timoshenkov").
-export([load/1,register_payment/1]).
-include("records.hrl").


load(Id) ->
  {ok, Connection} = mongo:connect(localhost, 27017, <<"OctopusPPC">>),
  {{_,_,_,_,_,Name,_,Commision}} = mongo:find_one(Connection, <<"Service">>, {id,Id}),
  #service{id=Id,name=Name, comission= Commision}.

register_payment(#payment{}) ->
  ok.
