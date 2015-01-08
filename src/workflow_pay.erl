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
-export([start/1,stop/0,init/1,initial/2, transaction_created/2, terminate/3, handle_sync_event/4, handle_info/3, code_change/3,code_change/4, handle_event/3]).


start({P = #payment{}, WfrPid, Configuration}) -> gen_fsm:start(workflow_pay, {P, WfrPid, Configuration}, []).


stop()  -> gen_fsm:send_all_state_event(hello, stopit).


init({P = #payment{}, WfrPid, Configuration}) ->
  gen_fsm:send_event(self(), create_transaction),
  {ok, initial, {P, WfrPid, Configuration}}.

initial(create_transaction, {P = #payment{}, WfrPid, Configuration}) ->
  case (payment:validate(P,Configuration)) of
    {Service = #service{}, PaymentGate = #payment_gate{}} ->
      P2 = billing_calculator:calculate(P,Service,PaymentGate),
      P3 = payment:save(P2, Configuration),
      gen_fsm:send_event(self(), register_with_merchant),
      {next_state, transaction_created, {{P3,Service, PaymentGate}, WfrPid, Configuration}};
    false ->
      change_payment_state({P, WfrPid, Configuration, payment_failed})
  end.



transaction_created(register_with_merchant, {{P = #payment{}, Service = #service{}, PaymentGate = #payment_gate{}}, WfrPid, Configuration}) ->
  case (service:register_payment(P, Service, PaymentGate )) of
    ok ->
      change_payment_state({P, WfrPid, Configuration, payment_successful});
    _ ->
      change_payment_state({P, WfrPid, Configuration, payment_failed})
  end.

change_payment_state({P = #payment{}, WfrPid, Configuration, NewState}) ->
  PFinal = P#payment{status = NewState},
  payment:save(PFinal, Configuration),
  gen_server:call(WfrPid, {NewState, PFinal}),
  {stop, normal, {PFinal, wfrPid}}.


terminate(_,_,_) ->
  ok.

code_change(_,_,_) -> ok.

code_change(_,_,_,_) -> ok.

handle_event(_,_,_) -> ok.

handle_info(_,_,_) -> ok.

handle_sync_event(_,_,_,_) -> ok.
