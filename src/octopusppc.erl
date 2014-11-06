-module(octopusppc).
-author("Yuriy Timoshenkov").
-behaviour(application).
-include("records.hrl").
-export([start/2, stop/1, pay/0, pay/4, getState/0]).


start(_StartType, _StartArgs) ->
  Dispatch = cowboy_router:compile([
    {'_', [
      {"/", toppage_handler, []}
    ]}
  ]),
  {ok, _} = cowboy:start_http(http, 100, [{port, 8083}], [
    {env, [{dispatch, Dispatch}]}
  ]),
  octopusppc_sup:start_link().

stop(_State) ->
    ok.

pay()->
pay('bob@gmail.com', 13.13, 1, 1).

pay(Account, Amount, GateId, ServiceId) ->
  gen_server:call(workflow_runtime,{pay,#payment{gate_id=GateId,service_id=ServiceId,amount=Amount,account=Account}}).


getState()->
  gen_server:call(workflow_runtime,getState).
