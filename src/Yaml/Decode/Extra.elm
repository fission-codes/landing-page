module Yaml.Decode.Extra exposing (..)

import Content.Markdown
import Element exposing (Element)
import Yaml.Decode as Yaml


markdownString : Yaml.Decoder (Element msg)
markdownString =
    Yaml.andThen
        (Content.Markdown.process
            >> Element.column []
            >> Yaml.succeed
        )
        Yaml.string
