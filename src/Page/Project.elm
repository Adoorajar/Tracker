module Page.Project exposing (Model, Msg, init, update, toSession, view) 

import Html exposing (Html, div, text)
import Session exposing (Session) 

type alias Model = 
    { content : String 
    , session : Session
    } 


init : Session -> ( Model, Cmd msg ) 
init session = 
    ( { content = "This is the project page" 
    , session = session
    }, Cmd.none )

view : Model -> { title : String, content : Html msg } 
view model = 
    { title = "Projects" 
    , content = 
        div [] 
            [ text model.content ]
    }

-- UPDATE 

type Msg 
    = GenericMsg 
    | GotSession Session

update : Msg -> Model -> ( Model, Cmd Msg ) 
update msg model = 
    case msg of 
        GenericMsg -> 
           ( { model | content = "This is now generic message project page" }, Cmd.none ) 

        GotSession session -> 
            ( { model | session = session }, Cmd.none ) 



-- EXPORT 

toSession : Model -> Session 
toSession model = 
    model.session 