![Logo] (https://avatars0.githubusercontent.com/u/9568895?v=3&s=460)

##Octopus PPC

######As Is
Tiny Payment Processing Center engine with support of:
- payment by account: API & workflow implemented
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
- logging support

####Quick start

######Build & run processing center

```sh
> make deps
> make shell
> application:start(octopusppc).
```

######Init db

```sh
> octopusppc:init_db().
```

######Execute http GET request

http://localhost:8083/?gate_id=1&service_id=1&amount=13.3&account=bob@gmail.com 

######And you will receive response

```
{"status":"ok","description":"payment_successful"}
```

######Check transaction in db

Check Payment collection in db OctopusPPC 


####Run release

Work in progress
