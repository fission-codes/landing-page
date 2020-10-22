module Matter.Index exposing (render)

import Common.Views as Common
import Content.Metadata exposing (Frontmatter)
import Content.Parsers exposing (EncodedData)
import External.Blog
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
    , subscribe : SubscribeData

    --
    , fissionDrive : FissionDriveData
    , fissionForDevelopers : FissionForDevelopersData

    --
    , shortDescription : List (Html Msg)
    , tagline : String
    }


type alias FissionDriveData =
    { description : List (Html Msg)
    }


type alias FissionForDevelopersData =
    { description : List (Html Msg)
    }



--


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
    Yaml.map8
        DecodedData
        (Yaml.field "fission_live" fissionLiveDataDecoder)
        (Yaml.field "footer" Common.footerDataDecoder)
        (Yaml.field "heroku" herokuDataDecoder)
        (Yaml.field "subscribe" subscribeDataDecoder)
        --
        (Yaml.field "fission_drive" fissionDriveDataDecoder)
        (Yaml.field "fission_for_developers" fissionForDevelopersDataDecoder)
        --
        (Yaml.field "short_description" Yaml.markdownString)
        (Yaml.field "tagline" Yaml.string)



--


fissionDriveDataDecoder : Yaml.Decoder FissionDriveData
fissionDriveDataDecoder =
    Yaml.map
        FissionDriveData
        (Yaml.field "description" Yaml.markdownString)


fissionForDevelopersDataDecoder : Yaml.Decoder FissionForDevelopersData
fissionForDevelopersDataDecoder =
    Yaml.map
        FissionForDevelopersData
        (Yaml.field "description" Yaml.markdownString)



--


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
        , video pagePath model data
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
            , T.pt_16
            , T.lg__pt_20
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
    let
        features =
            "* Works in all browsers, including mobile devices\n* Uses web APIs, no plug-ins needed\n* Can function local-first, and in many cases, offline\n* User owned data and storage"
    in
    Html.div
        [ T.max_w_2xl
        , T.mx_auto
        , T.pt_5
        , T.px_6
        , T.text_gray_200

        -- Responsive
        -------------
        , T.md__pt_6
        , T.md__text_lg
        ]
        [ Html.div
            [ T.prose
            , T.prose_lg
            , T.text_center
            ]
            data.shortDescription
        , Html.div
            [ T.mt_6
            , T.flex
            , T.flex_row
            , T.items_center
            ]
            [ Html.div
                [ T.prose
                , T.prose_lg
                , T.flex_1
                ]
                [ Html.ul []
                    [ Html.li [] [ Html.text "Works in all browsers, including mobile devices" ]
                    , Html.li [] [ Html.text "Uses web APIs, no plug-ins needed" ]
                    , Html.li [] [ Html.text "Can function local-first, and in many cases, offline" ]
                    , Html.li [] [ Html.text "User owned data and storage" ]
                    ]
                ]
            , Html.img
                [ A.src (ImagePath.toString images.content.artworkPage.characters05)
                , A.width 330
                , A.style "margin-right" "-100px"
                , T.flex_shrink_0
                , T.hidden
                , T.md__block
                ]
                []
            ]
        ]



-- VIDEO


video : PagePath -> Model -> DecodedData -> Html Msg
video pagePath model data =
    Html.div
        [ T.relative
        , T.pt_4
        , T.md__pt_8
        , T.flex
        , T.flex_col
        , T.items_center
        ]
        [ Html.div
            [ T.absolute
            , T.bottom_1over4
            , T.inset_0
            , T.flex
            , T.flex_col
            , A.style "z-index" "-1"
            ]
            [ Html.div [ T.bg_gray_600, T.flex_1 ] [] ]
        , Html.div [ T.px_6, T.text_center ] [ Kit.h2 "Watch a one-minute demo of fission!" ]
        , Html.video
            [ T.mt_6
            , A.src "FissionProductDemo.mp4"
            , A.controls True
            , T.max_w_5xl
            , T.w_full
            , T.lg__rounded
            , T.lg__shadow_xl
            ]
            []
        ]



-- FISSION DRIVE


fissionDrive : PagePath -> Model -> DecodedData -> Html Msg
fissionDrive pagePath model data =
    Html.div
        [ A.id "fission-drive"
        , T.px_6
        , T.py_16
        , T.lg__py_24
        , T.flex
        , T.flex_col
        ]
        [ Html.div
            [ T.flex
            , T.flex_row
            , T.items_center
            , T.mx_auto
            , T.md__space_x_8
            ]
            [ Html.img
                [ A.src (ImagePath.toString images.content.index.fissionDriveLight)
                , A.style "max-width" "300px"
                , T.w_full
                , T.shadow_lg
                , T.rounded
                , T.hidden
                , T.m_8
                , T.md__block
                ]
                []
            , Html.div
                [ T.space_y_6
                , T.items_center
                , T.flex
                , T.flex_col
                , T.text_gray_200
                , T.text_center
                , T.md__items_start
                , T.md__text_left
                , T.md__text_lg
                ]
                [ Kit.h2 "Fission Drive"
                , Html.img
                    [ A.src (ImagePath.toString images.content.index.fissionDriveLight)
                    , A.style "max-width" "300px"
                    , T.w_full
                    , T.shadow_lg
                    , T.rounded
                    , T.md__hidden
                    ]
                    []
                , Html.p
                    [ T.max_w_2xl
                    , T.text_gray_200
                    , T.prose
                    , T.prose_lg

                    -- Responsive
                    -------------
                    , T.md__text_lg
                    ]
                    data.fissionDrive.description
                , Html.a
                    (A.href "https://drive.fission.codes"
                        :: Kit.buttonAttributes
                    )
                    [ Html.text "Sign up for Fission Drive" ]
                ]
            ]
        ]



