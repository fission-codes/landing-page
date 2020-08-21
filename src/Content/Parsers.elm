module Content.Parsers exposing (..)

import Content.Markdown
import Content.Metadata as Metadata exposing (Frontmatter)
import Html exposing (Html)
import Json.Decode exposing (Decoder)
import Yaml.Decode as Yaml
import Yaml.Decode.Extra as Yaml



-- 🧩


type Interpretation msg
    = Data EncodedData
    | VirtualDom (Html msg)


type alias Parser msg =
    { extension : String
    , metadata : Decoder Frontmatter
    , body : String -> Result String (Interpretation msg)
    }


type alias EncodedData =
    Yaml.Value



-- 🛠


yaml : Parser msg
yaml =
    { extension = "yml"
    , metadata = Metadata.frontmatterDecoder
    , body =
        Yaml.fromString Yaml.value
            >> Result.mapError Yaml.errorToString
            >> Result.map Data
    }
