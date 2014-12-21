-module(service).
-author("Yuriy Timoshenkov").
-export([load/2,register_payment/3]).
-include("records.hrl").


load(Id, Configuration) ->
  [DbConfig] = [X||{db,X}<-Configuration],
  [DBType] = [X||{db_type,X}<-DbConfig],
  case DBType of
    mongo -> service_storage_mongodb:load(Id,DbConfig);
    _ -> error_db_not_supported
  end.


register_payment(Payment = #payment{}, Service = #service{name = <<"test">>}, PaymentGate = #payment_gate{}) ->
  [Url] = [X||{url,X}<-Service#service.configuration],
  [SignKey] = [X||{sign_key,X}<-Service#service.configuration],
  io:fwrite("Payment with amount <~p>, using gate <~p> to service <~p>, url is <~p>, sign_key is <~p>",
    [Payment#payment.service_amount, PaymentGate#payment_gate.name, Service#service.name, Url, SignKey]),
  RequestBody = jiffy:encode({[{
      transaction,{[
        {amount, Payment#payment.service_amount},
        {kind,capture}
      ]}
    }]}),
  FullUrl = re:replace(binary_to_list(Url), ":order_id", "666", [global,{return, binary}]),
  {ok, _, _, ResponseBody} = ibrowse:send_req(binary_to_list(FullUrl), [], post, RequestBody),
  io:fwrite("Payment response is: ~p ~n",[ResponseBody]),
  ok.
