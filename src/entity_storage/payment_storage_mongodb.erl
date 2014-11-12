%%%-------------------------------------------------------------------
%%% @author yt
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Nov 2014 2:05 PM
%%%-------------------------------------------------------------------
-module(payment_storage_mongodb).
-author("yt").
-include("../records.hrl").

%% API
-export([save/2]).



save(P = #payment{}, Configuration) ->
  [_,{host,Host},{port,Port},{name,Name}] = Configuration,
  case (P#payment.id) of
    undefined ->
      {ok, Connection} = mongo:connect(Host, Port, Name),
      [Result] = mongo:insert(Connection, <<"Payment">>,
        [
          {service_id,P#payment.service_id,
            payment_gate_id, P#payment.gate_id,
            account, P#payment.account,
            amount, P#payment.amount,
            status, P#payment.status}
        ]),
      PaymentId = element(tuple_size(Result),Result),
      P#payment{id = PaymentId};
    _ -> ok
  end.