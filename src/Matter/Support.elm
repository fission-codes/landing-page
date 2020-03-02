module Matter.Support exposing (render)

import Common exposing (..)
import Common.Views as Common
import Content.Markdown as Markdown
import Content.Metadata exposing (MetadataForPages)
import Content.Parsers exposing (EncodedData)
import External.Blog
import FeatherIcons
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
        -- Content
        -----------------------------------------
        , Html.div
            [ T.flex
            , T.flex_grow
            , T.items_center
            , T.justify_center
            , T.py_16

            -- Responsive
            -------------
            , T.lg__pb_20
            ]
            [ priestess
            , overview
            ]
        ]


menuItems =
    Html.div
        [ T.flex
        , T.items_center
        ]
        [ Html.a
            (List.append
                (A.href (PagePath.toString pages.index) :: Common.menuItemStyleAttributes)
                Kit.menuButtonAttributes
            )
            [ Html.text "Learn more"
            ]
        ]


priestess =
    Html.div
        [ T.hidden
        , T.relative
        , T.text_right
        , T.w_5over12

        -- Responsive
        -------------
        , T.md__block
        ]
        [ Html.img
            [ A.src (ImagePath.toString images.content.haskellHighPriestess768)

            --
            , T.inline_block
            , T.max_w_sm
            , T.w_full
            ]
            []
        ]


overview =
    Html.div
        [ T.text_gray_200

        -- Responsive
        -------------
        , T.md__ml_8
        , T.md__w_7over12
        , T.lg__ml_16
        ]
        [ Kit.tagline "Need some guidance?"

        --
        , overviewItem
            FeatherIcons.bookOpen
            (Markdown.trimAndProcess """
                Our [Guide](https://guide.fission.codes ) has instructions on getting started and basic troubleshooting
             """)

        --
        , overviewItem
            FeatherIcons.server
            (Markdown.trimAndProcess """
                The [API docs](https://runfission.com/docs) are interactive and document the Web API
             """)

        --
        , overviewItem
            FeatherIcons.github
            (Markdown.trimAndProcess """
                If you're comfortable filing Github issues - for problems or for feature requests - head on over to [our repos](https://github.com/fission-suite)
             """)
        ]


overviewItem icon nodes =
    Html.div
        [ T.flex
        , T.items_center
        , T.max_w_sm
        , T.mt_10
        ]
        [ icon
            |> FeatherIcons.withClass "mr-8"
            |> FeatherIcons.withSize 24
            |> FeatherIcons.toHtml []
            |> List.singleton
            |> Html.div [ T.flex_shrink_0, T.text_gray_300 ]

        --
        , Html.p
            [ T.max_w_md
            , T.text_lg
            ]
            nodes
        ]
