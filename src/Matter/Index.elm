module Matter.Index exposing (render)

import Common exposing (..)
import Common.Views as Common
import Content.Metadata exposing (MetadataForPages)
import Content.Parsers exposing (EncodedData)
import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Extra as Element
import Element.Font as Font
import Element.Input as Input
import External.Blog
import Kit exposing (edges, none)
import Pages exposing (images, pages)
import Responsive
import Result.Extra as Result
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
    , shortDescription : String
    , tagline : String
    }


type alias FissionLiveData =
    { about : String
    , terminalCaption : String
    , title : String
    }


type alias HerokuData =
    { about : String
    , title : String
    }


type alias NewsData =
    { buttonText : String
    , title : String
    }


type alias SubscribeData =
    { inputPlaceholder : String
    , note : String
    , subText : String
    , title : String
    }



-- ⛩


render : ContentList -> PagePath -> MetadataForPages -> EncodedData -> Model -> Element Msg
render _ pagePath meta encodedData model =
    encodedData
        |> Common.decodeYaml dataDecoder
        |> Result.unpack Common.errorView (view pagePath model)



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
        (Yaml.field "short_description" Yaml.string)
        (Yaml.field "tagline" Yaml.string)


fissionLiveDataDecoder : Yaml.Decoder FissionLiveData
fissionLiveDataDecoder =
    Yaml.map3
        FissionLiveData
        (Yaml.field "about" Yaml.string)
        (Yaml.field "terminal_caption" Yaml.string)
        (Yaml.field "title" Yaml.string)


herokuDataDecoder : Yaml.Decoder HerokuData
herokuDataDecoder =
    Yaml.map2
        HerokuData
        (Yaml.field "about" Yaml.string)
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
        (Yaml.field "note" Yaml.string)
        (Yaml.field "sub_text" Yaml.string)
        (Yaml.field "title" Yaml.string)



-- 🖼


view : PagePath -> Model -> DecodedData -> Element Msg
view pagePath model data =
    Element.column
        [ Element.height Element.fill
        , Element.width Element.fill
        ]
        [ intro pagePath model data
        , fissionLive pagePath model data
        , heroku pagePath model data
        , news pagePath model data
        , subscribe pagePath model data
        , Common.footer pagePath data.footer
        ]



-- INTRO


intro : PagePath -> Model -> DecodedData -> Element Msg
intro pagePath _ data =
    [ logo pagePath
    , tagline data
    , shortDescription data
    ]
        |> Element.column
            [ Element.centerX
            , Element.centerY
            ]
        |> Element.el
            [ Element.clip
            , Element.customStyle "min-height" "100vh"
            , Element.inFront (Common.menu pagePath)
            , Element.paddingXY (Kit.scales.spacing 6) 0
            , Element.width Element.fill
            , Background.color Kit.colors.gray_600
            ]
        |> Element.el
            [ Element.width Element.fill ]


logo pagePath =
    Element.image
        [ Element.centerX
        , Element.centerY
        , Element.paddingEach { edges | top = Kit.scales.spacing 12 }
        , Element.width (Element.maximum 550 Element.fill)
        ]
        { src = relativeImagePath { from = pagePath, to = images.logoDarkColored }
        , description = "FISSION"
        }


tagline data =
    Element.paragraph
        [ Element.paddingEach { edges | top = Kit.scales.spacing 12 }
        , Element.spacing (Kit.scales.spacing 2)
        , Font.center
        , Font.family Kit.fonts.display
        , Font.letterSpacing -0.625
        , Font.medium
        , Font.size (Kit.scales.typography 6)
        ]
        [ Element.text data.tagline
        ]


shortDescription data =
    Element.el
        [ Element.centerX
        , Element.paddingEach { edges | top = Kit.scales.spacing 8 }
        , Element.width (Element.maximum 500 Element.fill)
        , Font.center
        ]
        (data.shortDescription
            |> Element.text
            |> List.singleton
            |> Kit.subtleParagraph
        )



-- FISSION LIVE


