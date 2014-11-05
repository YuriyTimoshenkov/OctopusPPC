##OctopusPPC

###[ Compile ]

1>erl -make


###[ Run ]

1>erl -pa ebin/

2>application:load(octopusppc).
3>application:start(octopusppc).

/*
Account, Amount, Payment Gate Id, Service Id
*/
4>pay('bob@gmail.com', 13.13, 1, 1).


###[ Example ]

1> application:load(octopusppc).
ok

2> application:start(octopusppc).
ok

3> octopusppc:pay('bob@gmail.com', 13.13, 1, 1).
<0.42.0>

4> flush().
Shell got {payment_successful,
              {payment,1,1,13.13,'bob@gmail.com',payment_successful}}
ok


