port module Session exposing (Session, decode, navKey)

import Browser.Navigation as Nav 
import Json.Decode as Decode exposing (Decoder) 
import Json.Encode as Encode exposing (Value)

-- TYPES 

type Session 
    = Guest Nav.Key 

navKey : Session -> Nav.Key 
navKey session = 
    case session of 
        Guest key -> 
            key 

port storeSession : Maybe String -> Cmd msg 

-- CHANGES 

changes : (Session -> msg) -> Nav.Key -> Sub msg 
changes toMsg key = 
    onSessionChange (\val -> toMsg (decode key val)) 

port onSessionChange : (Value -> msg) -> Sub msg 

decode : Nav.Key -> Value -> Session 
decode key value = 
    -- It's stored in localStorage as a JSON String;
    -- first decode the Value as a String, then
    -- decode that String as JSON. 
    -- for now we are not decoding anything but just returning a Guest session
    Guest key