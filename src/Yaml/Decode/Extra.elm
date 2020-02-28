module Yaml.Decode.Extra exposing (..)

import Content.Markdown
import Html exposing (Html)
import Yaml.Decode as Yaml


markdownString : Yaml.Decoder (List (Html msg))
markdownString =
    Yaml.andThen
        (Content.Markdown.process >> Yaml.succeed)
        Yaml.string
