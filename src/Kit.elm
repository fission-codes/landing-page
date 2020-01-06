module Kit exposing (..)

import Element exposing (Element)
import Element.Font as Font
import Element.Region as Region



-- 🛠


rgb =
    Element.rgb255



-- 🎨


colors =
    { pink = rgb 255 82 116
    , purple = rgb 100 70 250

    --
    , gray_100 = rgb 30 35 71
    , gray_200 = rgb 62 65 92
    , gray_300 = rgb 120 122 143
    , gray_400 = rgb 165 167 184
    , gray_500 = rgb 206 208 224
    , gray_600 = rgb 235 236 245

    --
    , black = rgb 0 0 0
    , white = rgb 255 255 255
    }



-- Fonts


fonts =
    { body =
        [ Font.typeface "Karla"
        , Font.sansSerif
        ]

    --
    , display =
        [ Font.typeface "Work Sans"
        , Font.serif
        ]

    --
    , mono =
        [ Font.typeface "Space Mono"
        , Font.monospace
        ]
    }



-- Scaling


base =
    16


scales =
    { spacing = (*) (0.25 * base) >> round
    , typography = Element.modular base 1.125 >> round
    }



-- 🧱


codeBlock : { body : String, language : Maybe String } -> Element msg
codeBlock { body, language } =
    -- TODO
    Element.text body


heading : { level : Int } -> List (Element msg) -> Element msg
heading { level } =
    Element.paragraph
        [ Element.paddingXY 0 (scales.spacing 8)
        , Element.spacing (scales.spacing 2)
        , Font.letterSpacing -0.25
        , Font.size (scales.typography 4)
        , Region.heading level
        ]


inlineCode : String -> Element msg
inlineCode =
    -- TODO
    Element.text


link : { label : Element msg, title : String, url : String } -> Element msg
link attributes =
    Element.link
        [ Font.underline
        , Region.description attributes.title
        ]
        { label = attributes.label
        , url = attributes.url
        }


list : List (Element msg) -> Element msg
list _ =
    -- TODO
    Element.none


paragraph : List (Element msg) -> Element msg
paragraph =
    Element.paragraph
        [ Element.spacing (scales.spacing 2) ]
