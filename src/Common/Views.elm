module Common.Views exposing (..)

import Common exposing (..)
import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Extra as Element
import Element.Font as Font
import Kit exposing (edges, none)
import Pages exposing (images, pages)
import Responsive
import Types exposing (..)
import Yaml.Decode as Yaml



-- 🧩


type alias FooterData =
    { discordLink : String
    , twitterLink : String
    , linkedinLink : String
    }



-- 🗄


footerDataDecoder : Yaml.Decoder FooterData
footerDataDecoder =
    Yaml.map3
        FooterData
        (Yaml.field "discord_link" Yaml.string)
        (Yaml.field "twitter_link" Yaml.string)
        (Yaml.field "linkedin_link" Yaml.string)



-- BADGE


badge : PagePath -> Element msg
badge pagePath =
    Element.image
        [ Element.centerY
        , Element.width (Element.px 30)
        ]
        { src = relativeImagePath { from = pagePath, to = images.badgeSolidFaded }
        , description = "FISSION"
        }



-- MENU


menu : PagePath -> Element Msg
menu pagePath =
    [ -- Logo Icon
      ------------
      badge pagePath

    -- Links
    --------
    , Element.row
        [ Element.alignRight
        , Element.centerY
        , Element.spacing (Kit.scales.spacing 8)
        ]
        [ menuItem "fission-live" "Fission Live"
        , menuItem "heroku" "Heroku"
        , menuItem "news" "News"

        --
        , Element.link
            (menuItemAttributes "subscribe")
            { url = ""
            , label =
                Element.el
                    [ Element.paddingEach
                        { top = Kit.scales.spacing 2.25
                        , right = Kit.scales.spacing 2.25
                        , bottom = Kit.scales.spacing 2
                        , left = Kit.scales.spacing 2.25
                        }
                    , Background.color Kit.colors.gray_200
                    , Border.rounded Kit.defaultBorderRounding
                    , Font.color Kit.colors.gray_600
                    ]
                    (Element.text "Subscribe")
            }
        ]
    ]
        |> Element.row
            [ Element.alignTop
            , Element.centerX
            , Element.paddingXY 0 (Kit.scales.spacing 8)
            , Element.width Common.containerLength
            , Border.color Kit.colors.gray_500
            , Border.widthEach { edges | bottom = 1 }
            ]
        |> Element.el
            [ Element.paddingXY (Kit.scales.spacing 6) 0
            , Element.width Element.fill
            ]


menuItem : String -> String -> Element Msg
menuItem id text =
    Element.link
        (menuItemAttributes id)
        -- TODO: Ideally this should be "#id",
        --       but then the browser jumps to that location
        --       (instead of actually doing the smooth scroll)
        { url = ""
        , label = Element.text text
        }


menuItemAttributes : String -> List (Element.Attribute Msg)
menuItemAttributes id =
    [ Events.onClick (SmoothScroll { nodeId = id })
    , Font.color Kit.colors.gray_200
    ]



-- FOOTER


footer : PagePath -> FooterData -> Element Msg
footer pagePath data =
    [ -- Logo
      -------
      footerItem (badge pagePath)

    -- Company Name
    ---------------
    , "© Fission Internet Software"
        |> Kit.subtleText
        |> Element.el
            [ Element.centerX
            , Responsive.hide_lt_md
            ]
        |> footerItem

    -- Social Links
    ---------------
    , [ socialLink "Discord" data.discordLink
      , socialLink "Twitter" data.twitterLink
      , socialLink "LinkedIn" data.linkedinLink
      ]
        |> Element.row
            [ Element.alignRight
            , Element.spacing (Kit.scales.spacing 4)
            ]
        |> footerItem
    ]
        |> Element.row
            [ Border.color Kit.colors.gray_500
            , Border.widthEach { edges | top = 1 }
            , Element.centerX
            , Element.id "footer"
            , Element.paddingXY 0 (Kit.scales.spacing 8)
            , Element.width Common.containerLength
            ]
        |> Element.el
            [ Background.color Kit.colors.gray_600
            , Element.paddingXY (Kit.scales.spacing 6) 0
            , Element.width Element.fill
            ]


footerItem : Element msg -> Element msg
footerItem content =
    Element.el
        [ Element.centerY
        , Element.width (Element.fillPortion 1)
        ]
        content


socialLink : String -> String -> Element msg
socialLink name url =
    Kit.link
        { label = Kit.subtleText name
        , title = name ++ " Link"
        , url = url
        }
