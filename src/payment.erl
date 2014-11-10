-module(payment).
-author("Yuriy Timoshenkov").
-include("records.hrl").
-export([save/2,validate/2]).



save(P = #payment{}, Configuration) ->
  {db,[{db_type,DBType}|_]} = Configuration,
  case DBType of
    mongo -> payment_storage_mongodb:save(P, Configuration);
    _ -> error_db_not_supported
  end.

validate(P = #payment{},Configuration) ->
  case(service:load(P#payment.service_id, Configuration)) of
    S = #service{} ->
      case(payment_gate:load(P#payment.gate_id)) of
        Pg = #payment_gate{} -> {S,Pg};
        empty -> false
      end;
    empty -> false
  end.




