PROJECT = octopusppc

DEPS = cowboy ibrowse mongodb jiffy
dep_cowboy = git https://github.com/extend/cowboy.git master
dep_ibrowse = git https://github.com/cmullaparthi/ibrowse.git master
dep_jiffy = git https://github.com/davisp/jiffy.git master
dep_mongodb = git https://github.com/comtihon/mongodb-erlang.git

include erlang.mk