module Issue 
    exposing 
        ( Issue
        , key
        , project
        , summary
        , description
        , status
        , issueDecoder
        )

import Json.Decode as Decode exposing (Decoder)

-- TYPES 

type Issue
    = Issue Internals

type alias Internals = 
    { key: String
    , project: String
    , summary: String
    , description: String
    , status: String 
    }

-- INFO 

key : Issue -> String 
key (Issue internals) = 
    internals.key 

project : Issue -> String 
project (Issue internals) = 
    internals.project 

summary : Issue -> String 
summary (Issue internals) = 
    internals.summary 

description : Issue -> String 
description (Issue internals) = 
    internals.description 

status : Issue -> String 
status (Issue internals) = 
    internals.status 

-- DECODERS 

issueDecoder : Decoder Issue 
issueDecoder = 
    Decode.map Issue internalsDecoder

internalsDecoder : Decoder Internals 
internalsDecoder = 
    Decode.map5 Internals 
        (Decode.field "key" Decode.string)
        (Decode.field "project" Decode.string)
        (Decode.field "summary" Decode.string) 
        (Decode.field "description" Decode.string)
        (Decode.field "status" Decode.string) 

