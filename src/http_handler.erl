%% Feel free to use, reuse and abuse the code in this file.

%% @doc Hello world handler.
-module(http_handler).
-include("records.hrl").
-export([init/2]).

init(Req, Opts) ->
  #{gate_id := GateId, service_id := ServiceId, amount := Amount, account := Account} =
    cowboy_req:match_qs([gate_id, service_id, amount, account], Req),

  PaymentResult = process_payment(GateId, ServiceId, Amount, Account),

  ReqResult = 	cowboy_req:reply(200, [
    {<<"content-type">>, <<"application/json; charset=utf-8">>}
  ], PaymentResult, Req),
  {ok, ReqResult, Opts}.

process_payment(GateId, ServiceId, Amount, Account) ->
  octopusppc:pay(Account, Amount, GateId, ServiceId),
  receive
    {payment_successful, #payment{}} -> payment_result_to_json(ok,payment_successful);
    {PaymentStatus, #payment{}} -> payment_result_to_json(failed,PaymentStatus)
    after 1000 -> payment_result_to_json(failed, "Timeout exceeded")
  end.

payment_result_to_json(Status,Description) ->
  io_lib:format("{\"status\":\"~p\",\"description\":\"~p\"}",[Status, Description]).

