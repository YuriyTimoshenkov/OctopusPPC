-module(service).
-author("Yuriy Timoshenkov").
-export([load/1,register_payment/1]).
-include("records.hrl").


load(Id) ->
  #service{id=Id,name=lol, comission= 10}.

register_payment(#payment{}) ->
  ok.
