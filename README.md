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
- logging

<br/>
![Logo] (https://lh4.googleusercontent.com/BDRNyVY-MBRbMHoRg2h6iOGYH065cm-VNYN_dellF7rdPJJx8qLifKKLXM3abclIQUvc0EUVU_g=w1342-h532)


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

#####Build & run processing center

```sh
> make deps
> make shell
> application:start(octopusppc).
```

#####Init db

```sh
> octopusppc:init_db().
```

#####Execute http GET request

http://localhost:8083/?gate_id=1&service_id=1&amount=13.3&account=bob@gmail.com 

#####And you will receive response

```
{"status":"ok","description":"payment_successful"}
```

#####Check transaction in db

Check Payment collection in db OctopusPPC 
<br/>


####Run release

Work in progress
