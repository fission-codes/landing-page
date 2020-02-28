module Matter.Support exposing (render)

import Common exposing (..)
import Common.Views as Common
import Content.Metadata exposing (MetadataForPages)
import Content.Parsers exposing (EncodedData)
import External.Blog
import Html exposing (Html)
import Html.Attributes as A
import Html.Events as E
import Html.Extra as Html
import Kit
import Kit.Local as Kit
import Pages exposing (images, pages)
import Pages.ImagePath as ImagePath
import Pages.PagePath as PagePath
import Result.Extra as Result
import Tailwind as T
import Types exposing (..)
import Yaml.Decode as Yaml
import Yaml.Decode.Extra as Yaml



-- 🧩


type alias DecodedData =
    { footer : Common.FooterData }



-- ⛩


render : ContentList -> PagePath -> MetadataForPages -> EncodedData -> Model -> Html Msg
render _ pagePath meta encodedData model =
    encodedData
        |> Common.decodeYaml dataDecoder
        |> Result.unpack Common.error (view pagePath model)



-- 🗄


dataDecoder : Yaml.Decoder DecodedData
dataDecoder =
    Yaml.map
        DecodedData
        (Yaml.field "footer" Common.footerDataDecoder)



-- 🖼


view : PagePath -> Model -> DecodedData -> Html Msg
view pagePath model data =
    Html.div
        []
        [ intro pagePath model data
        , Common.footer pagePath data.footer
        ]



-- INTRO


intro : PagePath -> Model -> DecodedData -> Html Msg
intro pagePath model data =
    Html.div
        [ T.bg_gray_500
        , T.flex
        , T.flex_col
        , T.overflow_hidden
        , T.px_6

        -- Responsive
        -------------
        , T.md__min_h_screen
        ]
        [ Common.menu
            pagePath
            [ A.style "border-bottom-color" "rgba(165, 167, 184, 0.5)" ]
            [ menuItems ]

        -----------------------------------------
        -- Hidden <h1>
        -----------------------------------------
        , Html.h1
            [ T.hidden ]
            [ Html.text "FISSION" ]

        -----------------------------------------
        -- Centered content
        -----------------------------------------
        , Html.div
            [ T.flex
            , T.flex_col
            , T.flex_grow
            , T.items_center
            , T.justify_center
            , T.py_16
            , T.text_center
            ]
            [ priestess
            ]
        ]


menuItems =
    Html.div
        [ T.flex
        , T.items_center
        ]
        []


priestess =
    Html.div
        [ T.relative ]
        [ Html.img
            [ A.src (ImagePath.toString images.content.haskellHighPriestess768)

            --
            , T.max_w_sm
            , T.w_full
            ]
            []

        --
        , Html.h1
            [ A.class "fancy-title"
            , A.style "font-family" "\"Dokdo\""

            --
            , T.absolute
            , T.left_1over2
            , T.top_1over2
            , T.neg_translate_x_1over2
            , T.translate_y_8
            , T.transform

            --
            , T.font_display
            ]
            [ Html.text "Fission"
            , Html.br [] []
            , Html.text "Support"
            ]
        ]
