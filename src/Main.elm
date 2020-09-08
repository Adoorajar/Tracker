module Main exposing (main) 

import Route
import Browser exposing (Document) 
import Browser.Navigation as Nav
import Html exposing (Html, li, a, b, text, ul) 
import Html.Attributes exposing (href)
import Json.Decode as Decode exposing (Value)
import Url
import Route exposing (Route) 
import Page exposing (Page) 
import Page.Home as Home 
import Page.Project as Project 
import Page.Issue as Issue 
import Page.Blank as Blank
import Page.NotFound as NotFound 
import Session exposing (Session) 

 -- MODEL 

type Model
    = Redirect Session 
    | NotFound Session
    | Home Home.Model 
    | Project Project.Model 
    | Issue Issue.Model 

-- INIT 

init : Value -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey = 
    changeRouteTo (Route.fromUrl url)
        (Redirect (Session.decode navKey flags))


type Msg 
    = Ignored
    | LinkClicked Browser.UrlRequest 
    | UrlChanged Url.Url  
    | GotHomeMsg Home.Msg 
    | GotProjectMsg Project.Msg
    | GotIssueMsg Issue.Msg 

toSession : Model -> Session 
toSession page = 
    case page of 
        Redirect session -> 
            session 

        NotFound session -> 
            session

        Home home -> 
            Home.toSession home 

        Project project -> 
            Project.toSession project 

        Issue issue -> 
            Issue.toSession issue 

changeRouteTo : Route -> Model -> ( Model, Cmd Msg ) 
changeRouteTo route model = 
    let
        session = 
            toSession model 
    in
    case route of 
        Route.NotFound -> 
            ( NotFound session, Cmd.none )

        Route.Home -> 
            Home.init session
                |> updateWith Home GotHomeMsg model 

        Route.Project -> 
            Project.init session 
                |> updateWith Project GotProjectMsg model 

        Route.Issue -> 
            Issue.init session 
                |> updateWith Issue GotIssueMsg model 

 -- UPDATE 

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = 
    case ( msg, model ) of 
        ( Ignored, _ ) -> 
            ( model, Cmd.none )

        ( LinkClicked urlRequest, _ ) -> 
            case urlRequest of 
                Browser.Internal url -> 
                    ( model, Nav.pushUrl (Session.navKey (toSession model)) (Url.toString url) )

                Browser.External href -> 
                    ( model, Nav.load href ) 

        ( UrlChanged url, _ ) -> 
            changeRouteTo (Route.fromUrl url) model

        ( GotHomeMsg subMsg, Home home ) ->
            Home.update subMsg home
                |> updateWith Home GotHomeMsg model 

        ( GotProjectMsg subMsg, Project project ) ->
            Project.update subMsg project
                |> updateWith Project GotProjectMsg model

        ( GotIssueMsg subMsg, Issue issue ) ->
            Issue.update subMsg issue
                |> updateWith Issue GotIssueMsg model 

        ( _, _ ) ->
            -- Disregard messages that arrived for the wrong page.
            ( model, Cmd.none )

updateWith : (subModel -> Model) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg model ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )
       

 -- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


 -- VIEW 

view : Model -> Document Msg 
view model = 
    let
        viewPage page toMsg config = 
            let
                { title, body } = 
                    Page.view page config
            in
            { title = title 
            , body = List.map (Html.map toMsg) body 
            }
    in
    case model of 
        Redirect _ -> 
            viewPage Page.Other (\_ -> Ignored) Blank.view 

        NotFound _ -> 
            viewPage Page.Other (\_ -> Ignored) NotFound.view 
            
        Home home -> 
            viewPage Page.Home GotHomeMsg (Home.view home) 

        Project project -> 
            viewPage Page.Project GotProjectMsg (Project.view project)

        Issue issue -> 
            viewPage Page.Issue GotIssueMsg (Issue.view issue)


viewLink : String -> Html msg 
viewLink path = 
    li [] [ a [ href path ] [ text path ] ]

viewRoute : Route -> Html msg 
viewRoute route = 
    case route of 
        Route.NotFound -> 
            b [] [ text "no route" ] 

        Route.Home -> 
            b [] [ text "Home" ]

        Route.Project -> 
            b [] [ text "Project" ]

        Route.Issue -> 
            b [] [ text "Issue" ]

-- MAIN 


main : Program Value Model Msg  
main = 
    Browser.application
        { init = init 
        , view = view 
        , update = update 
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }