module Matter.NotFound exposing (render)

import Content.Metadata exposing (Frontmatter)
import Content.Parsers exposing (EncodedData)
import Html exposing (Html)
import Tailwind as T
import Types exposing (..)


render : ContentList -> PagePath -> Frontmatter -> EncodedData -> Model -> Html Msg
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
