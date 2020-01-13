module Matter.Index exposing (render)

import Common exposing (..)
import Content.Metadata exposing (MetadataForPages)
import Content.Parsers exposing (EncodedData)
import Dict.Any
import Element exposing (Element)
import Element.Background
import Element.Border
import Element.Extension as Element
import Element.Font
import Kit
import Pages exposing (images, pages)
import Result.Extra as Result
import Types exposing (..)
import Yaml.Decode as Yaml



-- 🧩


type alias DecodedData =
    { shortDescription : String
    , tagline : String
    }



-- ⛩


render : ContentList -> PagePath -> MetadataForPages -> EncodedData -> Element Msg
render _ pagePath meta encodedData =
    encodedData
        |> Common.decodeYaml dataDecoder
        |> Result.unpack Common.errorView (view pagePath)



-- 🗄


dataDecoder : Yaml.Decoder DecodedData
dataDecoder =
    Yaml.map2
        (\s t ->
            { shortDescription = s
            , tagline = t
            }
        )
        (Yaml.field "shortDescription" Yaml.string)
        (Yaml.field "tagline" Yaml.string)



-- 🖼


view : PagePath -> DecodedData -> Element Msg
view pagePath data =
    Element.column
        [ Element.height Element.fill
        , Element.width Element.fill
        ]
        [ -- Intro
          --------
          data
            |> intro pagePath
            |> Element.el
                [ Element.customStyle "height" "100vh"
                , Element.inFront (menu pagePath)
                , Element.width Element.fill
                , Element.Background.color Kit.colors.gray_600
                ]
            |> Element.el
                [ Element.width Element.fill ]
        ]



-- MENU


menu pagePath =
    Element.row
        [ Element.alignTop
        , Element.centerX
        , Element.paddingXY 0 (Kit.scales.spacing 8)
        , Element.width (Element.maximum 1000 Element.fill)
        , Element.Border.color Kit.colors.gray_500
        , Element.Border.widthEach { edges | bottom = 1 }
        ]
        [ -- Logo Icon
          ------------
          Element.image
            [ Element.centerY
            , Element.width (Element.px 30)
            ]
            { src = relativeImagePath { from = pagePath, to = images.badgeSolidFaded }
            , description = "FISSION"
            }

        -- Links
        --------
        , Element.row
            [ Element.alignRight
            , Element.centerY
            , Element.spacing (Kit.scales.spacing 8)
            ]
            [ menuItem "Fission Live"
            , menuItem "Heroku"
            , menuItem "News"
            ]
        ]


menuItem text =
    Element.el
        [ Element.Font.color Kit.colors.gray_200 ]
        (Element.text text)



-- INTRO


intro pagePath data =
    Element.column
        [ Element.centerX
        , Element.centerY
        ]
        [ logo pagePath
        , tagline data
        , shortDescription data
        ]


logo pagePath =
    Element.image
        [ Element.centerX
        , Element.centerY
        , Element.width (Element.px 550)
        ]
        { src = relativeImagePath { from = pagePath, to = images.logoDarkColored }
        , description = "FISSION"
        }


tagline data =
    Element.paragraph
        [ Element.paddingEach { edges | top = Kit.scales.spacing 12 }
        , Element.spacing (Kit.scales.spacing 2)
        , Element.Font.center
        , Element.Font.color Kit.colors.gray_100
        , Element.Font.family Kit.fonts.display
        , Element.Font.letterSpacing -0.625
        , Element.Font.medium
        , Element.Font.size (Kit.scales.typography 6)
        ]
        [ Element.text data.tagline
        ]


shortDescription data =
    Element.paragraph
        [ Element.centerX
        , Element.paddingEach { edges | top = Kit.scales.spacing 8 }
        , Element.spacing (Kit.scales.spacing 2)
        , Element.width (Element.maximum 500 Element.fill)
        , Element.Font.color Kit.colors.gray_300
        , Element.Font.center
        , Element.Font.size (Kit.scales.typography 2)
        ]
        [ Element.textWithLineBreaks data.shortDescription
        ]
