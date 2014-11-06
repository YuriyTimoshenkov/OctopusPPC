-module(payment_gate).
-author("Yuriy Timoshenkov").
-include("records.hrl").
-export([load/1]).


load(Id) ->
  #payment_gate{id= Id, name = pg1, comission = 5}.