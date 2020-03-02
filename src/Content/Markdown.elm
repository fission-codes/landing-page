module Content.Markdown exposing (..)

import Html exposing (Html)
import Markdown
import Markdown.Config as Markdown



-- 🛠


process : String -> List (Html msg)
process =
    { softAsHardLineBreak =
        False
    , rawHtml =
        Markdown.Sanitize
            { allowedHtmlElements =
                "abbr" :: Markdown.defaultSanitizeOptions.allowedHtmlElements
            , allowedHtmlAttributes =
                "title" :: Markdown.defaultSanitizeOptions.allowedHtmlAttributes
            }
    }
        |> Just
        |> Markdown.toHtml


trimAndProcess : String -> List (Html msg)
trimAndProcess =
    String.trim >> process
