module Page.Project exposing (Model, Msg, init, update, toSession, view) 

import Html exposing (Html, h3, div, li, text, ul) 
import Json.Decode as Decode exposing (Decoder) 
import Session exposing (Session) 
import Project exposing (Project) 
import Http 

type alias Model = 
    { session : Session
    , projects : Status (List Project)
    } 

type Status a
    = Loading
    | Loaded a
    | Failed

init : Session -> ( Model, Cmd Msg ) 
init session = 
    ( { session = session 
    , projects = Loading
    }, getProjects )

view : Model -> { title : String, content : Html Msg } 
view model = 
    case model.projects of 
        Loaded projects -> 
            { title = "Projects" 
            , content = 
                div [] 
                    [ viewProjectsList projects
                    ]
            }

        Loading -> 
            { title = "Projects" 
            , content = 
                div [] 
                    [ h3 [] [ text "Projects - Loading..." ]
                    ]
            }
            
        Failed -> 
            { title = "Projects" 
            , content = 
                div [] 
                    [ h3 [] [ text "Projects - Loading failed" ]
                    ]
            }
            

viewProjectsList : List Project -> Html Msg 
viewProjectsList projects = 
    div [] 
        [ h3 [] [ text "Projects" ]
        , ul [] 
            (List.map (\project -> displayProjectLink project) projects)
        ]


displayProjectLink : Project -> Html Msg 
displayProjectLink project = 
    li [] [ text (Project.name project) ]

-- UPDATE 

type Msg 
    = GotSession Session 
    | GotProjects (Result Http.Error (List Project))

update : Msg -> Model -> ( Model, Cmd Msg ) 
update msg model = 
    case msg of 
        GotSession session -> 
            ( { model | session = session }, Cmd.none ) 

        GotProjects result -> 
            case result of 
                Ok projects -> 
                    ( { model | projects = Loaded projects }, Cmd.none ) 

                Err _ -> 
                    ( { model | projects = Failed }, Cmd.none ) 



-- EXPORT 

toSession : Model -> Session 
toSession model = 
    model.session 


-- HTTP 

getProjects : Cmd Msg 
getProjects = 
    Http.get 
        { url = "http://localhost:3000/projects"
        , expect = Http.expectJson GotProjects getProjectsResultsDecoder
        }

getProjectsResultsDecoder : Decoder (List Project) 
getProjectsResultsDecoder = 
    Decode.list Project.projectDecoder 