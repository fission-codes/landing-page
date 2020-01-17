module Color.Transform exposing (..)

import Color
import Element


{-| Unfortunately elm-ui uses it's own Color type,
this function takes a color of that type and
gives back one of the `Color.Color` type.
-}
transform : Element.Color -> Color.Color
transform =
    Element.toRgb >> Color.fromRgba
