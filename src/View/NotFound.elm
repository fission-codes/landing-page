module View.NotFound exposing (view)

import Element
import Element.Font


view _ _ _ _ =
    Element.el
        [ Element.centerX
        , Element.centerY
        , Element.Font.italic
        ]
        (Element.text "Page not found")
