-module(payment).
-author("Yuriy Timoshenkov").
-include("records.hrl").
-export([save/1,validate/1]).



save(#payment{}) ->
  ok.

validate(P = #payment{}) ->
  case(service:load(P#payment.service_id)) of
    S = #service{} ->
      case(payment_gate:load(P#payment.gate_id)) of
        Pg = #payment_gate{} -> {S,Pg};
        empty -> false
      end;
    empty -> false
  end.




