%%%-------------------------------------------------------------------
%%% @author yt
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. Nov 2014 6:21 PM
%%%-------------------------------------------------------------------
-module(mongodb_init).
-author("yt").

%% API
-export([init/1]).

init(Configuration) ->
  [_,{host,Host},{port,Port},{name,Name}] = Configuration,
  {ok, Connection} = mongo:connect(Host, Port, Name),
  mongo:insert(Connection, <<"Service">>,
    [
      {<<"Id">>,1,
        <<"Name">>, test,
        <<"Discount">>, 5
      }
    ]),
  mongo:insert(Connection, <<"PaymentGate">>,
    [
      {<<"Id">>,1,
        <<"Name">>, test,
        <<"Comission">>, 2
      }
    ]),
  ok.


