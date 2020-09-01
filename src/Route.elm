module Route exposing (Route(..), fromUrl, href)

import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string)
import Html exposing (Attribute) 
import Html.Attributes as Attr 

type Route 
    = Project
    | Issue
    | Home 
    | NotFound


parser : Parser (Route -> a) a 
parser = 
    oneOf 
        [ Parser.map Project (s "project")
        , Parser.map Issue (s "issue") 
        , Parser.map Home Parser.top
        ]


 -- PUBLIC HELPERS 

fromUrl : Url -> Route 
fromUrl url = 
    Maybe.withDefault NotFound (Parser.parse parser url) 

href : Route -> Attribute msg 
href targetRoute = 
    Attr.href (routeToString targetRoute) 

routeToString : Route -> String 
routeToString page = 
    let
        pieces = 
            case page of 
                Home -> 
                    [] 

                Project -> 
                    [ "project" ] 

                Issue -> 
                    [ "issue" ] 

                NotFound -> 
                    [] 
    in
    "/" ++ String.join "/" pieces 


