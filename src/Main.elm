module Main exposing (main) 

import Browser 
import Html exposing (Html, div, text) 


-- INIT 

init : () -> ( Model, Cmd Msg )
init _ = 
    ( { issue = "TEST" }, Cmd.none )


 -- MODEL 

type alias Model = 
    { issue : String } 


type Msg 
    = IssueChanged String 


 -- UPDATE 

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = 
    case msg of 
        IssueChanged issue -> 
            ( { model | issue = issue }, Cmd.none )


 -- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


 -- VIEW 

view : Model -> Html Msg 
view model = 
    div [] 
        [
            text model.issue
        ]


-- MAIN 


main : Program () Model Msg  
main = 
    Browser.element
        { init = init 
        , view = view 
        , update = update 
        , subscriptions = subscriptions
        }