module Common exposing (decodeYaml, edges, errorView, relativeImagePath, relativePagePath)

import Element exposing (Element)
import Pages.ImagePath
import Pages.PagePath
import Types exposing (..)
import Yaml.Decode as Yaml



-- 🛠


relativeImagePath : { from : PagePath, to : ImagePath } -> String
relativeImagePath { from, to } =
    relativePath
        { from = Pages.PagePath.toString from
        , to = Pages.ImagePath.toString to
        }


relativePagePath : { from : PagePath, to : PagePath } -> String
relativePagePath { from, to } =
    relativePath
        { from = Pages.PagePath.toString from
        , to = Pages.PagePath.toString to
        }



-- 🗄


decodeYaml : Yaml.Decoder a -> String -> Result String a
decodeYaml decoder yaml =
    yaml
        |> Yaml.fromString decoder
        |> Result.mapError
            (\error ->
                case error of
                    Yaml.Parsing string ->
                        "YAML parsing error: " ++ string

                    Yaml.Decoding string ->
                        "YAML decoding error: " ++ string
            )



-- 🖼


{-| See <https://package.elm-lang.org/packages/mdgriffith/elm-ui/1.1.5/Element#paddingEach>
-}
edges : { top : Int, right : Int, bottom : Int, left : Int }
edges =
    { top = 0
    , right = 0
    , bottom = 0
    , left = 0
    }


errorView : String -> Element msg
errorView err =
    -- TODO
    Element.el
        [ Element.centerX
        , Element.centerY
        ]
        (Element.text err)



-- ㊙️


relativePath : { from : String, to : String } -> String
relativePath { from, to } =
    from
        |> String.dropLeft 1
        |> (\str ->
                if String.isEmpty str then
                    []

                else
                    String.split "/" str
           )
        |> List.map (\_ -> "..")
        |> String.join "/"
        |> (\prefix ->
                String.append prefix to
           )
        |> (\merged ->
                if String.startsWith "/" merged then
                    String.dropLeft 1 merged

                else
                    merged
           )
