module Content.Markdown exposing (process)

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
