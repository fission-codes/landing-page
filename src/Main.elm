module Main exposing (main)

import Content.Metadata exposing (Metadata)
import Content.Parsers exposing (Interpretation)
import Pages
import Pages.Platform
import State
import Types exposing (..)
import View



-- ⛩


main : Pages.Platform.Program Model Msg Metadata (Interpretation Msg)
main =
    Pages.Platform.application
        { init = State.init
        , update = State.update
        , subscriptions = State.subscriptions
        , view = View.root

        -- Elm Pages
        ------------
        , canonicalSiteUrl = Content.Metadata.canonicalSiteUrl
        , generateFiles = \_ -> []
        , documents = [ Content.Parsers.markdown, Content.Parsers.yaml ]
        , manifest = Content.Metadata.manifest

        --
        , internals = Pages.internals
        , onPageChange = \_ -> Bypass
        }
