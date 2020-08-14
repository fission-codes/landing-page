module Common.Views exposing (..)

import Common exposing (..)
import Html exposing (Html)
import Html.Attributes as A
import Html.Events as E
import Html.Events.Extra as E
import Html.Extra as Html
import Kit.Local as Kit
import Pages exposing (images, pages)
import Pages.ImagePath as ImagePath
import Pages.PagePath as PagePath
import Tailwind as T
import Types exposing (..)
import Yaml.Decode as Yaml



-- 🧩


type alias FooterData =
    { links : List FooterLink }


type alias FooterLink =
    { url : String, label : String }


type alias MenuData =
    { indexLink : String
    }



-- 🗄


footerDataDecoder : Yaml.Decoder FooterData
footerDataDecoder =
    footerLinkDecoder
        |> Yaml.list
        |> Yaml.field "links"
        |> Yaml.map FooterData


footerLinkDecoder : Yaml.Decoder FooterLink
footerLinkDecoder =
    Yaml.map2
        FooterLink
        (Yaml.field "url" Yaml.string)
        (Yaml.field "label" Yaml.string)


menuDataDecoder : Yaml.Decoder MenuData
menuDataDecoder =
    Yaml.map
        MenuData
        (Yaml.field "index_link" Yaml.string)



-- BADGE


badge : Html msg
badge =
    Html.img
        [ A.src (ImagePath.toString images.badgeSolidFaded)
        , A.title "FISSION"
        , A.width 30
        ]
        []


badgeFission : Html msg
badgeFission =
    Html.img
        [ A.src (ImagePath.toString images.logoDarkColored)
        , A.title "FISSION"
        , A.height 30
        , A.width 144
        ]
        []



-- ERROR


error : String -> Html msg
error err =
    -- TODO
    Html.div
        [ T.absolute
        , T.left_1over2
        , T.neg_translate_x_1over2
        , T.neg_translate_y_1over2
        , T.top_1over2
        , T.transform
        ]
        [ Html.text err ]



-- MENU


menu : PagePath -> List (Html.Attribute Msg) -> List (Html Msg) -> Html Msg
menu currentPage attributes contents =
    Html.div
        (List.append
            [ T.border_b
            , T.container
            , T.flex
            , T.items_center
            , T.mx_auto
            , T.py_8
            ]
            attributes
        )
        [ if currentPage == pages.index then
            badge

          else
            Html.a
                [ A.href (PagePath.toString pages.index) ]
                [ badgeFission ]

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
    Html.button
        (T.hidden :: T.md__block :: menuItemAttributes id)
        [ Html.text text ]


menuItemAttributes : String -> List (Html.Attribute Msg)
menuItemAttributes id =
    (::)
        (E.onClickPreventDefault <| SmoothScroll { nodeId = id })
        menuItemStyleAttributes


menuItemStyleAttributes : List (Html.Attribute msg)
menuItemStyleAttributes =
    [ T.appearance_none
    , T.cursor_pointer
    , T.ml_8
    , T.text_gray_200

    -- Responsive
    -------------
    , T.first__ml_0
    ]


menuItems : MenuData -> Html Msg
menuItems data =
    Html.div
        [ T.flex
        , T.items_center
        ]
        [ Html.a
            (List.append
                (A.href (PagePath.toString pages.index) :: menuItemStyleAttributes)
                Kit.menuButtonAttributes
            )
            [ Html.text data.indexLink
            ]
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
    , data.links
        |> List.map (\l -> footerLink l.label l.url)
        |> (::)
            (if currentPage == pages.support then
                Html.nothing

             else
                footerLink "Support" (PagePath.toString pages.support)
            )
        |> Html.div [ T.ml_auto ]
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


footerLink : String -> String -> Html msg
footerLink label url =
    Html.a
        [ A.href url
        , A.title (label ++ " Link")

        --
        , T.ml_4
        , T.text_gray_300
        , T.underline
        ]
        [ Html.text label ]
