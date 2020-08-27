module Main exposing (main) 
import Route

import Browser 
import Browser.Navigation as Nav
import Html exposing (Html, li, a, b, text, ul) 
import Html.Attributes exposing (href)
import Url
import Route exposing (Route)

 -- MODEL 

type alias Model = 
    { route : Route
    , key : Nav.Key 
    , url : Url.Url 
    } 

type CurrentPage 
    = HomePage 
    | ProjectPage
    | IssuePage 


-- INIT 

init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key = 
    ( Model (Route.fromUrl url) key url, Cmd.none )
    -- changeRouteTo (Route.fromUrl url)





type Msg 
    = LinkClicked Browser.UrlRequest 
    | UrlChanged Url.Url  


 -- UPDATE 

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = 
    case msg of 
        LinkClicked urlRequest -> 
            case urlRequest of 
                Browser.Internal url -> 
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href -> 
                    ( model, Nav.load href ) 

        UrlChanged url -> 
            ( { model | route = Route.fromUrl url
            , url = url } 
            , Cmd.none 
            )


-- changeRouteTo: Maybe Route -> ( Model, Cmd Msg )
-- changeRouteTo maybeRoute = 
--     case maybeRoute of 
--         Nothing -> 
--             (Model maybeRoute key url, Cmd.none ) 

--         Just Route.Home -> 
--             (Model maybeRoute key url, Cmd.none ) 

--         Just Route.Project -> 
--             (Model maybeRoute key url, Cmd.none )

--         Just Route.Issue -> 
--             (Model maybeRoute key url, Cmd.none )

        

 -- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


 -- VIEW 

view : Model -> Browser.Document Msg 
view model = 
    { title = "Tracker" 
    , body = 
        [ text "The current URL is: " 
        , b [] [ text (Url.toString model.url) ] 
        , ul [] 
            [ viewLink "/home" 
            , viewLink "/project"
            , viewLink "/issue"
            ]
        , text "The current route is: " 
        , viewRoute model.route
        ]   
    }

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


main : Program () Model Msg  
main = 
    Browser.application
        { init = init 
        , view = view 
        , update = update 
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }