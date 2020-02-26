module Common exposing (..)

import Element exposing (Element)
import Kit
import Types exposing (..)
import Yaml.Decode as Yaml



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


containerLength : Element.Length
containerLength =
    Element.maximum 1000 Element.fill


desktopVerticalPadding : Int
desktopVerticalPadding =
    Kit.scales.spacing 24


errorView : String -> Element msg
errorView err =
    -- TODO
    Element.el
        [ Element.centerX
        , Element.centerY
        ]
        (Element.text err)


horizontalPadding : Int
horizontalPadding =
    Kit.scales.spacing 6


mobileVerticalPadding : Int
mobileVerticalPadding =
    Kit.scales.spacing 16
