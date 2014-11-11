##Octopus PPC

######As Is
Tiny Payment Processing Center engine with support of:
- payment by account API & workflow
- DB integration: mongo db
- no custom partners API

######To Be
Payment Processing Center with support of:
- different types of payment gates
- custom Octopus API
- custom partners API
- security
- DSL for billing calculation
- high performance
- no UI for configuration & support

####Run shell

```sh
> make
> make shell
> octopusppc:start(a,b)
```

######Execute http GET request

http://localhost:8083/?gate_id=1&service_id=1&amount=13.3&account=bob@gmail.com 

######And you will receive response
http://localhost:8083/?gate_id=1&service_id=1&amount=13.3&account=bob@gmail.cmo



####Run release

Work in progress
