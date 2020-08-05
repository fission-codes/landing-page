module Matter.Artwork exposing (render)

import Common exposing (..)
import Common.Views as Common
import Content.Metadata exposing (MetadataForPages)
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
    , menu : MenuData
    , overview : OverviewData
    }


type alias MenuData =
    { indexLink : String
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


render : ContentList -> PagePath -> MetadataForPages -> EncodedData -> Model -> Html Msg
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
        (Yaml.field "menu" menuDataDecoder)
        (Yaml.field "overview" overviewDataDecoder)


menuDataDecoder : Yaml.Decoder MenuData
menuDataDecoder =
    Yaml.map
        MenuData
        (Yaml.field "index_link" Yaml.string)


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
        , carusel pagePath model data
        , Common.footer pagePath data.footer
        ]



-- INTRO


intro : PagePath -> Model -> DecodedData -> Html Msg
intro pagePath model data =
    Html.div
        [ T.bg_gray_600
        , T.flex
        , T.flex_col
        , T.overflow_hidden
        , T.px_6
        , T.md__min_h_screen
        ]
        [ Common.menu
            pagePath
            [ A.style "border-bottom-color" "rgba(165, 167, 184, 0.5)" ]
            []

        -----------------------------------------
        -- Content
        -----------------------------------------
        , Html.div
            [ T.m_auto ]
            [ Html.h1
                [ -- TODO this is actually supposed to be Work Sans, so font_display,
                  -- but we have to make a thinner version available somehow.
                  -- Karla on the other hand is a little thinner by default
                  T.font_body
                , T.text_3_5xl
                , T.text_center
                , T.mt_24
                ]
                [ Html.text "Fission"
                , Html.img
                    [ A.src (ImagePath.toString images.content.artworkPage.lettering)
                    , A.style "margin-top" "-80px"
                    , A.width 600
                    , T.mx_auto
                    ]
                    []
                ]
            , Html.div
                [ T.max_w_xl
                , T.mx_auto
                , T.mt_8
                , T.mb_24
                , T.text_center
                ]
                -- TODO move to data
                [ Html.h3
                    [ T.text_3xl
                    , T.text_gray_100
                    , T.font_display
                    ]
                    [ Html.text "Other than coding, we also love art!" ]
                , Html.p
                    [ T.mt_4
                    , T.font_body
                    , T.text_gray_300
                    , T.text_lg
                    ]
                    [ Html.text "That’s why we always collaborate with great artists to create some funny, cute and awesome dev-related artwork."
                    , Html.br [] []
                    , Html.text "Here is a bit of what we’ve been creating so far:"
                    ]
                ]
            ]
        ]


menuItems : DecodedData -> Html msg
menuItems data =
    Html.div
        [ T.flex
        , T.items_center
        ]
        [ Html.a
            (List.append
                (A.href (PagePath.toString pages.index) :: Common.menuItemStyleAttributes)
                Kit.menuButtonAttributes
            )
            [ Html.text data.menu.indexLink
            ]
        ]



-- CARUSEL


carusel : PagePath -> Model -> DecodedData -> Html Msg
carusel pagePath model data =
    Html.div
        [ T.bg_white
        , T.flex
        , T.flex_col
        , T.overflow_hidden
        , T.px_6
        , T.py_6
        , T.md__min_h_screen
        ]
        [ Html.div
            [ T.flex
            , T.flex_col
            , T.m_auto
            ]
            [ Html.div
                [ T.py_6
                , T.border_b
                , T.border_gray_600
                , T.flex_grow
                , T.flex
                , T.flex_row
                ]
                [ Html.button
                    [ T.text_xl
                    , T.mx_16
                    , T.font_display
                    , T.text_gray_100
                    , T.ml_auto
                    ]
                    [ Html.text "Characters" ]
                , Html.button
                    [ T.text_xl
                    , T.mx_16
                    , T.font_display
                    , T.text_gray_400
                    , T.mr_auto
                    ]
                    [ Html.text "Jargons" ]
                ]
            , Html.div
                [ T.py_6
                , T.container
                , T.mx_auto
                , T.flex
                , T.flex_col
                ]
                [ Html.div
                    [ T.flex
                    , T.flex_row
                    , T.mx_auto
                    ]
                    [ Html.img
                        [ A.src (ImagePath.toString images.content.artworkPage.characters04)
                        , A.width 844
                        , A.height 840
                        , A.style "transform" "translateX(100px) scale(0.7)"
                        , T.flex_shrink
                        , T.max_w_sm
                        , T.opacity_50
                        , T.my_auto
                        ]
                        []
                    , Html.img
                        [ A.src (ImagePath.toString images.content.artworkPage.characters01)
                        , A.width 844
                        , A.height 840
                        , T.flex_shrink
                        , T.mx_auto
                        , T.max_w_sm
                        ]
                        []
                    , Html.img
                        [ A.src (ImagePath.toString images.content.artworkPage.characters02)
                        , A.width 844
                        , A.height 840
                        , A.style "transform" "translateX(-100px) scale(0.7)"
                        , T.flex_shrink
                        , T.max_w_sm
                        , T.opacity_50
                        , T.my_auto
                        ]
                        []
                    ]
                , Html.p
                    [ T.max_w_sm
                    , T.mx_auto
                    , T.text_center
                    , T.mt_4
                    ]
                    [ Html.h3
                        [ T.text_xl
                        , T.mx_16
                        , T.font_display
                        , T.text_gray_100
                        ]
                        [ Html.text "Haskell Lizard" ]
                    , Html.p
                        [ T.mt_2
                        , T.font_body
                        , T.text_gray_300
                        , T.text_base
                        ]
                        [ Html.text "Maybe for lack of practice or knowledge really, there will always be a good old Haskell Lizard."
                        , Html.br [] []
                        , Html.text "You’ll get there buddy!"
                        ]
                    , Html.p
                        [ T.mt_1
                        , T.font_body
                        , T.text_gray_300
                        , T.text_base
                        ]
                        [ Html.text "Art by "
                        , Html.span [ T.text_gray_100 ] [ Html.text "BrunoMonts" ]
                        ]
                    , Html.p
                        [ T.mt_1
                        , T.font_body
                        , T.text_gray_300
                        , T.text_base
                        ]
                        [ Html.text "Dec 2019" ]
                    ]
                ]
            ]
        ]


priestess : Html msg
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


overview : DecodedData -> Html Msg
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
