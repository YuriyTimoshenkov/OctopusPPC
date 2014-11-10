-module(service).
-author("Yuriy Timoshenkov").
-export([load/2,register_payment/1]).
-include("records.hrl").


load(Id, Configuration) ->
  {db,[{db_type,DBType}|_]} = Configuration,
  case DBType of
    mongo -> service_storage_mongodb:load(Id,Configuration);
    _ -> error_db_not_supported
  end.


register_payment(#payment{}) ->
  ok.
