module Matter.Index exposing (render)

import Common exposing (..)
import Common.Views as Common
import Content.Metadata exposing (MetadataForPages)
import Content.Parsers exposing (EncodedData)
import External.Blog
import Html exposing (Html)
import Html.Attributes as A
import Html.Events as E
import Html.Events.Extra as E
import Html.Extra as Html
import Kit
import Kit.Local as Kit
import Pages exposing (images, pages)
import Pages.ImagePath as ImagePath
import Result.Extra as Result
import Tailwind as T
import Types exposing (..)
import Yaml.Decode as Yaml
import Yaml.Decode.Extra as Yaml



-- 🧩


type alias DecodedData =
    { fissionLive : FissionLiveData
    , footer : Common.FooterData
    , heroku : HerokuData
    , news : NewsData
    , subscribe : SubscribeData

    --
    , shortDescription : List (Html Msg)
    , tagline : String
    }


type alias FissionLiveData =
    { about : List (Html Msg)
    , terminalCaption : List (Html Msg)
    , title : String
    }


type alias HerokuData =
    { about : List (Html Msg)
    , title : String
    }


type alias NewsData =
    { buttonText : String
    , title : String
    }


type alias SubscribeData =
    { inputPlaceholder : String
    , note : List (Html Msg)
    , subText : String
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
    Yaml.map7
        DecodedData
        (Yaml.field "fission_live" fissionLiveDataDecoder)
        (Yaml.field "footer" Common.footerDataDecoder)
        (Yaml.field "heroku" herokuDataDecoder)
        (Yaml.field "news" newsDataDecoder)
        (Yaml.field "subscribe" subscribeDataDecoder)
        --
        (Yaml.field "short_description" Yaml.markdownString)
        (Yaml.field "tagline" Yaml.string)


fissionLiveDataDecoder : Yaml.Decoder FissionLiveData
fissionLiveDataDecoder =
    Yaml.map3
        FissionLiveData
        (Yaml.field "about" Yaml.markdownString)
        (Yaml.field "terminal_caption" Yaml.markdownString)
        (Yaml.field "title" Yaml.string)


herokuDataDecoder : Yaml.Decoder HerokuData
herokuDataDecoder =
    Yaml.map2
        HerokuData
        (Yaml.field "about" Yaml.markdownString)
        (Yaml.field "title" Yaml.string)


newsDataDecoder : Yaml.Decoder NewsData
newsDataDecoder =
    Yaml.map2
        NewsData
        (Yaml.field "button_text" Yaml.string)
        (Yaml.field "title" Yaml.string)


subscribeDataDecoder : Yaml.Decoder SubscribeData
subscribeDataDecoder =
    Yaml.map4
        SubscribeData
        (Yaml.field "input_placeholder" Yaml.string)
        (Yaml.field "note" Yaml.markdownString)
        (Yaml.field "sub_text" Yaml.string)
        (Yaml.field "title" Yaml.string)



-- 🖼


view : PagePath -> Model -> DecodedData -> Html Msg
view pagePath model data =
    Html.div
        []
        [ intro pagePath model data
        , fissionLive pagePath model data
        , heroku pagePath model data
        , news pagePath model data
        , subscribe pagePath model data
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

        -- Responsive
        -------------
        , T.md__min_h_screen
        ]
        [ Common.menu pagePath [ menuItems ]

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
            [ logo
            , tagline data
            , shortDescription data
            ]
        ]


menuItems =
    Html.div
        [ T.flex
        , T.items_center
        ]
        [ Common.menuItem "fission-live" "Fission Live"
        , Common.menuItem "heroku" "Heroku"
        , Common.menuItem "news" "News"

        --
        , Html.span
            (Common.menuItemAttributes "subscribe")
            [ Html.div
                [ T.bg_gray_200
                , T.leading_relaxed
                , T.px_2
                , T.py_1
                , T.rounded
                , T.text_gray_600
                ]
                [ Html.text "Subscribe" ]
            ]
        ]


logo =
    Html.img
        [ A.src (ImagePath.toString images.logoDarkColored)
        , A.style "max-width" "550px"
        , A.title "FISSION"

        --
        , T.px_10
        , T.w_full
        ]
        []


tagline data =
    Html.h2
        [ T.font_display
        , T.font_medium
        , T.leading_tight
        , T.mt_10
        , T.text_2xl
        , T.tracking_tight

        --
        , T.md__text_3xl
        ]
        [ Html.text data.tagline ]


shortDescription data =
    Kit.introParagraph data.shortDescription



-- FISSION LIVE


fissionLive : PagePath -> Model -> DecodedData -> Html Msg
fissionLive pagePath model data =
    Html.div
        []
        [ Html.div
            (A.id "fission-live" :: A.style "max-width" "638px" :: Kit.containerAttributes)
            [ -----------------------------------------
              -- Title
              -----------------------------------------
              Kit.h2 data.fissionLive.title

            -----------------------------------------
            -- About
            -----------------------------------------
            , Kit.introParagraph data.fissionLive.about

            -----------------------------------------
            -- Terminal GIF
            -----------------------------------------
            , Html.img
                [ A.src "https://s3.fission.codes/2019/11/going-live-code-diffusion.gif"

                --
                , T.mt_12
                , T.rounded
                , T.w_full
                ]
                []

            -- Caption
            ----------
            , Html.p
                [ T.mt_4
                , T.text_gray_300
                , T.text_sm
                ]
                data.fissionLive.terminalCaption

            -----------------------------------------
            -- Guide Link
            -----------------------------------------
            , Html.a
                (A.href "https://guide.fission.codes/"
                    :: T.mt_12
                    :: Kit.buttonAltAttributes
                )
                [ Html.text "Read the Guide" ]
            ]
        ]



-- HEROKU


heroku : PagePath -> Model -> DecodedData -> Html Msg
heroku pagePath model data =
    Html.div
        [ T.bg_gray_600 ]
        [ Html.div
            (A.id "heroku" :: A.style "max-width" "638px" :: Kit.containerAttributes)
            [ -----------------------------------------
              -- Title
              -----------------------------------------
              Kit.h2 data.heroku.title

            -----------------------------------------
            -- About
            -----------------------------------------
            , Kit.introParagraph data.heroku.about

            -----------------------------------------
            -- Image
            -----------------------------------------
            , Html.img
                [ A.src "https://s3.fission.codes/2019/11/IMG_7574.jpg"

                --
                , T.mt_12
                , T.rounded
                , T.w_full
                ]
                []

            -----------------------------------------
            -- Add-on Link
            -----------------------------------------
            , Html.a
                (A.href "https://elements.heroku.com/addons/interplanetary-fission"
                    :: T.mt_12
                    :: Kit.buttonAttributes
                )
                [ Html.text "Try the Add-on" ]
            ]
        ]



-- NEWS


news : PagePath -> Model -> DecodedData -> Html Msg
news pagePath model data =
    Html.div
        []
        [ Html.div
            (A.id "news" :: T.flex :: Kit.containerAttributes)
            [ -----------------------------------------
              -- Left
              -----------------------------------------
              Html.div
                [ T.md__w_5over12, T.text_left ]
                [ Kit.h2 "News"

                --
                , model.latestBlogPosts
                    |> List.indexedMap
                        (\idx ->
                            newsItem (idx == 0)
                        )
                    |> Html.div
                        [ T.mt_12
                        , T.text_lg
                        ]

                --
                , Html.a
                    (A.href "https://blog.fission.codes"
                        :: T.mt_12
                        :: Kit.buttonAltAttributes
                    )
                    [ Html.text "Visit Fission Blog" ]
                ]

            -----------------------------------------
            -- Right
            -----------------------------------------
            , Html.div
                [ A.style
                    "background-image"
                    ("url(" ++ ImagePath.toString images.content.marvinMeyer571072Unsplash600 ++ ")")

                --
                , T.bg_gray_600
                , T.bg_cover
                , T.hidden
                , T.ml_16
                , T.rounded
                , T.w_7over12

                -- Responsive
                -------------
                , T.md__block
                ]
                []
            ]
        ]


newsItem : Bool -> External.Blog.Post -> Html Msg
newsItem isFirst post =
    Html.div
        []
        [ if isFirst then
            Html.nothing

          else
            Html.div
                [ T.border
                , T.border_gray_600
                , T.h_0
                , T.my_6
                , T.w_32
                ]
                []

        --
        , Html.a
            [ A.href post.url
            , T.block
            , T.leading_snug
            ]
            [ Html.text post.title ]
        ]



-- SUBSCRIBE


subscribe : PagePath -> Model -> DecodedData -> Html Msg
subscribe pagePath model data =
    Html.div
        [ T.bg_gray_600 ]
        [ Html.div
            (A.id "subscribe" :: Kit.containerAttributes)
            [ -----------------------------------------
              -- Sub text
              -----------------------------------------
              Html.div
                [ T.mb_3
                , T.max_w_xs
                , T.mx_auto
                , T.leading_tight
                , T.text_gray_400
                , T.tracking_wider

                -- Responsive
                -------------
                , T.md__max_w_none
                ]
                [ Html.text data.subscribe.subText ]

            -----------------------------------------
            -- Title
            -----------------------------------------
            , Kit.h2 data.subscribe.title

            -----------------------------------------
            -- Input
            -----------------------------------------
            , Html.input
                [ A.name "email"
                , E.onChange GotSubscriptionInput
                , A.placeholder data.subscribe.inputPlaceholder
                , A.value (Maybe.withDefault "" model.subscribeToEmail)

                --
                , T.appearance_none
                , T.bg_white
                , T.border_0
                , T.block
                , T.max_w_md
                , T.mx_auto
                , T.mt_6
                , T.p_5
                , T.rounded
                , T.text_lg
                , T.w_full
                ]
                []

            -----------------------------------------
            -- Button
            -----------------------------------------
            , subscriptionButton model

            -----------------------------------------
            -- Note
            -----------------------------------------
            , Html.p
                [ T.italic
                , T.mt_5
                , T.text_gray_300
                , T.text_sm
                ]
                data.subscribe.note
            ]
        ]


subscriptionButton : Model -> Html Msg
subscriptionButton model =
    let
        buttonColorAttribute =
            case model.subscribing of
                Failed _ ->
                    T.bg_dark_pink

                InProgress ->
                    T.bg_gray_400

                Stopped ->
                    T.bg_purple

                Succeeded ->
                    T.bg_gray_300

        onPress =
            case model.subscribing of
                Failed _ ->
                    Just Subscribe

                InProgress ->
                    Nothing

                Stopped ->
                    Just Subscribe

                Succeeded ->
                    Nothing

        label =
            case model.subscribing of
                Failed _ ->
                    "Failed to subscribe, please try again"

                InProgress ->
                    "Subscribing …"

                Stopped ->
                    "Subscribe"

                Succeeded ->
                    "Thank you!"

        buttonAttributes =
            List.append
                (Kit.buttonAttributesWithColor buttonColorAttribute)
                [ E.onClick (Maybe.withDefault Bypass onPress)

                --
                , T.block
                , T.ease_in_out
                , T.max_w_md
                , T.mt_5
                , T.p_4
                , T.transition
                , T.transition_colors
                , T.w_full
                ]
    in
    Html.button
        buttonAttributes
        [ Html.text label ]
