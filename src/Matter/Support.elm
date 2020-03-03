module Matter.Support exposing (render)

import Common exposing (..)
import Common.Views as Common
import Content.Markdown as Markdown
import Content.Metadata exposing (MetadataForPages)
import Content.Parsers exposing (EncodedData)
import Dict
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
    { footer : Common.FooterData
    , form : FormData
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


type alias FormData =
    { body : List (Html Msg)
    , emailPlaceholder : String
    , messagePlaceholder : String
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
        (Yaml.field "footer" Common.footerDataDecoder)
        (Yaml.field "form" formDataDecoder)
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


formDataDecoder : Yaml.Decoder FormData
formDataDecoder =
    Yaml.map4
        FormData
        (Yaml.field "body" Yaml.markdownString)
        (Yaml.field "email_placeholder" Yaml.string)
        (Yaml.field "message_placeholder" Yaml.string)
        (Yaml.field "title" Yaml.string)



-- 🖼


view : PagePath -> Model -> DecodedData -> Html Msg
view pagePath model data =
    Html.div
        []
        [ intro pagePath model data
        , form model data
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
            [ menuItems data ]

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



-- FORM


form : Model -> DecodedData -> Html Msg
form model data =
    Html.div
        [ T.bg_gray_600 ]
        [ Html.form
            (E.onSubmit Contact :: Kit.containerAttributes)
            [ -----------------------------------------
              -- Title
              -----------------------------------------
              Kit.h2 "Contact us"

            -----------------------------------------
            -- Text
            -----------------------------------------
            , Kit.introParagraph <| Markdown.trimAndProcess """
                Sorry to hear you're having trouble with Fission!
                You can send us a quick note below, or join us in [our chat](https://discord.gg/daDMAjE).
              """

            -----------------------------------------
            -- Input
            -----------------------------------------
            -- Email
            --------
            , Html.label
                Kit.labelAttributes
                [ Html.text "Email" ]

            --
            , { name = "email"
              , onInput = GotContactEmail
              , placeholder = "your@email.dev"
              , value = model.contactEmail
              }
                |> Kit.inputAttributes
                |> (\a -> Html.input a [])

            -- Message
            ----------
            , Html.label
                Kit.labelAttributes
                [ Html.text "Message" ]

            --
            , { name = "message"
              , onInput = GotContactMessage
              , placeholder = "Describe the problem we can help you with"
              , value = model.contactMessage
              }
                |> Kit.inputAttributes
                |> List.append [ T.h_40, T.resize_none ]
                |> (\a -> Html.textarea a [])

            -- Button
            ---------
            , formButton model
            ]
        ]


formButton : Model -> Html Msg
formButton model =
    let
        buttonColorAttribute =
            RemoteAction.backgroundColor model.contacting

        label =
            case model.contacting of
                Failed reason ->
                    reason

                InProgress ->
                    "Sending message …"

                Stopped ->
                    "Send message"

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
