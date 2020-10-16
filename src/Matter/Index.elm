module Matter.Index exposing (render)

import Common.Views as Common
import Content.Metadata exposing (Frontmatter)
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
import RemoteAction exposing (RemoteAction(..))
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
        , fissionDrive pagePath model data
        , productFeatures pagePath model data
        , fissionForDevelopers pagePath model data

        -- , fissionLive pagePath model data
        -- , heroku pagePath model data
        -- , news pagePath model data
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
        [ Common.menu
            pagePath
            [ T.border_gray_500 ]
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

            -- , T.text_center
            ]
            [ logo
            , tagline data
            , shortDescription data
            , demoVideo
            ]
        ]


demoVideo =
    let
        aspectRatio =
            9 / 16

        width =
            900

        height =
            aspectRatio * width

        w =
            round width

        h =
            round height
    in
    Html.iframe
        [ A.width w
        , A.height h
        , A.src "https://www.youtube-nocookie.com/embed/6SO8EQb9xrk"
        , A.attribute "frameborder" "0"
        , A.attribute "allow" "accelerometer; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
        , A.attribute "allowfullscreen" ""
        , A.attribute "modestbranding" "1"
        , A.attribute "rel" "0"
        , T.mt_8
        ]
        []


menuItems =
    Html.div
        [ T.flex
        , T.items_center
        ]
        [ Common.menuItem "news" "News"
        , Common.menuItem "" "Guide"
        , Common.menuItem "" "Support"
        , Common.menuItem "" "Sign Up"

        -- , Common.menuItem "fission-live" "For Developers"
        -- , Common.menuItem "heroku" "Drive"
        --
        -- , Html.button
        --     (List.append
        --         (Common.menuItemAttributes "subscribe")
        --         Kit.menuButtonAttributes
        --     )
        --     [ Html.text "Subscribe"
        --     ]
        ]


logo =
    Html.div
        [ T.px_10 ]
        [ Html.img
            [ A.src (ImagePath.toString images.logoDarkColored)
            , A.style "max-width" "550px"
            , A.title "Fission"

            --
            , T.w_full
            ]
            []
        ]


tagline data =
    Html.div
        [ T.mt_10 ]
        [ Kit.tagline data.tagline ]


shortDescription data =
    Kit.introParagraph data.shortDescription



-- FISSION DRIVE


fissionDrive : PagePath -> Model -> DecodedData -> Html Msg
fissionDrive pagePath model data =
    Html.div
        []
        [ Html.div (A.id "fission-drive" :: Kit.containerAttributes)
            [ Kit.h2 "Fission Drive"
            , Kit.introParagraph [ Html.text "Fission Drive is a file storage and identity system that lets you take your files anywhere, and access them from any web or mobile browser.\n\nEvery Fission Drive account features a passwordless login that works in all web browsers, and has file storage included.\n\nOur webnative file system offers offline support as well - you can even access your files without an Internet connection.\n\nYou control your data! You can easily access, publish and share public files, websites, and apps. Private files are encrypted end-to-end. \nAdd an app, give permission to what files it can access - just like on mobile.\n\nClick the link to sign up and create your account!\n" ]
            , Html.a
                (A.href "https://drive.fission.codes"
                    :: T.mt_12
                    :: Kit.buttonAttributes
                )
                [ Html.text "Sign up for Fission Drive" ]
            ]
        ]



-- PRODUCT FEATURES


productFeatures : PagePath -> Model -> DecodedData -> Html Msg
productFeatures pagePath model data =
    Html.div
        [ T.bg_gray_600 ]
        [ Html.div (A.id "product-features" :: Kit.containerAttributes)
            [ Kit.h2 "Product Features"
            , Html.div
                [ T.flex
                , T.flex_row
                ]
                [ Html.div
                    [ T.flex_grow
                    , T.flex_shrink_0
                    , T.prose
                    ]
                    [ Kit.h3 "Fission"
                    , Html.ul [ T.text_left ]
                        [ Html.li [] [ Html.text "No DevOps Required" ]
                        , Html.li [] [ Html.text "Works in all Web Browsers" ]
                        , Html.li [] [ Html.text "Built in Web Native file system" ]
                        , Html.li [] [ Html.text "Offline authentication" ]
                        , Html.li [] [ Html.text "End-to-end encryption" ]
                        , Html.li [] [ Html.text "GDPR Security Compliance" ]
                        , Html.li [] [ Html.text "Data Encrypted at Rest" ]
                        ]
                    ]
                , Html.div
                    [ T.flex_grow
                    , T.flex_shrink_0
                    , T.prose
                    ]
                    [ Kit.h3 "Fission Drive"
                    , Html.ul [ T.text_left ]
                        [ Html.li [] [ Html.text "User Accounts with Data Privacy and File Storage included." ]
                        , Html.li [] [ Html.text "Passwordless Login & Authentication that works in all web browsers." ]
                        , Html.li [] [ Html.text "Control your own data - your files, available everywhere, even offline." ]
                        , Html.li [] [ Html.text "Easily control your file settings for public sharing or private use." ]
                        ]
                    ]
                ]
            ]
        ]



