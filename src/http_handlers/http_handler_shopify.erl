%% Feel free to use, reuse and abuse the code in this file.

%% @doc Hello world handler.
-module(http_handler_shopify).
-include("../records.hrl").
-export([init/2]).

init(Req, Opts) ->
  OrderId = list_to_integer(bitstring_to_list(cowboy_req:binding(order_id, Req))),
  {ok, Body, Req2} = cowboy_req:body(Req),

  Transaction = jiffy:decode(Body),
  {[{_,{[{_,Amount},_]}}]} = Transaction,

  ReqResult = 	cowboy_req:reply(200, [
    {<<"content-type">>, <<"application/json; charset=utf-8">>}
  ], io_lib:format("{
  \"transaction\": {
    \"amount\": ~p,
    \"authorization\": null,
    \"created_at\": \"2014-11-20T13:45:30-05:00\",
    \"currency\": \"USD\",
    \"gateway\": \"bogus\",
    \"id\": 999225638,
    \"kind\": \"capture\",
    \"location_id\": null,
    \"message\": \"Bogus Gateway: Forced success\",
    \"order_id\": ~p,
    \"parent_id\": 389404469,
    \"source_name\": \"755357713\",
    \"status\": \"success\",
    \"test\": true,
    \"user_id\": null,
    \"device_id\": null,
    \"receipt\": {},
    \"error_code\": null
  }
}",[Amount, OrderId]), Req2),
  {ok, ReqResult, Opts}.


