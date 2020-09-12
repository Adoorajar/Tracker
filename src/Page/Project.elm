module Page.Project exposing (Model, Msg, init, update, toSession, view) 

import Html exposing (Html, h3, div, li, text, ul) 
import Json.Decode as Decode exposing (Decoder) 
import Session exposing (Session) 
import Project exposing (Project) 
import Issue exposing (Issue)
import Http 

type alias Model = 
    { session : Session
    , projects : Status (List Project) 
    , project : Maybe Project 
    , projectIssues : Status (List Issue) 
    } 

type Status a
    = Loading
    | Loaded a
    | Failed

init : Session -> ( Model, Cmd Msg ) 
init session = 
    ( { session = session 
    , projects = Loading 
    , project = Nothing
    , projectIssues = Loading
    }, getProjects )

view : Model -> { title : String, content : Html Msg } 
view model = 
    case model.projects of 
        Loaded projects -> 
            { title = "Projects" 
            , content = 
                div [] 
                    [ viewProjectsList projects
                    , viewProject model.project
                    , viewProjectIssues model.projectIssues
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

viewProject : Maybe Project -> Html Msg 
viewProject maybeProject = 
    case maybeProject of 
        Just project -> 
            ul []
                [ li [] [ text ( "Name: " ++ Project.name project ) ]
                , li [] [ text ( "Description: " ++ Project.description project ) ]
                ] 

        Nothing -> 
            ul []
                [ li [] [ text "No Project loaded currently." ]
                ] 

viewProjectIssues : Status (List Issue) -> Html Msg 
viewProjectIssues status = 
    case status of 
        Loaded issues -> 
            div [] 
                [ h3 [] [ text "Issues" ] 
                , ul [] 
                    (List.map (\issue -> displayIssueLink issue) issues)
                ]

        Loading -> 
            div [] 
                [ h3 [] [ text "Issues - Loading..." ] ] 

        Failed -> 
            div [] 
                [ h3 [] [ text "Issues - Loading failed." ] ] 

displayIssueLink : Issue -> Html Msg 
displayIssueLink issue = 
    li [] [ text (Issue.key issue) ]

-- UPDATE 

type Msg 
    = GotSession Session 
    | GotProjects (Result Http.Error (List Project))
    | GotProjectIssues (Result Http.Error (List Issue))

update : Msg -> Model -> ( Model, Cmd Msg ) 
update msg model = 
    case msg of 
        GotSession session -> 
            ( { model | session = session }, Cmd.none ) 

        GotProjects result -> 
            case result of 
                Ok projects -> 
                    ( { model | projects = Loaded projects 
                    , project = List.head projects
                    }, getIssuesForProject (List.head projects) ) 

                Err _ -> 
                    ( { model | projects = Failed }, Cmd.none ) 

        GotProjectIssues result -> 
            case result of 
                Ok issues -> 
                    ( { model | projectIssues = Loaded issues }, Cmd.none )

                Err _ -> 
                    ( { model | projectIssues = Failed }, Cmd.none )

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

getIssuesForProject : Maybe Project -> Cmd Msg 
getIssuesForProject maybeProject = 
    case maybeProject of 
        Just project -> 
            Http.get 
                { url = "http://localhost:3000/issues/project/" ++ Project.name project
                , expect = Http.expectJson GotProjectIssues getProjectIssuesResultsDecoder
                } 

        Nothing -> 
            Cmd.none 

getProjectsResultsDecoder : Decoder (List Project) 
getProjectsResultsDecoder = 
    Decode.list Project.projectDecoder 

getProjectIssuesResultsDecoder : Decoder (List Issue) 
getProjectIssuesResultsDecoder = 
    Decode.list Issue.issueDecoder 