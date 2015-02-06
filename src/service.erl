-module(service).
-author("Yuriy Timoshenkov").
-export([load/2,register_payment/4]).
-include("records.hrl").


load(Id, Configuration) ->
  [DbConfig] = [X||{db,X}<-Configuration],
  [DBType] = [X||{db_type,X}<-DbConfig],
  case DBType of
    mongo -> service_storage_mongodb:load(Id,DbConfig);
    _ -> error_db_not_supported
  end.


register_payment(Payment = #payment{}, Service = #service{merchant_type = <<"Shopify">>}, _, OperationId) ->
  [Url] = [X||{url,X}<-Service#service.configuration],

  RequestBody = jiffy:encode({[{
      transaction,{[
        {amount, Payment#payment.service_amount},
        {kind,capture}
      ]}
    }]}),

  error_logger:info_msg("OpId: [~p]. Service request has been sent [~p]",
    [uuid:to_string(OperationId), RequestBody]),


  FullUrl = re:replace(binary_to_list(Url), ":order_id", Payment#payment.account, [global,{return, binary}]),

   ibrowse:send_req(binary_to_list(FullUrl), [], post, RequestBody,[{stream_to, self()}]),

  receive
    {ibrowse_async_headers,_,200,_} ->

      receive
        {ibrowse_async_response,_,ResponseBody} ->
          error_logger:info_msg("OpId: [~p]. Service response has been received [~p]",
            [uuid:to_string(OperationId), ResponseBody]),
          ok
        after 5000 -> false
      end

      after 5000 -> false
  end.

