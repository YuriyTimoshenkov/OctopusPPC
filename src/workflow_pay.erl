%%%-------------------------------------------------------------------
%%% @author yt
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Oct 2014 13:26
%%%-------------------------------------------------------------------
-module(workflow_pay).
-behaviour(gen_fsm).
-include("records.hrl").
-export([start/1,stop/0,init/1,initial/2, transactionCreated/2, terminate/3]).


start({P = #payment{}, WfrPid}) -> gen_fsm:start({local, workflow_pay}, workflow_pay, {P, WfrPid}, []).


stop()  -> gen_fsm:send_all_state_event(hello, stopit).


init({P = #payment{}, WfrPid}) ->
  gen_fsm:send_event(workflow_pay, createTransaction),
  {ok, initial, {P, WfrPid}}.

initial(createTransaction, {P = #payment{}, WfrPid}) ->
  case (payment:validate(P)) of
    {#service{}, #payment_gate{}} ->
      payment:save(P),
      gen_fsm:send_event(self(), registerWithMerchant),
      {next_state, transactionCreated, {P, WfrPid}};
    false ->
      change_payment_state({P, WfrPid, payment_failed})
  end.



transactionCreated(registerWithMerchant, {P = #payment{}, WfrPid}) ->
  case (service:register_payment(P)) of
    ok ->
      change_payment_state({P, WfrPid, payment_successful});
    _ ->
      change_payment_state({P, WfrPid, payment_failed})
  end.

change_payment_state({P = #payment{}, WfrPid, NewState}) ->
  PFinal = P#payment{status = NewState},
  gen_server:call(WfrPid, {NewState, PFinal}),
  payment:save(PFinal),
  {stop, normal, {PFinal, wfrPid}}.


terminate(normal, _StateName, _StateData) ->
  ok.
