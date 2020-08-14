module Matter.NotFound exposing (render)

import Html exposing (Html)
import Tailwind as T
import Types exposing (..)
import Content.Metadata exposing (MetadataForPages)
import Content.Parsers exposing (EncodedData)


render : ContentList -> PagePath -> MetadataForPages -> EncodedData -> Model -> Html Msg
render _ _ _ _ _ =
    Html.div
        [ T.absolute
        , T.italic
        , T.left_1over2
        , T.top_1over2
        , T.neg_translate_x_1over2
        , T.neg_translate_y_1over2
        ]
        [ Html.text "Page not found" ]
