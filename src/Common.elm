module Common exposing (..)

import Types exposing (..)
import Yaml.Decode as Yaml



-- 🗄


decodeYaml : Yaml.Decoder a -> String -> Result String a
decodeYaml decoder yaml =
    yaml
        |> Yaml.fromString decoder
        |> Result.mapError
            (\error ->
                case error of
                    Yaml.Parsing string ->
                        "YAML parsing error: " ++ string

                    Yaml.Decoding string ->
                        "YAML decoding error: " ++ string
            )
