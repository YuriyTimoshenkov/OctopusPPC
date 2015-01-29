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
  {ok, Connection} = mongo:connect(Host, Port, Name),
  case (P#payment.id) of
    undefined ->
      [Result] = mongo:insert(Connection, <<"Payment">>,
        [
          {service_id,P#payment.service_id,
            payment_gate_id, P#payment.gate_id,
            account, P#payment.account,
            status, P#payment.status,
            client_amount, P#payment.client_amount,
            payment_gate_commission, P#payment.payment_gate_commission,
            service_discount, P#payment.service_discount,
            service_amount, P#payment.service_amount
          }
        ]),
      PaymentId = element(tuple_size(Result),Result),
      P#payment{id = PaymentId};
    _ ->
      Command = {'$set', {
        status, P#payment.status
      }},
      mongo:update(Connection, <<"Payment">>, {'_id', P#payment.id}, Command)
  end.