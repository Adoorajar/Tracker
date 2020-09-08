module Page.Issue exposing (Model, Msg, init, update, toSession, view) 

import Html exposing (Html, h3, div, li, text, ul) 
import Json.Decode as Decode exposing (Decoder)
import Session exposing (Session) 
import Issue exposing (Issue) 
import Http 

type alias Model = 
    { session : Session
    , issues : Status (List Issue)
    } 

type Status a
    = Loading
    | Loaded a
    | Failed

init : Session -> ( Model, Cmd Msg ) 
init session = 
    ( { session = session
    , issues = Loading
    }, getIssues )

view : Model -> { title : String, content : Html Msg } 
view model = 
    case model.issues of 
        Loaded issues -> 
            { title = "Issues" 
            , content = 
                div [] 
                    [ viewIssuesList issues
                    ]
            }

        Loading -> 
            { title = "Issues" 
            , content = 
                div [] 
                    [ h3 [] [ text "Issues - Loading..." ]
                    ]
            }
            
        Failed -> 
            { title = "Issues" 
            , content = 
                div [] 
                    [ h3 [] [ text "Issues - Loading failed" ]
                    ]
            }

viewIssuesList : List Issue -> Html Msg 
viewIssuesList issues = 
    div [] 
        [ h3 [] [ text "Issues" ]
        , ul [] 
            (List.map (\issue -> displayIssueLink issue) issues)
        ]

displayIssueLink : Issue -> Html Msg 
displayIssueLink issue = 
    li [] [ text (Issue.key issue) ]

-- UPDATE 

type Msg 
    = GotSession Session
    | GotIssues (Result Http.Error (List Issue))

update : Msg -> Model -> ( Model, Cmd Msg ) 
update msg model = 
    case msg of 
        GotSession session -> 
            ( { model | session = session }, Cmd.none ) 

        GotIssues result -> 
            case result of 
                Ok issues -> 
                    ( { model | issues = Loaded issues }, Cmd.none ) 

                Err _ -> 
                    ( { model | issues = Failed }, Cmd.none ) 



-- EXPORT 

toSession : Model -> Session 
toSession model = 
    model.session 



-- HTTP 

getIssues : Cmd Msg 
getIssues = 
    Http.get 
        { url = "http://localhost:3000/issues"
        , expect = Http.expectJson GotIssues getIssuesResultsDecoder
        }

getIssuesResultsDecoder : Decoder (List Issue) 
getIssuesResultsDecoder = 
    Decode.list Issue.issueDecoder 