module View.Index exposing (view)

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
import Types exposing (..)
import Yaml.Decode as Yaml



-- 🧩


type alias DecodedData =
    { tagline : String }



-- 🌈


view : ContentList -> PagePath -> MetadataForPages -> EncodedData -> Element Msg
view _ pagePath meta encodedData =
    case Yaml.fromString dataDecoder encodedData of
        Ok data ->
            Element.row
                [ Element.height Element.fill
                , Element.width Element.fill
                ]
                [ left pagePath meta data
                , right pagePath meta data
                ]

        Err _ ->
            -- TODO
            Element.text "Failed to decode data"


dataDecoder : Yaml.Decoder DecodedData
dataDecoder =
    Yaml.map
        (\tagline ->
            { tagline = tagline }
        )
        (Yaml.field "tagline" Yaml.string)



-- LEFT


left : PagePath -> MetadataForPages -> DecodedData -> Element Msg
left pagePath _ data =
    [ -- Logo
      -------
      Element.image
        [ Element.centerX
        , Element.width (Element.px 220)
        ]
        { src = relativeImagePath { from = pagePath, to = images.logoLightColored }
        , description = "FISSION"
        }

    -- Tagline
    ----------
    , Element.paragraph
        [ Element.centerX
        , Element.paddingXY (Kit.scales.spacing 9) 0
        , Element.Font.center
        , Element.Font.color Kit.colors.gray_600
        , Element.Font.family Kit.fonts.display
        , Element.Font.semiBold
        , Element.Font.size (Kit.scales.typography 3)
        ]
        [ Element.text data.tagline
        ]

    -- Short intro
    --------------
    , Element.paragraph
        [ Element.alpha 0.7
        , Element.centerX
        , Element.paddingXY (Kit.scales.spacing 9) 0
        , Element.spacing (Kit.scales.spacing 2)
        , Element.Font.center
        , Element.Font.color Kit.colors.gray_600
        , Element.Font.italic
        ]
        [ Element.text """
              FISSION’s mission is to bring decentralized web technologies to the wider development community by solving today’s challenges & exploring fundamental shifts in the way we host, deploy, and run software for humans.
              """
        ]
    ]
        |> Element.column
            [ Element.centerX
            , Element.centerY
            , Element.spacing (Kit.scales.spacing 10)
            ]
        |> Element.el
            [ Element.height Element.fill
            , Element.width Element.fill
            , Element.Background.color Kit.colors.gray_100

            --
            , Element.htmlAttribute (Html.Attributes.style "overflow" "hidden")

            --
            , subtleBackground pagePath
            ]


subtleBackground : PagePath -> Element.Attribute msg
subtleBackground pagePath =
    { src = relativeImagePath { from = pagePath, to = images.logoIconDark }
    , description = ""
    }
        |> Element.image
            [ Element.alpha 0.03
            , Element.scale 1.275
            , Element.width Element.fill
            ]
        |> Element.el
            [ Element.centerX
            , Element.centerY
            , Element.width Element.fill
            ]
        |> Element.behindContent



-- RIGHT


right : PagePath -> MetadataForPages -> DecodedData -> Element Msg
right currentPagePath _ _ =
    Element.column
        [ Element.height Element.fill
        , Element.padding (Kit.scales.spacing 10)
        , Element.width Element.fill
        , Element.Background.color Kit.colors.gray_600
        , Element.Font.center
        ]
        [ Kit.link
            { url =
                relativePagePath
                    { from = currentPagePath
                    , to = pages.blog.index
                    }
            , label =
                Element.text "Blog"
            , title =
                "Blog"
            }
        ]
