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

-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, code_change/3, terminate/2]).

-include("records.hrl").

start_link(Configuration) ->
  gen_server:start_link({local, workflow_runtime}, workflow_runtime,Configuration,[]).

init(Configuration) ->
  {ok,{[],Configuration}}.


handle_call({pay, P = #payment{}, OperationId}, _From, State) ->
  {PaymentList,Configuration} = State,
  {ok, WPid} = workflow_pay:start({P, self(),Configuration, OperationId}),
  WMRef = erlang:monitor(process,WPid),
  {ClientPid, _} = _From,
  {reply, WPid,
    {
      [{WPid,#workflow{client_pid = ClientPid, workflow_pid = WMRef, workflow_monitor_ref = WMRef, payment = P}}| PaymentList],
      Configuration
    }};

handle_call(get_state, _From, State) ->
  {reply, State, State};

handle_call({Payment_result, P = #payment{}}, _From, State) ->
  {WorkflowPid, _} = _From,
  {PaymentList,Configuration} = State,
  {_,Workflow = #workflow{}} = lists:keyfind(WorkflowPid, 1, PaymentList),
  CallerPid = Workflow#workflow.client_pid,
  WorkflowRef = Workflow#workflow.workflow_monitor_ref,
  erlang:demonitor(WorkflowRef),
  CallerPid ! {Payment_result, P},
  NewPaymentList = lists:keydelete(_From, 1, PaymentList),
  {reply, ok, {NewPaymentList,Configuration}}.


handle_info({'DOWN', _, process, _Pid, _}, State) ->
    {PaymentList,Configuration} = State,
    {_,Workflow = #workflow{}} = lists:keyfind(_Pid, 1, PaymentList),
    CallerPid = Workflow#workflow.client_pid,
    CallerPid ! {payment_failed,Workflow#workflow.payment},
    NewPaymentList = lists:keydelete(_Pid, 1, PaymentList),
    {noreply, {NewPaymentList, Configuration}}.


handle_cast(_, State) ->
  {noreply, State}.

code_change(_,_,_) -> ok.

terminate(_,_) -> ok.

