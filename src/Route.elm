module Route exposing (Route(..), fromUrl)

import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string)

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
        , Parser.map Home (s "home")
        ]


 -- PUBLIC HELPERS 

fromUrl : Url -> Route 
fromUrl url = 
    Maybe.withDefault NotFound (Parser.parse parser url)


