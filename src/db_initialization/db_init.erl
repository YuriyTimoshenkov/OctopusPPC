%%%-------------------------------------------------------------------
%%% @author yt
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. Nov 2014 5:05 PM
%%%-------------------------------------------------------------------
-module(db_init).
-author("yt").

%% API
-export([init/1]).


init(Configuration) ->
  [DbConfig] = [X||{db,X}<-Configuration],
  [DBType] = [X||{db_type,X}<-DbConfig],
  case DBType of
    mongo -> mongodb_init:init(DbConfig);
    _ -> error_db_not_supported
  end.