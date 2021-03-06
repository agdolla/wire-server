{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

module V3 (migration) where

import Cassandra.Schema
import Text.RawString.QQ

migration :: Migration
migration = Migration 3 "Add clients table, push.client and user_push.client" $ do
    schema' [r|
        create columnfamily if not exists clients
            ( user    uuid -- user id
            , client  text -- client id
            , enckey  blob -- native push encryption key
            , mackey  blob -- native push mac key
            , primary key (user, client)
            ) with compaction = { 'class' : 'LeveledCompactionStrategy' };
        |]
    schema' [r| alter columnfamily user_push add client text; |]
    schema' [r| alter columnfamily push add client text; |]
