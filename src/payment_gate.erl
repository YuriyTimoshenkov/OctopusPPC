-module(payment_gate).
-author("Yuriy Timoshenkov").
-include("records.hrl").
-export([load/2]).


load(Id, Configuration) ->
  [DbConfig] = [X||{db,X}<-Configuration],
  [DBType] = [X||{db_type,X}<-DbConfig],
  case DBType of
    mongo -> payment_gate_storage_mongodb:load(Id,DbConfig);
    _ -> error_db_not_supported
  end.