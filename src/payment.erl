%%%-------------------------------------------------------------------
%%% @author yt
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. Nov 2014 20:21
%%%-------------------------------------------------------------------
-module(payment).
-author("yt").
-include("records.hrl").
-export([save/1,validate/1]).



save(#payment{}) ->
  ok.

validate(P = #payment{}) ->
  case(service:load(P#payment.service_id)) of
    S = #service{} ->
      case(payment_gate:load(P#payment.gate_id)) of
        Pg = #payment_gate{} -> {S,Pg};
        empty -> false
      end;
    empty -> false
  end.