fissionLive : PagePath -> Model -> DecodedData -> Element Msg
fissionLive pagePath _ data =
    Element.column
        [ Element.centerX
        , Element.id "fission-live"
        , Element.paddingXY (Kit.scales.spacing 6) (Kit.scales.spacing 24)
        , Font.center
        ]
        [ -- Title
          --------
          Kit.heading
            { level = 1 }
            [ Element.text data.fissionLive.title ]

        -- About
        --------
        , Element.el
            [ Element.centerX
            , Element.paddingEach
                { edges
                    | bottom = Kit.scales.spacing 12
                    , top = Kit.scales.spacing 8
                }
            , Element.width (Element.maximum 500 Element.fill)
            ]
            (data.fissionLive.about
                |> Element.text
                |> List.singleton
                |> Kit.subtleParagraph
            )

        -- Terminal GIF
        ---------------
        , Element.image
            [ Element.centerY
            , Element.clip
            , Element.width (Element.maximum 638 Element.fill)
            , Border.rounded Kit.defaultBorderRounding
            ]
            { src = "https://s3.fission.codes/2019/11/going-live-code-diffusion.gif"
            , description = ""
            }

        -- Caption
        , data.fissionLive.terminalCaption
            |> Common.rawHtml
            |> List.map Element.html
            |> Kit.caption
            |> Element.el [ Element.width (Element.maximum 638 Element.fill) ]

        -- Guide Link
        -------------
        , Element.el
            [ Element.centerX
            , Element.paddingEach { edges | top = Kit.scales.spacing 12 }
            ]
            (Element.newTabLink
                Kit.buttonAltAttributes
                { url = "https://guide.fission.codes/"
                , label = Element.text "Read the Guide"
                }
            )
        ]



-- HEROKU


heroku : PagePath -> Model -> DecodedData -> Element Msg
heroku pagePath _ data =
    [ -- Title
      --------
      Kit.heading
        { level = 1 }
        [ Element.text data.heroku.title ]

    -- About
    --------
    , Element.el
        [ Element.centerX
        , Element.paddingEach
            { edges
                | bottom = Kit.scales.spacing 12
                , top = Kit.scales.spacing 8
            }
        , Element.width (Element.maximum 500 Element.fill)
        ]
        (data.heroku.about
            |> Element.text
            |> List.singleton
            |> Kit.subtleParagraph
        )

    -- Image
    --------
    , Element.image
        [ Element.centerY
        , Element.clip
        , Element.width (Element.maximum 638 Element.fill)
        , Border.rounded Kit.defaultBorderRounding
        ]
        { src = "https://s3.fission.codes/2019/11/IMG_7574.jpg"
        , description = ""
        }

    -- Add-on Link
    --------------
    , Element.el
        [ Element.centerX
        , Element.paddingEach { edges | top = Kit.scales.spacing 12 }
        ]
        (Element.newTabLink
            Kit.buttonAttributes
            { url = "https://elements.heroku.com/addons/interplanetary-fission"
            , label = Element.text "Try the Add-on"
            }
        )
    ]
        |> Element.column
            [ Element.centerX
            , Element.id "heroku"
            , Element.paddingXY (Kit.scales.spacing 6) (Kit.scales.spacing 24)
            , Background.color Kit.colors.gray_600
            , Font.center
            ]
        |> Element.el
            [ Element.width Element.fill
            , Background.color Kit.colors.gray_600
            ]



-- NEWS


news : PagePath -> Model -> DecodedData -> Element Msg
news pagePath model data =
    Element.row
        [ Element.centerX
        , Element.id "news"
        , Element.paddingXY (Kit.scales.spacing 6) (Kit.scales.spacing 24)
        , Element.spacing (Kit.scales.spacing 16)
        , Element.width Common.containerLength
        ]
        [ -- Left
          -------
          Element.column
            [ Element.width (Element.fillPortion 4) ]
            [ Kit.heading
                { level = 1 }
                [ Element.text "News" ]

            --
            , model.latestBlogPosts
                |> List.indexedMap
                    (\idx ->
                        newsItem (idx == 0)
                    )
                |> Element.column
                    [ Element.paddingXY 0 (Kit.scales.spacing 12)
                    , Element.spacing (Kit.scales.spacing 6)
                    , Font.size (Kit.scales.typography 2)
                    ]

            --
            , Element.link
                Kit.buttonAltAttributes
                { url = "https://blog.fission.codes"
                , label = Element.text "Visit Fission Blog"
                }
            ]

        -- Right
        --------
        , Element.el
            [ Element.height Element.fill
            , Element.width (Element.fillPortion 5)
            , Background.color Kit.colors.gray_600
            , Background.image "https://fission.codes/assets/images/marvin-meyer-571072-unsplash-600.jpg"
            , Border.rounded Kit.defaultBorderRounding
            , Responsive.hide_lt_md
            ]
            Element.none
        ]


