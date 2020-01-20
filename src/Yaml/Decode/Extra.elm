module Yaml.Decode.Extra exposing (..)

import Content.Markdown
import Element exposing (Element)
import Markdown.Parser as Markdown
import Yaml.Decode as Yaml


deadEndsToString =
    List.map Markdown.deadEndToString >> String.join "\n"


markdownString : Yaml.Decoder (List (Element msg))
markdownString =
    Yaml.andThen
        (Markdown.parse
            >> Result.mapError deadEndsToString
            >> Result.andThen (Markdown.render Content.Markdown.renderer)
            >> (\result ->
                    case result of
                        Ok o ->
                            Yaml.succeed o

                        Err e ->
                            Yaml.fail e
               )
        )
        Yaml.string
