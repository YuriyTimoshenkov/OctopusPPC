-module(octopusppc).
-author("Yuriy Timoshenkov").
-behaviour(application).
-include("records.hrl").
-export([start/2, stop/1, pay/0, pay/4, get_state/0, init_db/0]).


start(_StartType, _StartArgs) ->
  {ok,AppConfig} = application:get_env(octopusppc,app_config),
  lists:foreach(fun(App) ->
    ok = application:start(App)
  end,
    [crypto,
      ranch,
      cowlib, cowboy,bson,mongodb]),

  Dispatch = cowboy_router:compile([
    {'_', [
      {"/", http_handler, []}
    ]}
  ]),
  {ok, _} = cowboy:start_http(http, 100, [{port, 8083}], [
    {env, [{dispatch, Dispatch}]}
  ]),
  octopusppc_sup:start_link(AppConfig).

stop(_State) ->
    ok.

pay()->
pay('bob@gmail.com', 13.13, 1, 1).

pay(Account, Amount, GateId, ServiceId) ->
  gen_server:call(workflow_runtime,{pay,#payment{gate_id=GateId,service_id=ServiceId,client_amount=Amount,account=Account}}).


get_state()->
  gen_server:call(workflow_runtime,getState).

init_db() ->
  {ok,AppConfig} = application:get_env(octopusppc,app_config),
  db_init:init(AppConfig).
