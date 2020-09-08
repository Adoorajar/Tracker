module Project 
    exposing 
        ( Project
        , name
        , description 
        , issues
        , projectDecoder
        )

import Issue exposing (Issue)
import Json.Decode as Decode exposing (Decoder)

-- TYPES 

type Project 
    = Project Internals

type alias Internals = 
    { name: String
    , description: String
    , issues: List String 
    }

-- INFO 

name : Project -> String 
name (Project internals) = 
    internals.name 

description : Project -> String 
description (Project internals) = 
    internals.description 

issues : Project -> List String 
issues (Project internals) = 
    internals.issues 

-- DECODERS 

projectDecoder : Decoder Project 
projectDecoder = 
    Decode.map Project internalsDecoder

internalsDecoder : Decoder Internals 
internalsDecoder = 
    Decode.map3 Internals
        (Decode.field "name" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "issues" issuesListDecoder)

issuesListDecoder : Decoder (List String) 
issuesListDecoder = 
    -- Decode.list Issue.issueDecoder
    Decode.list Decode.string