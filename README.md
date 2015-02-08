##Octopus PPC

######As Is
Tiny Payment Processing Center engine with support of:
- payment by account, order
  - API & workflow implemented
  - billing calculator with static formula
  - payment of [Shopify](http://docs.shopify.com/) orders (exmaple of online shop integration)
- DB integration: mongo db
- no custom partners API
- possibility of integration with custom merchant api and configuration
- logging system with log processing engine build on top of
  - [elasticsearch](http://www.elasticsearch.org/overview/)
  - [Graylog2](https://www.graylog.org/)

<br/>

######To Be
Payment Processing Center with support of:
- different types of payment gates
- custom Octopus API
- popular online shops integration
- security
- DSL for billing calculation
- high performance
- no UI for configuration & support

<br/>
![Logo] (https://lh6.googleusercontent.com/-lD0e5fK-r-A/VKJk_U9RbcI/AAAAAAAAAos/3j8ISXskTjc/w960-h540-no/PaymentSystemScenario.png)


<br/>
###Common payment scenarios

##### By account using kiosk
1. Check your personal account in the merchant service
2. Go to the kiosk
3. Find and choose needed merchant service
4. Input your account number
5. Put cash in
6. Press "Pay" button

###### That's all - your account has been successfully credited!  
<br/>

##### By order using online banking
1. Make an order in the online shop and press "Pay" button
2. You will be redirected to the online banking private cabinet
3. Check payment sum and press "Pay" button

###### That's all - your order has been successfully paid!
<br/>

###Quick start

####Clone git repo

####Build processing center 

```sh
> make all
```

####Init db

```sh
> ./_rel/octopusppc_release/bin/octopusppc_release console
> octopusppc:init_db().
```

####Execute http GET request

http://localhost:8083/?gate_id=1&service_id=1&amount=13.3&account=777666777

####And you will receive response

```
{"status":"ok","description":"payment_successful"}
```

####Check transaction in db

Check Payment collection in db OctopusPPC 
<br/>


###Logging system
#####Consists of
- logger, which collects and writes log with different levels(info, warning, error)
- log index, which provide user with fast searching through the log messages and pretty web user interface 
- two log messages destanation support
  - Graylog2
  - Syslog

#####Examle of Syslog messages by one transaction
```sh
2015-02-05 02:57:38.317 [info] <0.206.0> OpId: ["df5a9f09-0aa4-416a-8686-33116c144858"]. Request received: [<<"gate_id=1&service_id=1&amount=13.3&account=777666777">>]
2015-02-05 02:57:38.317 [info] <0.234.0> OpId: ["df5a9f09-0aa4-416a-8686-33116c144858"]. Workflow Pay has been started.
2015-02-05 02:57:38.317 [info] <0.206.0> OpId: ["df5a9f09-0aa4-416a-8686-33116c144858"]. Response sent: [<<"{\"status\":\"failed\",\"description\":\"payment_failed\"}">>]
2015-02-05 02:57:38.321 [info] <0.234.0> OpId: ["df5a9f09-0aa4-416a-8686-33116c144858"]. Transaction [{<<84,210,192,2,67,235,18,52,21,0,0,4>>}] has been saved to db with state [initial].
2015-02-05 02:57:38.321 [info] <0.234.0> OpId: ["df5a9f09-0aa4-416a-8686-33116c144858"]. Service request has been sent [<<"{\"transaction\":{\"amount\":12.635,\"kind\":\"capture\"}}">>]
2015-02-05 02:57:43.323 [info] <0.234.0> OpId: ["df5a9f09-0aa4-416a-8686-33116c144858"]. Counterparty [<<"TestService1">>] notification failed.
2015-02-05 02:57:43.325 [info] <0.234.0> OpId: ["df5a9f09-0aa4-416a-8686-33116c144858"]. Transaction [{<<84,210,192,2,67,235,18,52,21,0,0,4>>}] has been saved to db
```

###Dependencies

Erlang OPT 17.0 or higher
