-module(billing_calculator).
-author("yt").
-include("records.hrl").
-export([calculate/3]).

calculate(P = #payment{}, Service = #service{}, PaymentGate = #payment_gate{})->
  ServiceAmount = P#payment.client_amount*(100-Service#service.discount)/100,
  NewPayment = P#payment{
    payment_gate_commission = PaymentGate#payment_gate.comission,
    service_discount = Service#service.discount,
    service_amount = ServiceAmount
  },
  NewPayment.