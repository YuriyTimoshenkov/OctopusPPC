-module(payment).
-author("Yuriy Timoshenkov").
-include("records.hrl").
-export([save/2,validate/2]).



save(P = #payment{}, Configuration) ->
  [DbConfig] = [X||{db,X}<-Configuration],
  [DBType] = [X||{db_type,X}<-DbConfig],
  case DBType of
    mongo -> payment_storage_mongodb:save(P, DbConfig);
    _ -> error_db_not_supported
  end.

validate(P = #payment{},Configuration) ->
  case(service:load(P#payment.service_id, Configuration)) of
    S = #service{} ->
      case(payment_gate:load(P#payment.gate_id, Configuration)) of
        Pg = #payment_gate{} -> {S,Pg};
        empty -> false
      end;
    empty -> false
  end.