-- FISSION FOR DEVELOPERS


fissionForDevelopers : PagePath -> Model -> DecodedData -> Html Msg
fissionForDevelopers pagePath model data =
    Html.div
        []
        [ Html.div (A.id "fission-for-developers" :: Kit.containerAttributes)
            [ Kit.h2 "Fission For Developers"
            , Html.text "Fission empowers front-end developers to build and scale apps with no backend or DevOps skills required.\n\nThe Fission webnative SDK takes advantage of all the capabilities your browser has to offer, as well as local computation, storage, and identity. Deploy web apps from your laptop that are secure and private by default, just like native mobile apps.\n\nLocal-first functionality also supports working without an Internet connection on desktop and mobile whenever possible. Apps scale running client side with offline support and sync.\nClick the button to install the tools on your local machine and... \n"
            ]
        ]



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
            , Html.img
                [ A.src (ImagePath.toString images.content.cancelyak512)

                --
                , T.mt_12
                , T.rounded
                , T.w_full
                ]
                []

            -----------------------------------------
            -- About
            -----------------------------------------
            , Kit.introParagraph data.fissionLive.about

            -----------------------------------------
            -- Terminal GIF
            -----------------------------------------
            , Html.img
                [ A.src (ImagePath.toString images.content.fissionCliAppInit)

                --
                , T.mt_12
                , T.rounded
                , T.w_full
                ]
                []

            -- Caption
            ----------
            , Html.div
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
                [ Html.text "Install the CLI" ]
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
                [ A.src (ImagePath.toString images.content.driveDarkPublicRootVideoRedpanda)

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
                (A.href "https://drive.fission.codes"
                    :: T.mt_12
                    :: Kit.buttonAttributes
                )
                [ Html.text "Sign up for Fission Drive" ]
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
                [ Kit.h2 "From the blog"

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
                    [ Html.text "Visit the Fission Blog »" ]
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
    let
        onSubmit =
            case model.subscribing of
                Failed _ ->
                    Subscribe

                InProgress ->
                    Bypass

                Stopped ->
                    Subscribe

                Succeeded ->
                    Bypass
    in
    Html.div
        [ T.bg_gray_600 ]
        [ Html.form
            (A.id "subscribe" :: E.onSubmit onSubmit :: Kit.containerAttributes)
            [ -----------------------------------------
              -- Sub text
              -----------------------------------------
              Html.div
                [ T.mb_3
                , T.max_w_xs
                , T.mx_auto
                , T.leading_snug
                , T.px_8
                , T.text_gray_400
                , T.text_sm
                , T.tracking_wider

                -- Responsive
                -------------
                , T.md__max_w_none
                , T.md__tracking_widest
                ]
                [ Html.text data.subscribe.subText ]

            -----------------------------------------
            -- Title
            -----------------------------------------
            , Kit.h2 data.subscribe.title

            -----------------------------------------
            -- Input
            -----------------------------------------
            , { name = "email"
              , onInput = GotSubscriptionInput
              , placeholder = data.subscribe.inputPlaceholder
              , value = model.subscribeToEmail
              }
                |> Kit.inputAttributes
                |> (\a -> Html.input a [])

            --
            , subscriptionButton model

            -----------------------------------------
            -- Note
            -----------------------------------------
            , Html.div
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
            RemoteAction.backgroundColor model.subscribing

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
                [ T.block
                , T.max_w_md
                , T.mt_5
                , T.p_4
                , T.w_full
                ]
    in
    Html.button
        buttonAttributes
        [ Html.text label ]
