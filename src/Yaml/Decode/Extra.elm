module Yaml.Decode.Extra exposing (..)

import Content.Markdown
import Element exposing (Element)
import Yaml.Decode as Yaml


markdownString : Yaml.Decoder (List (Element msg))
markdownString =
    Yaml.andThen
        (Content.Markdown.process >> Yaml.succeed)
        Yaml.string
