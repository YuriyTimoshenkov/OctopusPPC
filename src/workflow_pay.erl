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
-export([start/1,stop/0,init/1,initial/2, transaction_created/2, terminate/3]).


start({P = #payment{}, WfrPid, Configuration}) -> gen_fsm:start({local, workflow_pay}, workflow_pay, {P, WfrPid, Configuration}, []).


stop()  -> gen_fsm:send_all_state_event(hello, stopit).


init({P = #payment{}, WfrPid, Configuration}) ->
  gen_fsm:send_event(workflow_pay, create_transaction),
  {ok, initial, {P, WfrPid, Configuration}}.

initial(create_transaction, {P = #payment{}, WfrPid, Configuration}) ->
  case (payment:validate(P,Configuration)) of
    {#service{}, #payment_gate{}} ->
      P2 = payment:save(P, Configuration),
      gen_fsm:send_event(self(), register_with_merchant),
      {next_state, transaction_created, {P2, WfrPid}};
    false ->
      change_payment_state({P, WfrPid, payment_failed})
  end.



transaction_created(register_with_merchant, {P = #payment{}, WfrPid}) ->
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
