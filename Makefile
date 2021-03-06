PROJECT = octopusppc

DEPS = mongodb cowboy ibrowse jiffy lager uiid lagergraylog
dep_mongodb = git https://github.com/comtihon/mongodb-erlang.git master
dep_cowboy = git https://github.com/extend/cowboy.git master
dep_ibrowse = git https://github.com/cmullaparthi/ibrowse.git master
dep_jiffy = git https://github.com/davisp/jiffy.git master
dep_lager = git https://github.com/basho/lager.git master
dep_uiid = git git://gitorious.org/avtobiff/erlang-uuid.git master
dep_lagergraylog = git https://github.com/avalente/lager_graylog_backend.git master

include erlang.mk
