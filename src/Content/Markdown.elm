module Content.Markdown exposing (..)

import Element exposing (Element)
import Element.Border as Border
import Element.Extra as Element
import Element.Font as Font
import Element.Region as Region
import Html
import Html.Attributes
import Kit exposing (edges)
import Markdown.Html
import Markdown.Parser as Markdown


renderer : Markdown.Renderer (Element msg)
renderer =
    { -----------------------------------------
      -- HTML
      -----------------------------------------
      html = Markdown.Html.oneOf []

    -----------------------------------------
    -- Inline
    -----------------------------------------
    , bold = Element.el [ Font.bold ] << Element.text
    , code = Kit.inlineCode
    , italic = Element.el [ Font.italic ] << Element.text
    , plain = Element.text

    --
    , image =
        \{ src } body ->
            { src = src, description = body }
                |> Element.image [ Element.width Element.fill ]
                |> Ok

    --
    , link =
        \{ title, destination } body ->
            { label = Maybe.withDefault Element.none (List.head body)
            , title = Maybe.withDefault "" title
            , url = destination
            }
                |> Kit.link
                |> Ok

    -----------------------------------------
    -- Blocks
    -----------------------------------------
    , codeBlock = Kit.codeBlock
    , heading = \{ level, rawText, children } -> Kit.heading { level = level } children

    -- TODO
    , orderedList = Kit.orderedList
    , raw = Kit.paragraph
    , thematicBreak = Element.none
    , unorderedList = Kit.unorderedList
    }
