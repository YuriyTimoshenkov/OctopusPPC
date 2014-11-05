%%%-------------------------------------------------------------------
%%% @author yt
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. Oct 2014 17:42
%%%-------------------------------------------------------------------
-module(workflow_runtime).
-author("yt").
-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2]).

-include("records.hrl").

start_link() ->
  gen_server:start_link({local, workflow_runtime}, workflow_runtime,[],[]).

init([]) ->
  {ok,[]}.


handle_call({pay, P = #payment{}}, _From, State) ->
  {ok, WPid} = workflow_pay:start({P, self()}),
  WMRef = erlang:monitor(process,WPid),
  {ClientPid, _} = _From,
  {reply, WPid, [{WPid,#workflow{clientPid = ClientPid, workflowPid = WMRef, workflowMonitorRef = WMRef, payment = P}}| State]};

handle_call(getState, _From, State) ->
  {reply, State, State};

handle_call({Payment_result, P = #payment{}}, _From, State) ->
  {WorkflowPid, _} = _From,
  {_,Workflow = #workflow{}} = lists:keyfind(WorkflowPid, 1, State),
  CallerPid = Workflow#workflow.clientPid,
  WorkflowRef = Workflow#workflow.workflowMonitorRef,
  erlang:demonitor(WorkflowRef),
  CallerPid ! {Payment_result, P},
  NewState = lists:keydelete(_From, 1, State),
  {reply, ok, NewState}.


handle_info({'DOWN', _, process, _Pid, _}, State) ->
    {_,Workflow = #workflow{}} = lists:keyfind(_Pid, 1, State),
    CallerPid = Workflow#workflow.clientPid,
    CallerPid ! {payment_failed,Workflow#workflow.payment},
    NewState = lists:keydelete(_Pid, 1, State),
    {noreply, NewState}.


handle_cast(_, State) ->
  {noreply, State}.

