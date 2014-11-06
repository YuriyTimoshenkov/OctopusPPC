-module(octopusppc_sup).
-author("Yuriy Timoshenkov").
-behaviour(supervisor).
-export([init/1,start_link/0]).


-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    {ok, { {one_for_one, 5, 10},
      [
        {workflow_runtime,
        {workflow_runtime,start_link,[]},
        permanent,
        60000,
        worker,
        [workflow_runtime]}
      ]
    } }.

