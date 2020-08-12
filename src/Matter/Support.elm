module Matter.Support exposing (render)

import Common exposing (..)
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
    { contact : ContactData
    , footer : Common.FooterData
    , menu : Common.MenuData
    , overview : OverviewData
    }


type alias OverviewData =
    { items : List OverviewItem
    , tagline : String
    }


type alias OverviewItem =
    { body : List (Html Msg)
    , icon : String
    }


type alias ContactData =
    { body : List (Html Msg)
    , title : String
    }



-- ⛩


render : ContentList -> PagePath -> Frontmatter -> EncodedData -> Model -> Html Msg
render _ pagePath meta encodedData model =
    encodedData
        |> Common.decodeYaml dataDecoder
        |> Result.unpack Common.error (view pagePath model)



-- 🗄


dataDecoder : Yaml.Decoder DecodedData
dataDecoder =
    Yaml.map4
        DecodedData
        (Yaml.field "contact" contactDataDecoder)
        (Yaml.field "footer" Common.footerDataDecoder)
        (Yaml.field "menu" Common.menuDataDecoder)
        (Yaml.field "overview" overviewDataDecoder)


overviewDataDecoder : Yaml.Decoder OverviewData
overviewDataDecoder =
    Yaml.map2
        OverviewData
        (Yaml.field "items" <| Yaml.list overviewItemDecoder)
        (Yaml.field "tagline" Yaml.string)


overviewItemDecoder : Yaml.Decoder OverviewItem
overviewItemDecoder =
    Yaml.map2
        OverviewItem
        (Yaml.field "body" Yaml.markdownString)
        (Yaml.field "icon" Yaml.string)


contactDataDecoder : Yaml.Decoder ContactData
contactDataDecoder =
    Yaml.map2
        ContactData
        (Yaml.field "body" Yaml.markdownString)
        (Yaml.field "title" Yaml.string)



-- 🖼


view : PagePath -> Model -> DecodedData -> Html Msg
view pagePath model data =
    Html.div
        []
        [ intro pagePath model data
        , contact model data
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
            [ Common.menuItems data.menu ]

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
            , overview data
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


overview data =
    Html.div
        [ T.text_gray_200

        -- Responsive
        -------------
        , T.sm__text_lg
        , T.md__ml_8
        , T.md__w_7over12
        , T.lg__ml_16
        ]
        (data.overview.items
            |> List.map
                (\item ->
                    overviewItem
                        (FeatherIcons.icons
                            |> Dict.get item.icon
                            |> Maybe.withDefault FeatherIcons.chevronRight
                        )
                        item.body
                )
            |> (::) (Kit.tagline data.overview.tagline)
        )


overviewItem icon nodes =
    Html.div
        [ T.flex
        , T.items_center
        , T.mt_8

        -- Responsive
        -------------
        , T.md__mt_10
        ]
        [ icon
            |> FeatherIcons.withClass "mr-8"
            |> FeatherIcons.withSize 24
            |> FeatherIcons.toHtml []
            |> List.singleton
            |> Html.div [ T.flex_shrink_0, T.text_gray_300 ]

        --
        , Html.div
            [ T.max_w_xs ]
            nodes
        ]



-- CONTACT


contact : Model -> DecodedData -> Html Msg
contact model data =
    Html.div
        [ A.id "contact"
        , T.bg_gray_600
        ]
        [ Html.div
            Kit.containerAttributes
            [ -----------------------------------------
              -- Title
              -----------------------------------------
              Kit.h2 data.contact.title

            -----------------------------------------
            -- Text
            -----------------------------------------
            , Html.div
                [ T.max_w_xl
                , T.mx_auto
                , T.pt_5
                , T.px_3
                , T.text_gray_300

                -- Responsive
                -------------
                , T.md__pt_6
                , T.md__text_lg
                ]
                data.contact.body

            -----------------------------------------
            -- Chat trigger
            -----------------------------------------
            , Html.button
                (List.append
                    Kit.buttonAttributes
                    [ E.onClick OpenChat

                    --
                    , T.inline_flex
                    , T.items_center
                    , T.mt_10
                    ]
                )
                [ FeatherIcons.messageCircle
                    |> FeatherIcons.withClass "mr-2 opacity-30"
                    |> FeatherIcons.withSize 20
                    |> FeatherIcons.toHtml []
                , Html.text "Chat with us"
                ]
            ]
        ]
