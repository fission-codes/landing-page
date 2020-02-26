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
import Pages.ImagePath as ImagePath
import Pages.PagePath as PagePath
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


badge : Element msg
badge =
    Element.image
        [ Element.centerY
        , Element.width (Element.px 30)
        ]
        { src = ImagePath.toString images.badgeSolidFaded
        , description = "FISSION"
        }



-- MENU


menu : PagePath -> List (Element Msg) -> Element Msg
menu currentPage contents =
    [ if currentPage == pages.index then
        badge

      else
        Element.link
            []
            { url = PagePath.toString pages.index
            , label = badge
            }
    ]
        |> (\l -> l ++ contents)
        |> Element.row
            [ Element.alignTop
            , Element.centerX
            , Element.paddingXY 0 (Kit.scales.spacing 8)
            , Element.width Common.containerLength
            , Border.color Kit.colors.gray_500
            , Border.widthEach { edges | bottom = 1 }
            ]


menuItem : String -> String -> Element Msg
menuItem id text =
    Element.link
        (Responsive.hide_lt_md :: menuItemAttributes id)
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
footer currentPage data =
    [ -- Logo
      -------
      [ badge
      , Kit.subtleText "Fission Internet Software"
      ]
        |> Element.row
            [ Element.spacing (Kit.scales.spacing 4)
            ]
        |> footerItem

    -- Social Links
    ---------------
    , [ if currentPage == pages.support then
            Element.none

        else
            socialLink "Support" (PagePath.toString pages.support)

      --
      , socialLink "Discord" data.discordLink
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
