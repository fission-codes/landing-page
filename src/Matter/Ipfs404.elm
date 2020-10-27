module Matter.Ipfs404 exposing (render)

import Common.Views as Common
import Content.Metadata exposing (Frontmatter)
import Content.Parsers exposing (EncodedData)
import Dict
import FeatherIcons
import Html exposing (Html)
import Html.Attributes as A
import Html.Events as E
import Html.Events.Extra as E
import Html.Extra as Html
import Kit
import Kit.Local as Kit
import Pages exposing (images, pages)
import Pages.ImagePath as ImagePath
import Pages.PagePath as PagePath
import RemoteAction exposing (RemoteAction(..))
import Result.Extra as Result
import Tailwind as T
import Types exposing (..)
import Validation exposing (Validated(..))
import Yaml.Decode as Yaml
import Yaml.Decode.Extra as Yaml



-- 🧩


type alias DecodedData =
    { menu : Common.MenuData
    , hero : HeroData
    , footer : Common.FooterData
    }


type alias HeroData =
    { image : String
    , tagline : String
    , message : List (Html Msg)
    }



-- ⛩


render : ContentList -> PagePath -> Frontmatter -> EncodedData -> Model -> Html Msg
render _ pagePath meta encodedData model =
    encodedData
        |> Yaml.fromValue dataDecoder
        |> Result.unpack
            (Yaml.errorToString >> Common.error)
            (view pagePath model)



-- 🗄


dataDecoder : Yaml.Decoder DecodedData
dataDecoder =
    Yaml.map3
        DecodedData
        (Yaml.field "menu" Common.menuDataDecoder)
        (Yaml.field "hero" heroDataDecoder)
        (Yaml.field "footer" Common.footerDataDecoder)


heroDataDecoder : Yaml.Decoder HeroData
heroDataDecoder =
    Yaml.map3
        HeroData
        (Yaml.field "image" Yaml.string)
        (Yaml.field "tagline" Yaml.string)
        (Yaml.field "message" Yaml.markdownString)



-- 🖼


view : PagePath -> Model -> DecodedData -> Html Msg
view pagePath model data =
    Html.div
        []
        [ hero pagePath model data.menu data.hero
        , Common.footer pagePath data.footer
        ]


hero : PagePath -> Model -> Common.MenuData -> HeroData -> Html Msg
hero pagePath model menuData data =
    Html.div
        [ T.bg_gray_600
        , T.flex
        , T.flex_col
        , T.overflow_hidden
        , T.px_6
        , T.pb_16

        -- Responsive
        -------------
        , T.md__pb_24
        , T.md__min_h_screen
        ]
        [ Common.menu
            pagePath
            [ A.style "border-bottom-color" "rgba(165, 167, 184, 0.5)" ]
            [ Common.menuItems menuData ]

        -----------------------------------------
        -- Content
        -----------------------------------------
        , Html.div
            [ T.m_auto ]
            [ Html.h1
                [ T.font_display
                , T.font_normal
                , T.text_2_5xl
                , T.text_center
                , T.mt_24

                -- Responsive
                -------------
                , T.sm__text_3_5xl
                ]
                [ Html.img
                    [ A.src data.image
                    , T.mx_auto
                    ]
                    []
                ]
            , Html.div
                [ T.max_w_xl
                , T.mx_auto
                , T.mt_8
                , T.text_center
                ]
                [ Html.h3
                    [ T.font_display
                    , T.font_medium
                    , T.leading_tight
                    , T.text_2xl
                    , T.text_gray_100

                    -- Responsive
                    -------------
                    , T.md__text_3xl
                    ]
                    [ Html.text data.tagline ]
                , Html.p
                    [ T.mt_4
                    , T.font_body
                    , T.text_gray_300

                    -- Responsive
                    -------------
                    , T.md__text_lg
                    ]
                    data.message
                ]
            ]
        ]
