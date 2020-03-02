module Kit.Local exposing (..)

import Color exposing (Color)
import Html exposing (Html)
import Html.Attributes as A
import Html.Events as E
import Html.Extra as Html
import Kit exposing (..)
import Tailwind as T



-- 🧱  ░░  BUTTONS


buttonAttributes : List (Html.Attribute msg)
buttonAttributes =
    buttonAttributesWithColor T.bg_purple


buttonAltAttributes : List (Html.Attribute msg)
buttonAltAttributes =
    buttonAttributesWithColor T.bg_pink


buttonAttributesWithColor : Html.Attribute msg -> List (Html.Attribute msg)
buttonAttributesWithColor colorAttribute =
    [ T.inline_block
    , T.leading_none
    , T.p_3
    , T.rounded
    , T.text_white

    --
    , colorAttribute
    ]


menuButtonAttributes : List (Html.Attribute msg)
menuButtonAttributes =
    [ T.bg_gray_200
    , T.leading_relaxed
    , T.px_2
    , T.py_1
    , T.rounded
    , T.text_gray_600
    ]



-- 🧱  ░░  TEXT


h2 : String -> Html msg
h2 text =
    Html.h2
        [ T.font_display
        , T.font_semibold
        , T.leading_tight
        , T.text_3xl
        , T.tracking_tight

        -- Responsive
        -------------
        , T.lg__text_3_5xl
        ]
        [ Html.text text ]



-- 🧱


containerAttributes : List (Html.Attribute msg)
containerAttributes =
    [ T.px_6
    , T.py_16
    , T.lg__py_24

    --
    , T.container
    , T.mx_auto
    , T.text_center
    ]


introParagraph : List (Html msg) -> Html msg
introParagraph =
    Html.p
        [ A.style "max-width" "500px"

        --
        , T.mx_auto
        , T.pt_5
        , T.text_gray_300

        -- Responsive
        -------------
        , T.md__pt_6
        , T.md__text_lg
        ]


tagline : String -> Html msg
tagline text =
    Html.h2
        [ T.font_display
        , T.font_medium
        , T.leading_tight
        , T.text_2xl
        , T.tracking_tight

        --
        , T.md__text_2_5xl
        ]
        [ Html.text text ]
