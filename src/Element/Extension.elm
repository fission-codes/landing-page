module Element.Extension exposing (..)

import Element
import Html
import Html.Attributes


customStyle : String -> String -> Element.Attribute msg
customStyle k v =
    Element.htmlAttribute (Html.Attributes.style k v)


textWithLineBreaks : String -> Element.Element msg
textWithLineBreaks text =
    Element.el
        [ customStyle "white-space" "break-spaces" ]
        (Element.html <| Html.text text)
