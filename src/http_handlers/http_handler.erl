%% Feel free to use, reuse and abuse the code in this file.

%% @doc Hello world handler.
-module(http_handler).
-include("../records.hrl").
-export([init/2]).
-compile([{parse_transform, lager_transform}]).

init(Req, Opts) ->
  OperationId = uuid:uuid4(),
  error_logger:info_msg("OpId: [~p]. Request received: [~p]",
    [uuid:to_string(OperationId),cowboy_req:qs(Req)]),

  #{
    gate_id := GateId,
    service_id := ServiceId,
    amount := Amount,
    account := Account} =
    cowboy_req:match_qs([gate_id, service_id, amount, account], Req),

  {PaymentResult,PaymentStatus} = process_payment(
    list_to_integer(bitstring_to_list(GateId)),
    list_to_integer(bitstring_to_list(ServiceId)),
    list_to_float(bitstring_to_list(Amount)), Account, OperationId),

  ResponseBody = jiffy:encode({[{status,PaymentResult},{description,PaymentStatus}]}),

  ReqResult = 	cowboy_req:reply(200, [
    {<<"content-type">>, <<"application/json; charset=utf-8">>}
  ], ResponseBody, Req),

  error_logger:info_msg("OpId: [~p]. Response sent: [~p]",
    [uuid:to_string(OperationId),ResponseBody]),


  {ok, ReqResult, Opts}.

process_payment(GateId, ServiceId, Amount, Account, OperationId) ->
  octopusppc:pay(Account, Amount, GateId, ServiceId, OperationId),
  receive
    {payment_successful, #payment{}} -> {ok,payment_successful};
    {PaymentStatus, #payment{}} -> {failed,PaymentStatus}
    after 1000 -> {failed, timeout_exceeded}
  end.