-- PRODUCT FEATURES


productFeatures : PagePath -> Model -> DecodedData -> Html Msg
productFeatures pagePath model data =
    Html.div
        [ A.id "product-features"
        , T.px_6
        , T.py_16
        , T.lg__py_24
        , T.flex
        , T.flex_col
        , T.items_center
        , T.bg_gray_600
        , T.text_center
        ]
        [ Kit.h2 "Product Features"
        , Html.div
            [ T.flex
            , T.flex_col
            , T.items_center
            , T.mt_12
            , T.space_y_12
            , T.space_x_0
            , T.md__space_y_0
            , T.md__space_x_8
            , T.md__flex_row
            , T.md__items_start
            ]
            [ Html.div
                [ T.flex
                , T.flex_col
                , T.items_center
                , T.self_start
                , T.w_full
                , T.flex_1
                ]
                [ Html.img
                    [ A.src (ImagePath.toString images.logoDarkColored)
                    , A.style "max-width" "150px"
                    , A.title "Fission"

                    --
                    , T.w_full
                    ]
                    []
                , Html.div
                    [ T.prose
                    , T.prose_lg
                    , T.text_left
                    , T.self_start
                    , T.mt_4
                    , T.max_w_sm
                    ]
                    [ Html.ul []
                        [ Html.li [] [ Html.text "No DevOps Required" ]
                        , Html.li [] [ Html.text "Works in all Web Browsers" ]
                        , Html.li [] [ Html.text "Built in Web Native file system" ]
                        , Html.li [] [ Html.text "Offline authentication" ]
                        , Html.li [] [ Html.text "End-to-end encryption" ]
                        , Html.li [] [ Html.text "GDPR Security Compliance" ]
                        , Html.li [] [ Html.text "Data Encrypted at Rest" ]
                        ]
                    ]
                ]
            , Html.div
                [ T.flex
                , T.flex_col
                , T.items_center
                , T.self_start
                , T.w_full
                , T.flex_1
                ]
                [ Html.div
                    [ T.flex
                    , T.flex_row
                    , T.space_x_4
                    , T.items_center
                    ]
                    [ Html.img
                        [ A.src (ImagePath.toString images.content.index.fissionDriveLogo)
                        , A.style "max-width" "66px"
                        ]
                        []
                    , Kit.h2 "Fission Drive"
                    ]
                , Html.div
                    [ T.prose
                    , T.prose_lg
                    , T.text_left
                    , T.self_start
                    , T.mt_4
                    , T.max_w_sm
                    ]
                    [ Html.ul []
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
        [ A.id "fission-for-developers"
        , T.px_6
        , T.py_16
        , T.lg__py_24
        , T.flex
        , T.flex_col
        , T.items_center
        , T.text_center
        , T.space_y_8
        ]
        [ Kit.h2 "Fission For Developers"
        , Html.p
            [ T.prose
            , T.prose_lg
            , T.max_w_2xl
            ]
            data.fissionForDevelopers.description
        , Html.ul
            [ T.flex
            , T.flex_col
            , T.space_y_6
            , T.text_lg
            , T.text_gray_200
            , T.md__grid
            , T.md__grid_cols_2
            , T.md__gap_6
            , T.md__space_y_0
            ]
            (List.map
                (\( icon, text ) ->
                    Html.li
                        [ T.flex
                        , T.flex_row
                        , T.space_x_3
                        , T.items_center
                        ]
                        [ Html.span
                            [ T.w_8
                            , T.h_8
                            , T.rounded
                            , T.bg_purple_shade
                            , T.text_purple_tint
                            , T.items_center
                            , T.justify_center
                            , T.flex
                            ]
                            [ icon
                                |> FeatherIcons.withSize 20
                                |> FeatherIcons.toHtml []
                            ]
                        , Html.span [] [ Html.text text ]
                        ]
                )
                [ ( FeatherIcons.book
                  , "Front end static publishing"
                  )
                , ( FeatherIcons.users
                  , "Accounts & Identity"
                  )
                , ( FeatherIcons.file
                  , "File storage for users"
                  )
                , ( FeatherIcons.database
                  , "Database"
                  )
                ]
            )
        , Html.a
            (A.href "https://guide.fission.codes"
                :: T.max_w_2xs
                :: T.w_full
                :: Kit.buttonAltAttributes
            )
            [ Html.text "Get Started" ]
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
