module Matter.Support exposing (render)

import Common exposing (..)
import Common.Views as Common
import Content.Metadata exposing (MetadataForPages)
import Content.Parsers exposing (EncodedData)
import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Extra as Element
import Element.Font as Font
import Element.Input as Input
import External.Blog
import Kit exposing (edges, none)
import Pages exposing (images, pages)
import Responsive
import Result.Extra as Result
import Types exposing (..)
import Yaml.Decode as Yaml
import Yaml.Decode.Extra as Yaml



-- 🧩


type alias DecodedData =
    ()



-- ⛩


render : ContentList -> PagePath -> MetadataForPages -> EncodedData -> Model -> Element Msg
render _ pagePath meta encodedData model =
    encodedData
        |> Common.decodeYaml dataDecoder
        |> Result.unpack Common.errorView (view pagePath model)



-- 🗄


dataDecoder : Yaml.Decoder DecodedData
dataDecoder =
    Yaml.succeed ()



-- 🖼


view : PagePath -> Model -> DecodedData -> Element Msg
view pagePath model data =
    Element.column
        [ Element.clip
        , Element.customStyle "min-height" "100vh"
        , Element.paddingXY horizontalPadding 0
        , Element.width Element.fill
        , Background.color Kit.colors.gray_600
        , Responsive.hide_lt_md
        ]
        (introParts pagePath model data)



-- INTRO


introParts : PagePath -> Model -> DecodedData -> List (Element Msg)
introParts pagePath _ data =
    [ Common.menu pagePath [ menuItems ]

    --
    , Element.column
        [ Element.centerX
        , Element.centerY
        , Element.paddingXY 0 (Kit.scales.spacing 16)
        ]
        []
    ]


menuItems =
    Element.row
        [ Element.alignRight
        , Element.centerY
        , Element.spacing (Kit.scales.spacing 8)
        ]
        []
