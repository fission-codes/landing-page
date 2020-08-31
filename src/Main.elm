module Main exposing (main)

import Content.Metadata exposing (Frontmatter)
import Content.Parsers exposing (Interpretation)
import Pages
import Pages.Platform
import Redirects
import State
import Types exposing (..)
import View



-- ⛩


main : Pages.Platform.Program Model Msg Frontmatter (Interpretation Msg)
main =
    Pages.Platform.init
        { init = State.init
        , update = State.update
        , subscriptions = State.subscriptions
        , view = View.root

        -- Elm Pages
        ------------
        , canonicalSiteUrl = Content.Metadata.canonicalSiteUrl
        , documents = [ Content.Parsers.yaml ]
        , manifest = Content.Metadata.manifest

        --
        , internals = Pages.internals
        , onPageChange = Nothing
        }
        |> Pages.Platform.withFileGenerator Redirects.generate
        |> Pages.Platform.toProgram
