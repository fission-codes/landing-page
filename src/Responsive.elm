module Responsive exposing (hide_gte_lg, hide_gte_md, hide_gte_sm, hide_gte_xl, hide_lt_lg, hide_lt_md, hide_lt_sm, hide_lt_xl)

{-| CSS classes used throughout the app.
Mostly this will be used for dealing with media queries,
which can be found in the `View` module.

NOTE: This might not work on some specialized elements (like `Element.image`).
In that case, wrap it in a `Element.el` and use the attribute there.

-}

import Element
import Html.Attributes


{-| Hide on screens that're at least 640px wide.
-}
hide_gte_sm : Element.Attribute msg
hide_gte_sm =
    attr "hide-gte-sm"


{-| Hide on screens that're less than 640px wide.
-}
hide_lt_sm : Element.Attribute msg
hide_lt_sm =
    attr "hide-lt-sm"


{-| Hide on screens that're at least 768px wide.
-}
hide_gte_md : Element.Attribute msg
hide_gte_md =
    attr "hide-gte-md"


{-| Hide on screens that're less than 768px wide.
-}
hide_lt_md : Element.Attribute msg
hide_lt_md =
    attr "hide-lt-md"


{-| Hide on screens that're at least 1024px wide.
-}
hide_gte_lg : Element.Attribute msg
hide_gte_lg =
    attr "hide-gte-lg"


{-| Hide on screens that're less than 1024px wide.
-}
hide_lt_lg : Element.Attribute msg
hide_lt_lg =
    attr "hide-lt-lg"


{-| Hide on screens that're at least 1280px wide.
-}
hide_gte_xl : Element.Attribute msg
hide_gte_xl =
    attr "hide-gte-xl"


{-| Hide on screens that're less than 1280px wide.
-}
hide_lt_xl : Element.Attribute msg
hide_lt_xl =
    attr "hide-lt-xl"



-- ㊙️


attr : String -> Element.Attribute msg
attr k =
    Element.htmlAttribute (Html.Attributes.attribute k "")
