module Content.Parsers exposing (..)

import Content.Markdown
import Content.Metadata as Metadata exposing (Metadata)
import Html exposing (Html)
import Json.Decode exposing (Decoder)
import Yaml.Decode.Extra as Yaml



-- 🧩


type Interpretation msg
    = Data EncodedData
    | VirtualDom (Html msg)


type alias Parser msg =
    { extension : String
    , metadata : Decoder Metadata
    , body : String -> Result String (Interpretation msg)
    }


type alias EncodedData =
    -- TODO: This should ideally be Yaml.Value,
    --       but there's a function missing from the Yaml library.
    String



-- 🛠


yaml : Parser msg
yaml =
    { extension = "yml"
    , metadata = Metadata.metadataDecoder
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
