module Page exposing (Page(..), view) 

import Browser exposing (Document) 
import Html exposing (Html, nav, div, a, ul, text, footer, span, li, i)
import Html.Attributes exposing (class, classList, href)
import Route exposing (Route) 


type Page 
    = Home
    | Project 
    | Issue 
    | Other

view : Page -> { title : String, content : Html msg } -> Document msg 
view page { title, content } = 
    { title = title ++ " - Tracker" 
    , body = viewHeader page :: content :: [ viewFooter ]
    } 

viewHeader : Page -> Html msg 
viewHeader page = 
    nav [ class "navbar navbar-light" ] 
        [ div [class "container"] 
            [ a [ class "navbar-brand", Route.href Route.Home ]
                [ text "Tracker" ]
            , ul [ class "nav navbar-nav pull-xs-right" ] <| 
                navbarLink page Route.Home [ text "Home" ] 
                    :: viewMenu page
            ]
        ] 

viewMenu : Page -> List (Html msg) 
viewMenu page = 
    let
        linkTo = 
            navbarLink page 
    in
    [ linkTo Route.Project [ i [ class "ion-compose" ] [], text " Project" ]
        , linkTo Route.Issue[ i [ class "ion-gear-a" ] [], text " Issue" ]
    ]

viewFooter : Html msg
viewFooter = 
    footer [] 
        [ div [ class "container" ]
            [ a [ class "logo-font", href "/" ] [ text "Tracker " ]
            , span [] 
                [ text " An issue tracker, Code & Design licensed under GNU GENERAL PUBLIC LICENSE." ]
            ]
        ] 

navbarLink : Page -> Route -> List (Html msg) -> Html msg 
navbarLink page route linkContent = 
    li [ classList [ ( "nav-item", True), ("active", isActive page route ) ] ] 
        [ a [ class "nav-link", Route.href route ] linkContent ] 

isActive : Page -> Route -> Bool 
isActive page route = 
    case ( page, route ) of 
        ( Home, Route.Home ) -> 
            True 

        ( Project, Route.Project ) -> 
            True 

        ( Issue, Route.Issue ) -> 
            True 

        _ -> 
            False 
