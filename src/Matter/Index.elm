module Matter.Index exposing (render)

import Common.Views as Common
import Content.Metadata exposing (Frontmatter)
import Content.Parsers exposing (EncodedData)
import External.Blog
import FeatherIcons
import Html exposing (Html)
import Html.Attributes as A
import Html.Attributes.Extra as A
import Html.Events as E
import Html.Events.Extra as E
import Html.Extra as Html
import Json.Decode as Json
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
    { tagline : String
    , shortDescription : List (Html Msg)
    , fissionDrive : FissionDriveData
    , fissionForDevelopers : FissionForDevelopersData
    , subscribe : SubscribeData
    , footer : Common.FooterData
    }


type alias FissionDriveData =
    { description : List (Html Msg)
    }


type alias FissionForDevelopersData =
    { description : List (Html Msg)
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
    Yaml.map6
        DecodedData
        (Yaml.field "tagline" Yaml.string)
        (Yaml.field "short_description" Yaml.markdownString)
        (Yaml.field "fission_drive" fissionDriveDataDecoder)
        (Yaml.field "fission_for_developers" fissionForDevelopersDataDecoder)
        (Yaml.field "subscribe" subscribeDataDecoder)
        (Yaml.field "footer" Common.footerDataDecoder)


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
        [ if model.menuBarOpen then
            E.onClick CloseMenuBar

          else
            A.empty
        ]
        [ intro pagePath model data
        , video pagePath model data
        , fissionDrive pagePath model data
        , productFeatures pagePath model data
        , fissionForDevelopers pagePath model data
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
        [ navigationBar pagePath model data

        -----------------------------------------
        -- Hidden <h1>
        -----------------------------------------
        , Html.h1
            [ T.hidden ]
            [ Html.text "FISSION" ]

        -----------------------------------------
        -- Content
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


navigationBar : PagePath -> Model -> DecodedData -> Html Msg
navigationBar pagePath model data =
    Html.div
        [ T.border_b
        , T.container
        , T.flex
        , T.flex_col
        , T.space_y_4
        , T.items_center
        , T.mx_auto
        , T.py_8
        , T.border_gray_500
        , stopBubblingClickEvents
        ]
        [ Html.div
            [ T.flex
            , T.flex_row
            , T.w_full
            ]
            [ Html.div [ T.hidden, T.sm__block ] [ Common.badge ]
            , Html.button
                [ T.appearance_none
                , T.w_8
                , T.h_8
                , T.items_center
                , T.justify_center
                , T.flex
                , T.text_gray_200
                , T.sm__hidden
                , E.onClick ToggleMenuBar
                ]
                [ FeatherIcons.menu
                    |> FeatherIcons.withSize 20
                    |> FeatherIcons.toHtml []
                ]
            , Html.div
                [ T.flex
                , T.items_center
                , T.space_x_8
                , T.ml_auto
                ]
                [ Html.div
                    [ T.flex
                    , T.items_center
                    , T.space_x_8
                    , T.hidden
                    , T.sm__block
                    ]
                    navigationItems
                , signUpButton
                ]
            ]
        , Html.div
            [ T.grid
            , T.gap_3
            , T.grid_cols_2
            , T.w_full
            , T.sm__hidden
            , if model.menuBarOpen then
                A.empty

              else
                T.hidden
            ]
            navigationItems
        ]


stopBubblingClickEvents : Html.Attribute Msg
stopBubblingClickEvents =
    E.custom "click"
        (Json.field "eventPhase" Json.int
            |> Json.andThen
                (\phaseInt ->
                    let
                        -- https://developer.mozilla.org/en-US/docs/Web/API/Event/eventPhase
                        eventBubblingPhase =
                            3
                    in
                    if phaseInt == eventBubblingPhase then
                        Json.succeed
                            { stopPropagation = True
                            , preventDefault = False
                            , message = Bypass
                            }

                    else
                        Json.fail ""
                )
        )


navigationItems : List (Html Msg)
navigationItems =
    let
        menuItem link text =
            Html.a
                [ A.href link
                , T.text_gray_200
                ]
                [ Html.text text ]
    in
    [ menuItem "https://guide.fission.codes" "Get Started"
    , menuItem "https://blog.fission.codes" "Blog"
    , menuItem "https://talk.fission.codes" "Forum"
    , menuItem "/support" "Support"
    ]


signUpButton : Html Msg
signUpButton =
    Html.button
        Kit.menuButtonAttributes
        [ Html.text "Sign Up" ]


logo : Html Msg
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


tagline : DecodedData -> Html Msg
tagline data =
    Html.div
        [ T.mt_10 ]
        [ Kit.tagline data.tagline ]


shortDescription : DecodedData -> Html Msg
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
                , T.ml_6
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
