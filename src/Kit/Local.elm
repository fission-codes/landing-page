module Kit.Local exposing (..)

import Color exposing (Color)
import Html exposing (Html)
import Html.Attributes as A
import Html.Events as E
import Html.Events.Extra as E
import Html.Extra as Html
import Kit exposing (..)
import Tailwind as T
import Validation exposing (Validated)



-- 🧱  ░░  BUTTONS


buttonAttributes : List (Html.Attribute msg)
buttonAttributes =
    buttonAttributesWithColor T.bg_purple


buttonAltAttributes : List (Html.Attribute msg)
buttonAltAttributes =
    buttonAttributesWithColor T.bg_pink


buttonAttributesWithColor : Html.Attribute msg -> List (Html.Attribute msg)
buttonAttributesWithColor colorAttribute =
    [ T.ease_in_out
    , T.inline_block
    , T.leading_none
    , T.p_3
    , T.rounded
    , T.text_white
    , T.transition
    , T.transition_colors

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



-- 🧱  ░░  FORMS


type alias InputOptions msg =
    { name : String
    , onInput : String -> msg
    , placeholder : String
    , value : Validated String
    }


inputAttributes : InputOptions msg -> List (Html.Attribute msg)
inputAttributes { name, onInput, placeholder, value } =
    [ A.name name
    , E.onInput onInput
    , A.placeholder placeholder
    , A.value (Validation.data "" value)

    --
    , T.appearance_none
    , T.bg_white
    , T.border_0
    , T.block
    , T.max_w_md
    , T.mx_auto
    , T.mt_6
    , T.p_4
    , T.rounded
    , T.text_base
    , T.w_full

    -- Responsive
    -------------
    , T.md__p_5
    , T.md__text_lg
    ]


labelAttributes : List (Html.Attribute msg)
labelAttributes =
    [ T.block
    , T.font_semibold
    , T.font_display
    , T.max_w_md
    , T.neg_mb_4
    , T.mt_8
    , T.mx_auto
    , T.text_gray_300
    , T.text_left
    , T.text_xs
    , T.tracking_widest
    , T.uppercase
    ]



-- 🧱  ░░  TEXT


h2 : String -> Html msg
h2 text =
    Html.h2
        [ T.font_display
        , T.font_semibold
        , T.leading_tight
        , T.text_2_5xl
        , T.tracking_tight

        -- Responsive
        -------------
        , T.md__text_3xl
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
    Html.div
        [ T.max_w_lg
        , T.mx_auto
        , T.pt_5
        , T.px_3
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
