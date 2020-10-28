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
    { navigation : NavigationData
    , hero : HeroData
    , fissionDrive : FissionDriveData
    , productFeatures : ProductFeaturesData
    , fissionForDevelopers : FissionForDevelopersData
    , subscribe : SubscribeData
    , footer : Common.FooterData
    }


type alias NavigationData =
    { callToAction : String
    , items : List NavigationItemData
    }


type alias NavigationItemData =
    { text : String
    , link : String
    }


type alias HeroData =
    { tagline : String
    , shortDescription : List (Html Msg)
    , features : List String
    , video : VideoData
    }


type alias VideoData =
    { title : String
    , link : String
    }


type alias FissionDriveData =
    { title : String
    , description : List (Html Msg)
    , button : String
    , buttonLink : String
    }


type alias ProductFeaturesData =
    { title : String
    , fissionFeatures : List String
    , driveFeatures : List String
    }


type alias FissionForDevelopersData =
    { title : String
    , description : List (Html Msg)
    , button : String
    , buttonLink : String
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
        (Yaml.field "navigation" navigationDataDecoder)
        (Yaml.field "hero" heroDataDecoder)
        (Yaml.field "fission_drive" fissionDriveDataDecoder)
        (Yaml.field "product_features" productFeaturesDataDecoder)
        (Yaml.field "fission_for_developers" fissionForDevelopersDataDecoder)
        (Yaml.field "subscribe" subscribeDataDecoder)
        (Yaml.field "footer" Common.footerDataDecoder)


navigationDataDecoder : Yaml.Decoder NavigationData
navigationDataDecoder =
    Yaml.map2
        NavigationData
        (Yaml.field "callToAction" Yaml.string)
        (Yaml.field "items" (Yaml.list navigationItemDataDecoder))


navigationItemDataDecoder : Yaml.Decoder NavigationItemData
navigationItemDataDecoder =
    Yaml.map2
        NavigationItemData
        (Yaml.field "text" Yaml.string)
        (Yaml.field "link" Yaml.string)


heroDataDecoder : Yaml.Decoder HeroData
heroDataDecoder =
    Yaml.map4
        HeroData
        (Yaml.field "tagline" Yaml.string)
        (Yaml.field "short_description" Yaml.markdownString)
        (Yaml.field "features" (Yaml.list Yaml.string))
        (Yaml.field "video" videoDataDecoder)


videoDataDecoder : Yaml.Decoder VideoData
videoDataDecoder =
    Yaml.map2
        VideoData
        (Yaml.field "title" Yaml.string)
        (Yaml.field "link" Yaml.string)


fissionDriveDataDecoder : Yaml.Decoder FissionDriveData
fissionDriveDataDecoder =
    Yaml.map4
        FissionDriveData
        (Yaml.field "title" Yaml.string)
        (Yaml.field "description" Yaml.markdownString)
        (Yaml.field "button" Yaml.string)
        (Yaml.field "button_link" Yaml.string)


productFeaturesDataDecoder : Yaml.Decoder ProductFeaturesData
productFeaturesDataDecoder =
    Yaml.map3
        ProductFeaturesData
        (Yaml.field "title" Yaml.string)
        (Yaml.field "fission_features" (Yaml.list Yaml.string))
        (Yaml.field "drive_features" (Yaml.list Yaml.string))


fissionForDevelopersDataDecoder : Yaml.Decoder FissionForDevelopersData
fissionForDevelopersDataDecoder =
    Yaml.map4
        FissionForDevelopersData
        (Yaml.field "title" Yaml.string)
        (Yaml.field "description" Yaml.markdownString)
        (Yaml.field "button" Yaml.string)
        (Yaml.field "button_link" Yaml.string)


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
        --, productFeatures pagePath model data
        , fissionForDevelopers pagePath model data
        , fissionDrive pagePath model data
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
                    (navigationItems data)
                , signUpButton data.navigation.callToAction
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
            (navigationItems data)
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


navigationItems : DecodedData -> List (Html Msg)
navigationItems data =
    let
        menuItem { link, text } =
            Html.a
                [ A.href link
                , T.text_gray_200
                ]
                [ Html.text text ]
    in
    List.map menuItem data.navigation.items


signUpButton : String -> Html Msg
signUpButton text =
    Html.button
        (List.append
            (Common.menuItemAttributes "subscribe")
            Kit.menuButtonAttributes
        )
        [ Html.text text ]


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
        [ Kit.tagline data.hero.tagline ]


shortDescription : DecodedData -> Html Msg
shortDescription data =
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
            data.hero.shortDescription
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
                [ bulletList data.hero.features
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
        , Html.div [ T.px_6, T.text_center ] [ Kit.h2 data.hero.video.title ]
        , Html.div
            [ T.mt_6
            , T.max_w_5xl
            , T.w_full
            , T.lg__shadow_xl
            ]
            [ -- This is a horrible hack to force the iframe to have a dynamic width,
              -- but keep the aspect ratio
              -- The key to this working is that percentage padding depends on the parent
              -- element's width. Yea.
              Html.div
                [ T.relative
                , T.h_0
                , T.overflow_hidden

                -- 16:9 aspect ratio
                -- (String.fromFloat (9 / 16 * 100) ++ "%")
                , A.style "padding-bottom" "56.25%"
                ]
                [ Html.iframe
                    [ A.src data.hero.video.link
                    , A.attribute "frameborder" "0"
                    , A.attribute "allow" "accelerometer; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                    , A.attribute "allowfullscreen" ""
                    , A.attribute "modestbranding" "1"
                    , A.attribute "rel" "0"
                    , T.absolute
                    , T.top_0
                    , T.left_0
                    , T.w_full
                    , T.h_full
                    , T.lg__rounded
                    ]
                    []
                ]
            ]
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
                [ Kit.h2 data.fissionDrive.title
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
                    (A.href data.fissionDrive.buttonLink
                        :: Kit.buttonAttributes
                    )
                    [ Html.text data.fissionDrive.button ]
                ]
            ]
        ]



-- PRODUCT FEATURES

{-
-- BM: commenting out, I don't want this list at all
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
        [ Kit.h2 data.productFeatures.title
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
                    [ bulletList data.productFeatures.fissionFeatures ]
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
                    [ bulletList data.productFeatures.driveFeatures ]
                ]
            ]
        ]
-}


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
        [ Kit.h2 data.fissionForDevelopers.title
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
                -- TODO Figure out how to make this configurable in .yml
                [ ( FeatherIcons.book
                  , "Make your apps work offline"
                  )
                , ( FeatherIcons.users
                  , "User accounts with passwordless login"
                  )
                , ( FeatherIcons.file
                  , "Persistent, encrypted file store per user"
                  )
                , ( FeatherIcons.database
                  , "Backend included"
                  )
                ]
            )
        , Html.a
            (A.href data.fissionForDevelopers.buttonLink
                :: T.max_w_2xs
                :: T.w_full
                :: Kit.buttonAltAttributes
            )
            [ Html.text data.fissionForDevelopers.button ]
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



-- UTILITIES


bulletList : List String -> Html msg
bulletList items =
    Html.ul []
        (List.map (\item -> Html.li [] [ Html.text item ])
            items
        )