newsItem : Bool -> External.Blog.Post -> Element Msg
newsItem isFirst post =
    Element.column
        []
        [ if isFirst then
            Element.none

          else
            Element.el
                [ Element.height (Element.px 0)
                , Element.paddingEach { edges | bottom = Kit.scales.spacing 6 }
                , Element.width (Element.px 110)
                , Border.color Kit.colors.gray_600
                , Border.widthEach { none | top = 2 }
                ]
                Element.none

        --
        , { label = Element.text post.title
          , url = post.url
          }
            |> Element.link []
            |> List.singleton
            |> Element.paragraph []
        ]



-- SUBSCRIBE


subscribe : PagePath -> Model -> DecodedData -> Element Msg
subscribe pagePath model data =
    [ -- Sub text
      -----------
      Element.paragraph
        [ Element.paddingEach { edges | bottom = Kit.scales.spacing 5 }
        , Font.color Kit.colors.gray_400
        , Font.letterSpacing 0.5
        ]
        [ Element.text data.subscribe.subText
        ]

    -- Title
    --------
    , Kit.heading
        { level = 1 }
        [ Element.text data.subscribe.title ]

    -- Input
    --------
    , { onChange = GotSubscriptionInput
      , text = Maybe.withDefault "" model.subscribeToEmail
      , label = Input.labelHidden "email"

      --
      , placeholder =
            data.subscribe.inputPlaceholder
                |> Element.text
                |> Input.placeholder
                    [ Font.alignLeft
                    , Font.color Kit.colors.gray_500
                    ]
                |> Just
      }
        |> Input.text
            [ Background.color Kit.colors.white
            , Border.rounded Kit.defaultBorderRounding
            , Border.width 0
            , Font.size (Kit.scales.typography 2)
            , Element.paddingXY (Kit.scales.spacing 5) (Kit.scales.spacing 5)
            ]
        |> Element.el
            [ Element.centerX
            , Element.paddingEach { edges | top = Kit.scales.spacing 7 }
            , Element.width (Element.maximum 406 Element.fill)
            ]

    -- Button
    ---------
    , subscriptionButton model

    -- Note
    -------
    , Element.paragraph
        [ Element.paddingEach { edges | top = Kit.scales.spacing 5 }
        , Font.color Kit.colors.gray_300
        , Font.italic
        , Font.size (Kit.scales.typography -1)
        ]
        [ Element.text data.subscribe.note
        ]
    ]
        |> Element.column
            [ Element.centerX
            , Element.id "subscribe"
            , Element.paddingXY (Kit.scales.spacing 6) (Kit.scales.spacing 24)
            , Element.width Common.containerLength
            , Background.color Kit.colors.gray_600
            , Font.center
            ]
        |> Element.el
            [ Element.width Element.fill
            , Background.color Kit.colors.gray_600
            ]


subscriptionButton : Model -> Element Msg
subscriptionButton model =
    let
        buttonColor =
            case model.subscribing of
                Failed _ ->
                    Kit.colors.darkPink

                InProgress ->
                    Kit.colors.gray_400

                Stopped ->
                    Kit.colors.purple

                Succeeded ->
                    Kit.colors.gray_300

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
                (Kit.buttonAttributesWithColor buttonColor)
                [ Element.customStyle "transition" "background-color 250ms ease"
                , Element.paddingXY (Kit.scales.spacing 4) (Kit.scales.spacing 4)
                , Element.width Element.fill
                ]
    in
    { onPress = onPress
    , label = Element.text label
    }
        |> Input.button buttonAttributes
        |> Element.el
            [ Element.centerX
            , Element.paddingEach { edges | top = Kit.scales.spacing 5 }
            , Element.width (Element.maximum 406 Element.fill)
            ]
