-module(service).
-author("Yuriy Timoshenkov").
-export([load/2,register_payment/1]).
-include("records.hrl").


load(Id, Configuration) ->
  [DbConfig] = [X||{db,X}<-Configuration],
  [DBType] = [X||{db_type,X}<-DbConfig],
  case DBType of
    mongo -> service_storage_mongodb:load(Id,DbConfig);
    _ -> error_db_not_supported
  end.


register_payment(#payment{}) ->
  ok.
