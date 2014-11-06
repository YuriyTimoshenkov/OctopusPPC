-author("Yuriy Timoshenkov").


-record(payment,{gate_id,service_id,amount=0,account, status=initial}).
-record(workflow,{client_pid,workflow_pid,workflow_monitor_ref,payment}).
-record(service,{id, name, comission}).
-record(payment_gate,{id,name,comission}).
