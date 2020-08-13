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
    { menu : Common.MenuData
    , hero : HeroData
    , carousel : ArtworksData
    , callToAction : CallToActionData
    , footer : Common.FooterData
    }


type alias HeroData =
    { tagline : String
    , message : List (Html Msg)
    }


type alias ArtworksData =
    { charactersTitle : String
    , characters : List ArtworkItem
    , jargonsTitle : String
    , jargons : List ArtworkItem
    }


type alias ArtworkItem =
    { image : String
    , name : String
    , description : List (Html Msg)
    , author : String
    , date : String
    }


type alias CallToActionData =
    { title : String
    , body : List (Html Msg)
    , button : String
    , link : String
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
    Yaml.map5
        DecodedData
        (Yaml.field "menu" Common.menuDataDecoder)
        (Yaml.field "hero" heroDataDecoder)
        (Yaml.field "carousel" artworksDataDecoder)
        (Yaml.field "call_to_action" callToActionDataDecoder)
        (Yaml.field "footer" Common.footerDataDecoder)


heroDataDecoder : Yaml.Decoder HeroData
heroDataDecoder =
    Yaml.map2
        HeroData
        (Yaml.field "tagline" Yaml.string)
        (Yaml.field "message" Yaml.markdownString)


artworksDataDecoder : Yaml.Decoder ArtworksData
artworksDataDecoder =
    Yaml.map4
        ArtworksData
        (Yaml.field "characters_title" Yaml.string)
        (Yaml.field "characters" (Yaml.list artworkItemDecoder))
        (Yaml.field "jargons_title" Yaml.string)
        (Yaml.field "jargons" (Yaml.list artworkItemDecoder))


artworkItemDecoder : Yaml.Decoder ArtworkItem
artworkItemDecoder =
    Yaml.map5
        ArtworkItem
        (Yaml.field "image" Yaml.string)
        (Yaml.field "name" Yaml.string)
        (Yaml.field "description" Yaml.markdownString)
        (Yaml.field "author" Yaml.string)
        (Yaml.field "date" Yaml.string)


callToActionDataDecoder : Yaml.Decoder CallToActionData
callToActionDataDecoder =
    Yaml.map4
        CallToActionData
        (Yaml.field "title" Yaml.string)
        (Yaml.field "body" Yaml.markdownString)
        (Yaml.field "button" Yaml.string)
        (Yaml.field "link" Yaml.string)



-- 🖼


view : PagePath -> Model -> DecodedData -> Html Msg
view pagePath model data =
    Html.div
        []
        [ hero pagePath model data.menu data.hero
        , artworksSection pagePath model data.carousel
        , callToAction pagePath model data.callToAction
        , Common.footer pagePath data.footer
        ]



-- HERO


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
                [ Html.text "Fission"
                , Html.img
                    [ A.src (ImagePath.toString images.content.artworkPage.lettering)
                    , A.style "margin-top" "-15%"
                    , A.width 600
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
                    [ T.text_gray_100
                    , T.font_display
                    , T.leading_tight
                    , T.text_2xl

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



-- CARUSEL


artworksSection : PagePath -> Model -> ArtworksData -> Html Msg
artworksSection pagePath model data =
    Html.div
        [ T.bg_white
        , T.flex
        , T.flex_col
        , T.overflow_hidden
        , T.py_6

        -- Responsive
        -------------
        , T.md__py_16
        ]
        [ Html.div
            [ T.flex
            , T.flex_col
            , T.m_auto
            ]
            [ sectionTitle data.charactersTitle
            , artworkCarousel [ T.sm__hidden ] data.characters
            , artworkGrid [ T.hidden, T.sm__grid ] data.characters
            , sectionTitle data.jargonsTitle
            , artworkCarousel [ T.sm__hidden ] data.jargons
            , artworkGrid [ T.hidden, T.sm__grid ] data.jargons
            ]
        ]


sectionTitle : String -> Html Msg
sectionTitle titleText =
    Html.div
        [ T.mt_6
        , T.px_6
        ]
        [ Html.div
            [ T.text_center
            , T.text_xl
            , T.font_display
            , T.text_gray_100
            , T.py_4
            , T.border_b
            , T.border_gray_600
            ]
            [ Html.text titleText ]
        ]


artworkCarousel : List (Html.Attribute Msg) -> List ArtworkItem -> Html Msg
artworkCarousel attributes items =
    Html.div
        ([ T.flex
         , T.flex_row
         , T.py_4
         , A.style "width" "100vw"
         , A.style "scroll-snap-type" "x mandatory"
         , T.overflow_x_auto
         ]
            ++ attributes
        )
        (List.map
            (artworkItem [ T.px_6, T.box_border ])
            items
        )


artworkGrid : List (Html.Attribute Msg) -> List ArtworkItem -> Html Msg
artworkGrid attributes items =
    Html.div
        ([ T.grid
         , T.gap_12
         , T.grid_cols_2
         , T.px_16
         , T.py_16
         , T.max_w_screen_xl

         -- Responsive
         -------------
         , T.lg__grid_cols_3
         ]
            ++ attributes
        )
        (List.map (artworkItem []) items)


artworkItem : List (Html.Attribute Msg) -> ArtworkItem -> Html Msg
artworkItem attributes { image, name, description, author, date } =
    Html.figure
        ([ A.style "scroll-snap-align" "center"
         , T.flex
         , T.flex_col
         , T.items_center
         , T.min_w_full
         ]
            ++ attributes
        )
        [ Html.img
            [ A.src image
            , T.block
            , A.style "max-height" "400px"
            ]
            []
        , Html.figcaption
            [ T.text_center
            ]
            [ Html.h3
                [ T.mt_2
                , T.text_xl
                , T.font_display
                , T.text_gray_100
                ]
                [ Html.text name ]
            , Html.p
                [ T.mt_2
                , T.font_body
                , T.text_gray_300
                , T.text_base
                ]
                description
            , Html.p
                [ T.mt_1
                , T.font_body
                , T.text_gray_300
                , T.text_base
                ]
                [ Html.text "Art by "
                , Html.span [ T.text_gray_100 ] [ Html.text author ]
                ]
            , Html.p
                [ T.mt_1
                , T.font_body
                , T.text_gray_300
                , T.text_base
                ]
                [ Html.text date ]
            ]
        ]



-- CALL TO ACTION


callToAction : PagePath -> Model -> CallToActionData -> Html Msg
callToAction pagePath model data =
    Html.div
        [ T.bg_gray_600
        , T.flex
        , T.flex_col
        , T.overflow_hidden
        , T.px_6
        , T.py_16

        -- Responsive
        -------------
        , T.md__py_24
        ]
        [ Html.div
            [ T.mx_auto
            , T.flex
            , T.flex_col

            -- Responsive
            -------------
            , T.lg__flex_row
            ]
            [ Html.img
                [ A.src (ImagePath.toString images.content.artworkPage.heroImage)
                , A.width 844
                , A.height 840
                , T.flex_shrink
                , T.max_w_sm
                , T.px_6
                , T.w_full
                , T.mx_auto
                ]
                []
            , Html.div
                [ T.text_center

                -- Responsive
                -------------
                , T.lg__text_left
                , T.lg__max_w_sm
                , T.lg__my_auto
                , T.lg__ml_20
                ]
                [ Html.h3
                    [ T.text_2xl
                    , T.text_gray_100
                    , T.font_display

                    -- Responsive
                    -------------
                    , T.md__text_3xl
                    ]
                    [ Html.text data.title ]
                , Html.p
                    [ T.mt_4
                    , T.font_body
                    , T.text_gray_300

                    -- Responsive
                    -------------
                    , T.md__text_lg
                    ]
                    data.body
                , Html.a
                    [ A.href data.link ]
                    [ Html.button
                        [ T.appearance_none
                        , T.cursor_pointer
                        , T.mt_8
                        , T.text_gray_200
                        , T.bg_gray_200
                        , T.leading_relaxed
                        , T.px_4
                        , T.py_1
                        , T.rounded_lg
                        , T.text_gray_600

                        -- Responsive
                        -------------
                        , T.md__text_lg
                        ]
                        [ Html.text data.button ]
                    ]
                ]
            ]
        ]
