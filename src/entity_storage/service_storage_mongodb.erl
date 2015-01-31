%%%-------------------------------------------------------------------
%%% @author yt
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Nov 2014 11:13 PM
%%%-------------------------------------------------------------------
-module(service_storage_mongodb).
-author("yt").
-include("../records.hrl").
%% API
-export([load/2]).



load(Id, Configuration) ->
  [_,{host,_},{port,_},{name,Name}] = Configuration,
  {ok, Connection} = mongo:connect(Name),
  {{_,_,'Name',ServiceName,_,Discount,'MerchantType',MerchantType,_,[{_,Url,_,SignKey}],_,_}} = mongo:find_one(Connection, <<"Service">>, {<<"Id">>,Id}),
  %gen_server:call(Connection,{stop, bob}),
  #service{id=Id,name=ServiceName, discount=Discount,configuration = [{url,Url},{sign_key,SignKey}], merchant_type = MerchantType}.
