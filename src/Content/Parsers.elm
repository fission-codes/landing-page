module Content.Parsers exposing (..)

import Content.Markdown
import Content.Metadata as Metadata exposing (Metadata)
import Html exposing (Html)
import Pages.Document as Pages
import Yaml.Decode.Extra as Yaml



-- 🧩


type Interpretation msg
    = Data EncodedData
    | VirtualDom (Html msg)


type alias Parser msg =
    ( String, Pages.DocumentHandler Metadata (Interpretation msg) )


type alias EncodedData =
    -- TODO: This should ideally be Yaml.Value,
    --       but there's a function missing from the Yaml library.
    String



-- 🛠


markdown : Parser msg
markdown =
    Pages.parser
        { extension = "md"
        , metadata = Metadata.markdownMetadataDecoder
        , body = Content.Markdown.process >> Html.div [] >> VirtualDom >> Ok
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
