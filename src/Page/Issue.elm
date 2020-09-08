module Page.Issue exposing (Model, Msg, init, update, toSession, view) 

import Html exposing (Html, h3, div, li, text, ul)
import Session exposing (Session) 
import Issue exposing (Issue)

type alias Model = 
    { content : String 
    , session : Session
    } 

type Status a
    = Loading
    | Loaded a
    | Failed

init : Session -> ( Model, Cmd msg ) 
init session = 
    ( { content = "This is the issue page" 
    , session = session
    }, Cmd.none )

view : Model -> { title : String, content : Html msg } 
view model = 
    { title = "Issues" 
    , content = 
        div [] 
            [ text model.content 
            ]
    }

viewIssuesList : Status (List Issue) -> Html msg 
viewIssuesList status = 
    case status of 
        Loaded issues -> 
            div [] 
                [ h3 [] [ text "Issues" ]
                , ul [] 
                    (List.map (\issue -> displayIssueLink issue) issues)
                ]

        Loading -> 
            div [] 
                [ h3 [] [ text "Issues - Loading..." ]
                
                ]

        Failed -> 
            div [] 
                [ h3 [] [ text "Issues - Loading failed" ]
                
                ]

displayIssueLink : Issue -> Html msg 
displayIssueLink issue = 
    li [] [ text (Issue.key issue) ]

-- UPDATE 

type Msg 
    = GenericMsg 
    | GotSession Session

update : Msg -> Model -> ( Model, Cmd Msg ) 
update msg model = 
    case msg of 
        GenericMsg -> 
           ( { model | content = "This is now generic message issue page" }, Cmd.none ) 

        GotSession session -> 
            ( { model | session = session }, Cmd.none ) 



-- EXPORT 

toSession : Model -> Session 
toSession model = 
    model.session 