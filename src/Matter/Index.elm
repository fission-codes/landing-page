module Matter.Index exposing (render)

import Common exposing (..)
import Content.Metadata exposing (MetadataForPages)
import Content.Parsers exposing (EncodedData)
import Dict.Any
import Element exposing (Element)
import Element.Background
import Element.Font
import Html.Attributes
import Kit
import Pages exposing (images, pages)
import Result.Extra as Result
import Types exposing (..)
import Yaml.Decode as Yaml



-- 🧩


type alias DecodedData =
    { tagline : String }



-- ⛩


render : ContentList -> PagePath -> MetadataForPages -> EncodedData -> Element Msg
render _ pagePath meta encodedData =
    encodedData
        |> Common.decodeYaml dataDecoder
        |> Result.unpack Common.errorView (view pagePath)



-- 🗄


dataDecoder : Yaml.Decoder DecodedData
dataDecoder =
    Yaml.map
        (\tagline ->
            { tagline = tagline }
        )
        (Yaml.field "tagline" Yaml.string)



-- 🖼


view : PagePath -> DecodedData -> Element Msg
view pagePath data =
    Element.image
        [ Element.centerX
        , Element.centerY
        , Element.width (Element.px 550)
        ]
        { src = relativeImagePath { from = pagePath, to = images.logoDarkColored }
        , description = "FISSION"
        }
