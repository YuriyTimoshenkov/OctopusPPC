%%%-------------------------------------------------------------------
%%% @author yt
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. Nov 2014 15:17
%%%-------------------------------------------------------------------
-author("yt").


-record(payment,{gate_id,service_id,amount=0,account, status=initial}).
-record(workflow,{clientPid,workflowPid,workflowMonitorRef,payment}).
-record(service,{id, name, comission}).
-record(payment_gate,{id,name,comission}).
