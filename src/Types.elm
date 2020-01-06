module Types exposing (..)

import Content.Metadata exposing (Metadata)
import Content.Parsers exposing (Interpretation)
import Element exposing (Element)
import Pages
import Pages.ImagePath as Images
import Pages.PagePath as Pages
import Pages.Platform as Pages
import Yaml.Decode as Yaml



-- 🌱


{-| Model of our UI state.
-}
type alias Model =
    ()



-- 📣


{-| Messages, or actions, that influence our `Model`.
-}
type alias Msg =
    ()



-- 🧩


type alias ContentList =
    List ( PagePath, Metadata )


type alias ImagePath =
    Images.ImagePath Pages.PathKey


type alias Page =
    { path : PagePath
    , frontmatter : Metadata
    }


type alias PagePath =
    Pages.PagePath Pages.PathKey
