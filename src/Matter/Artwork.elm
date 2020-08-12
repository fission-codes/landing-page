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
    { hero : HeroData
    , carousel : ArtworksData
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



-- ⛩


render : ContentList -> PagePath -> MetadataForPages -> EncodedData -> Model -> Html Msg
render _ pagePath meta encodedData model =
    encodedData
        |> Common.decodeYaml dataDecoder
        |> Result.unpack Common.error (view pagePath model)



-- 🗄


dataDecoder : Yaml.Decoder DecodedData
dataDecoder =
    Yaml.map3
        DecodedData
        (Yaml.field "hero" heroDataDecoder)
        (Yaml.field "carousel" artworksDataDecoder)
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



-- 🖼


view : PagePath -> Model -> DecodedData -> Html Msg
view pagePath model data =
    Html.div
        []
        [ hero pagePath model data.hero
        , artworksSection pagePath model data.carousel
        , callToAction pagePath model data
        , Common.footer pagePath data.footer
        ]



-- HERO


hero : PagePath -> Model -> HeroData -> Html Msg
hero pagePath model data =
    Html.div
        [ T.bg_gray_600
        , T.flex
        , T.flex_col
        , T.overflow_hidden
        , T.px_6
        , T.pb_16
        , T.md__pb_24
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
                , T.text_2_5xl
                , T.sm__text_3_5xl
                , T.text_center
                , T.mt_24
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
                    , T.md__text_3xl
                    ]
                    [ Html.text data.tagline ]
                , Html.p
                    [ T.mt_4
                    , T.font_body
                    , T.text_gray_300
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
        , T.md__py_16
        ]
        [ Html.div
            [ T.flex
            , T.flex_col
            , T.m_auto
            ]
            [ carouselTitle data.charactersTitle
            , carousel data.characters
            , carouselTitle data.jargonsTitle
            , carousel data.jargons
            ]
        ]


carouselTitle : String -> Html Msg
carouselTitle titleText =
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


carousel : List ArtworkItem -> Html Msg
carousel items =
    Html.div
        [ T.flex
        , T.flex_row
        , T.py_4
        , T.overflow_x_auto
        , A.style "width" "100vw"
        , A.style "scroll-snap-type" "x mandatory"
        ]
        (List.map artworkItem items)


artworkItem : ArtworkItem -> Html Msg
artworkItem { image, name, description, author, date } =
    Html.figure
        [ A.style "scroll-snap-align" "center"
        , T.flex
        , T.flex_col
        , T.items_center
        , T.min_w_full
        , T.px_6
        , T.box_border
        ]
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


callToAction : PagePath -> Model -> DecodedData -> Html Msg
callToAction pagePath model data =
    Html.div
        [ T.bg_gray_600
        , T.flex
        , T.flex_col
        , T.overflow_hidden
        , T.px_6
        , T.py_16
        , T.md__py_24
        ]
        [ Html.div
            [ T.mx_auto
            , T.flex
            , T.flex_col
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
                , T.lg__text_left
                , T.lg__max_w_sm
                , T.lg__my_auto
                , T.lg__ml_20
                ]
                -- TODO move to data
                [ Html.h3
                    [ T.text_2xl
                    , T.text_gray_100
                    , T.font_display
                    , T.md__text_3xl
                    ]
                    [ Html.text "Get some swag!" ]
                , Html.p
                    [ T.mt_4
                    , T.font_body
                    , T.text_gray_300
                    , T.md__text_lg
                    ]
                    [ Html.text "What about having some Fission\nArtwork on a t-shirt, mug or some stickers, huh? We are already working on some very cool swag for you."
                    ]
                , Html.button
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
                    , T.md__text_lg
                    ]
                    [ Html.text "Sign up for swag" ]
                ]
            ]
        ]
