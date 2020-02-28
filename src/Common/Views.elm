module Common.Views exposing (..)

import Common exposing (..)
import Html exposing (Html)
import Html.Attributes as A
import Html.Events as E
import Html.Events.Extra as E
import Html.Extra as Html
import Kit
import Pages exposing (images, pages)
import Pages.ImagePath as ImagePath
import Pages.PagePath as PagePath
import Tailwind as T
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


badge : Html msg
badge =
    Html.img
        [ A.src (ImagePath.toString images.badgeSolidFaded)
        , A.title "FISSION"
        , A.width 30
        ]
        []



-- ERROR


error : String -> Html msg
error err =
    -- TODO
    Html.div
        [ T.absolute
        , T.left_1over2
        , T.top_1over2
        , T.neg_translate_x_1over2
        , T.neg_translate_y_1over2
        ]
        [ Html.text err ]



-- MENU


menu : PagePath -> List (Html Msg) -> Html Msg
menu currentPage contents =
    Html.div
        [ T.border_b
        , T.border_gray_500
        , T.container
        , T.flex
        , T.items_center
        , T.mx_auto
        , T.py_8
        ]
        [ if currentPage == pages.index then
            badge

          else
            Html.a
                [ A.href (PagePath.toString pages.index) ]
                [ badge ]

        --
        , Html.div
            [ T.ml_auto ]
            contents
        ]


menuItem : String -> String -> Html Msg
menuItem id text =
    -- TODO: Ideally this should have the "#id" href,
    --       but then the browser jumps to that location
    --       instead of actually doing the smooth scroll.
    --       (yes, even with "preventDefault")
    Html.span
        (T.hidden :: T.md__block :: menuItemAttributes id)
        [ Html.text text ]


menuItemAttributes : String -> List (Html.Attribute Msg)
menuItemAttributes id =
    [ E.onClickPreventDefault (SmoothScroll { nodeId = id })

    --
    , T.cursor_pointer
    , T.ml_8
    , T.text_gray_200

    -- Responsive
    -------------
    , T.first__ml_0
    ]



-- FOOTER


footer : PagePath -> FooterData -> Html Msg
footer currentPage data =
    [ -----------------------------------------
      -- Logo
      -----------------------------------------
      badge
    , Html.div
        [ T.hidden
        , T.ml_4
        , T.text_gray_300

        --
        , T.md__block
        ]
        [ Html.text "Fission Internet Software" ]

    -----------------------------------------
    -- Social Links
    -----------------------------------------
    , Html.div
        [ T.ml_auto ]
        [ if currentPage == pages.support then
            Html.nothing

          else
            socialLink "Support" (PagePath.toString pages.support)

        --
        , socialLink "Discord" data.discordLink
        , socialLink "Twitter" data.twitterLink
        , socialLink "LinkedIn" data.linkedinLink
        ]
    ]
        |> Html.div
            [ A.id "footer"
            , T.border_t
            , T.border_gray_500
            , T.container
            , T.flex
            , T.items_center
            , T.mx_auto
            , T.py_8
            ]
        |> List.singleton
        |> Html.div
            [ T.bg_gray_600
            , T.px_6
            ]


socialLink : String -> String -> Html msg
socialLink name url =
    Html.a
        [ A.href url
        , A.title (name ++ " Link")

        --
        , T.ml_4
        , T.text_gray_300
        , T.underline
        ]
        [ Html.text name ]
