-module(octopusppc).

-behaviour(application).

-include("records.hrl").

%% Application callbacks
-export([start/2, stop/1, pay/0, pay/4, getState/0]).


%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    octopusppc_sup:start_link().

stop(_State) ->
    ok.

pay()->
pay('bob@gmail.com', 13.13, 1, 1).

pay(Account, Amount, Gate_id, Service_Id) ->
  gen_server:call(workflow_runtime,{pay,#payment{gate_id=Gate_id,service_id=Service_Id,amount=Amount,account=Account}}).


getState()->
  gen_server:call(workflow_runtime,getState).
