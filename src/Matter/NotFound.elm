module Matter.NotFound exposing (render)

import Element
import Element.Font


render _ _ _ _ =
    Element.el
        [ Element.centerX
        , Element.centerY
        , Element.Font.italic
        ]
        (Element.text "Page not found")
