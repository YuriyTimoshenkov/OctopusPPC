-author("Yuriy Timoshenkov").


-record(payment,{id,gate_id,service_id,client_amount=0,payment_gate_commission=0, service_discount=0, service_amount=0,account, status=initial}).
-record(workflow,{client_pid,workflow_pid,workflow_monitor_ref,payment}).
-record(service,{id, name, discount}).
-record(payment_gate,{id,name,comission}).
