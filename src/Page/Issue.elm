module Page.Issue exposing (Model, Msg, init, update, toSession, view) 

import Html exposing (Html, button, h3, div, li, label, input, text, ul) 
import Html.Attributes exposing (type_, placeholder, value)
import Html.Events exposing (onInput, onSubmit)
import Json.Decode as Decode exposing (Decoder) 
import Json.Encode as Encode 
import Session exposing (Session) 
import Issue exposing (Issue) 
import Http 

type alias Model = 
    { session : Session
    , issues : Status (List Issue) 
    , issue : Maybe Issue 
    -- The project, summary and description fields below are for holding 
    -- the values for a form to submit and create a new issue 
    , project : String 
    , summary : String 
    , description : String 
    , errorMessage : String
    } 

type Status a
    = Loading
    | Loaded a
    | Failed 

type IssueCreateResponse
    = IssueCreateSucceeded SuccessResult 
    | IssueCreateFailed FailureResult 

type alias SuccessResult = 
    { status : String 
    , issue : Issue 
    } 

type alias FailureResult = 
    { status : String 
    , message : String 
    }

init : Session -> ( Model, Cmd Msg ) 
init session = 
    ( { session = session
    , issues = Loading 
    , issue = Nothing 
    , project = ""
    , summary = ""
    , description = "" 
    , errorMessage = ""
    }, getIssues )

view : Model -> { title : String, content : Html Msg } 
view model = 
    { title = "Issues" 
    , content = 
        div [] 
            [ viewIssuesList model.issues 
            , viewIssue model.issue 
            , viewIssueCreateForm model
            ]
    } 

viewIssueCreateForm : Model -> Html Msg 
viewIssueCreateForm model = 
    Html.form 
        [ onSubmit SubmitForm ] 
        [ label [] 
            [ text "Project" 
            , input 
                [ type_ "text" 
                , placeholder "Project" 
                , onInput SetProject 
                , value model.project
                ] 
                []
            ]
        , label [] 
            [ text "Summary" 
            , input 
                [ type_ "text" 
                , placeholder "Summary" 
                , onInput SetSummary 
                , value model.summary
                ] 
                []
            ]
        , label [] 
            [ text "Description" 
            , input 
                [ type_ "text" 
                , placeholder "Description" 
                , onInput SetDescription 
                , value model.description
                ] 
                []
            ]
        , button 
            [] 
            [ text "Submit" ]
        ]

viewIssuesList : Status (List Issue) -> Html Msg 
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

displayIssueLink : Issue -> Html Msg 
displayIssueLink issue = 
    li [] [ text (Issue.key issue) ] 

viewIssue : Maybe Issue -> Html Msg 
viewIssue maybeIssue = 
    case maybeIssue of 
        Just issue -> 
            ul []
                [ li [] [ text ( "Key: " ++ Issue.key issue ) ] 
                , li [] [ text ( "Project: " ++ Issue.project issue ) ]
                , li [] [ text ( "Summary: " ++ Issue.summary issue ) ]
                , li [] [ text ( "Description: " ++ Issue.description issue ) ]
                , li [] [ text ( "Status: " ++ Issue.status issue ) ]
                ] 

        Nothing -> 
            ul []
                [ li [] [ text "No issue loaded currently." ]
                ] 

-- UPDATE 

type Msg 
    = GotSession Session
    | GotIssues (Result Http.Error (List Issue)) 
    | SetProject String 
    | SetSummary String 
    | SetDescription String 
    | GotIssueCreateResponse (Result Http.Error IssueCreateResponse) 
    | SubmitForm 

update : Msg -> Model -> ( Model, Cmd Msg ) 
update msg model = 
    case msg of 
        GotSession session -> 
            ( { model | session = session }, Cmd.none ) 

        GotIssues result -> 
            case result of 
                Ok issues -> 
                    ( { model | issues = Loaded issues 
                    , issue = List.head issues
                    }, Cmd.none ) 

                Err _ -> 
                    ( { model | issues = Failed }, Cmd.none ) 

        GotIssueCreateResponse result -> 
            case result of 
                Ok issueCreateResponse -> 
                    case issueCreateResponse of 
                        IssueCreateSucceeded success -> 
                            ( { model | issue = (Just success.issue) }, getIssues ) 

                        IssueCreateFailed failure -> 
                            ( { model | errorMessage = failure.message }, Cmd.none )

                Err _ -> 
                    ( { model | errorMessage = "Http error when attempting to create issue." }, Cmd.none )


        SetProject project -> 
            ( { model | project = project }, Cmd.none ) 

        SetSummary summary -> 
            ( { model | summary = summary }, Cmd.none ) 

        SetDescription description -> 
            ( { model | description = description }, Cmd.none ) 

        SubmitForm -> 
            ( { model | project = "" 
            , summary = "" 
            , description = ""
            }, postRequest model )



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

postRequest : Model -> Cmd Msg
postRequest model = 
    let
        body = 
            Encode.object
                [ ( "project", Encode.string model.project ) 
                , ( "summary", Encode.string model.summary ) 
                , ( "description", Encode.string model.description ) 
                , ("status", Encode.string "open" )
                ] 
                |> Http.jsonBody
    in
    Http.post 
        { url = "http://localhost:3000/issues"
        , body = body 
        , expect = Http.expectJson GotIssueCreateResponse issueCreateResponseDecoder 
        }

issueCreateResponseDecoder : Decoder IssueCreateResponse 
issueCreateResponseDecoder = 
    Decode.field "status" Decode.string 
        |> Decode.andThen issueCreateResponseStatusDecoder 

issueCreateResponseStatusDecoder : String -> Decoder IssueCreateResponse 
issueCreateResponseStatusDecoder status = 
    case status of 
        "success" -> 
            Decode.map IssueCreateSucceeded issueCreateSuccessDecoder
        "failed" -> 
            Decode.map IssueCreateFailed issueCreateFailureDecoder 
        _ -> 
            Decode.fail <| 
                "Trying to decode status, but the status of " 
                ++ status ++ " is not a valid status." 

issueCreateSuccessDecoder : Decoder SuccessResult
issueCreateSuccessDecoder = 
    Decode.map2 SuccessResult
        (Decode.field "status" Decode.string) 
        (Decode.field "issue" Issue.issueDecoder)

issueCreateFailureDecoder : Decoder FailureResult 
issueCreateFailureDecoder = 
    Decode.map2 FailureResult 
        (Decode.field "status" Decode.string) 
        (Decode.field "message" Decode.string)

getIssuesResultsDecoder : Decoder (List Issue) 
getIssuesResultsDecoder = 
    Decode.list Issue.issueDecoder 