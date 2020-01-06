module Content.Parsers exposing (..)

import Content.Metadata as Metadata exposing (Metadata)
import Element exposing (Element)
import Element.Font
import Kit
import Markdown.Html
import Markdown.Parser as Markdown
import Pages.Document as Pages
import Yaml.Decode as Yaml



-- 🧩


type Interpretation msg
    = Data EncodedData
    | VirtualDom (Element msg)


type alias Parser msg =
    ( String, Pages.DocumentHandler Metadata (Interpretation msg) )


type alias EncodedData =
    -- TODO: This should ideally be Yaml.Value,
    --       but there's a function missing from the Yaml library.
    String



-- 🛠


markdown : Parser msg
markdown =
    let
        deadEndsToString =
            List.map Markdown.deadEndToString >> String.join "\n"
    in
    Pages.parser
        { extension = "md"
        , metadata = Metadata.markdownMetadataDecoder
        , body =
            Markdown.parse
                >> Result.mapError deadEndsToString
                >> Result.andThen (Markdown.render markdownRenderer)
                >> Result.map (Element.column [] >> VirtualDom)
        }


yaml : Parser msg
yaml =
    Pages.parser
        { extension = "yml"
        , metadata = Metadata.yamlMetadataDecoder
        , body = Data >> Ok

        -- TODO:
        -- See comment on `EncodedData` type
        --
        -- Yaml.fromString Yaml.value
        --     >> Result.mapError
        --         (\err ->
        --             case err of
        --                 Yaml.Parsing e ->
        --                     "Failed to parse YAML: " ++ e
        --
        --                 Yaml.Decoding e ->
        --                     "Failed to decode YAML: " ++ e
        --         )
        --     >> Result.map Data
        }



-- MARKDOWN


markdownRenderer : Markdown.Renderer (Element msg)
markdownRenderer =
    { -----------------------------------------
      -- HTML
      -----------------------------------------
      html = Markdown.Html.oneOf []

    -----------------------------------------
    -- Inline
    -----------------------------------------
    , bold = Element.el [ Element.Font.bold ] << Element.text
    , code = Kit.inlineCode
    , italic = Element.el [ Element.Font.italic ] << Element.text
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
    , list = Kit.list
    , thematicBreak = Element.none
    , raw = Kit.paragraph
    }
