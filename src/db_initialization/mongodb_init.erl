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
  [_,{host,_},{port,_},{name,Name}] = Configuration,
  {ok, Connection} = mongo:connect(Name),
  mongo:insert(Connection, <<"Service">>,
    [
      {<<"Id">>,1,
        <<"Name">>, <<"TestService1">>,
        <<"Discount">>, 5,
        <<"MerchantType">>, <<"Shopify">>,
        <<"Configuration">>, [{<<"url">>,<<"http://localhost:8083/shopify/:order_id/createorder">>,<<"signkey">>,<<"3DSde33dsd##4ff">>}]
      }
    ]),
  mongo:insert(Connection, <<"PaymentGate">>,
    [
      {<<"Id">>,1,
        <<"Name">>, <<"test">>,
        <<"Comission">>, 2
      }
    ]),
  ok.


