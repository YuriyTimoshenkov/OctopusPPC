-module(payment).
-author("Yuriy Timoshenkov").
-include("records.hrl").
-export([save/1,validate/1]).



save(P = #payment{}) ->
  case (P#payment.id) of
    undefined ->
      {ok, Connection} = mongo:connect(localhost, 27017, <<"OctopusPPC">>),
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

validate(P = #payment{}) ->
  case(service:load(P#payment.service_id)) of
    S = #service{} ->
      case(payment_gate:load(P#payment.gate_id)) of
        Pg = #payment_gate{} -> {S,Pg};
        empty -> false
      end;
    empty -> false
  end.




