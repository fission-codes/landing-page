module Types exposing (..)

import Content.Metadata exposing (Metadata)
import Content.Parsers exposing (Interpretation)
import External.Blog
import Http
import Pages
import Pages.ImagePath as Images
import Pages.PagePath as Pages
import Pages.Platform as Pages
import RemoteAction exposing (RemoteAction)
import Validation exposing (Validated(..))
import Yaml.Decode as Yaml



-- 🌱


{-| Model of our UI state.
-}
type alias Model =
    { contacting : RemoteAction
    , contactEmail : Validated String
    , contactMessage : Validated String
    , latestBlogPosts : List External.Blog.Post
    , subscribeToEmail : Validated String
    , subscribing : RemoteAction
    }



-- 📣


{-| Messages, or actions, that influence our `Model`.
-}
type Msg
    = Bypass
      -----------------------------------------
      -- Contact
      -----------------------------------------
    | Contact
    | GotContactEmail String
    | GotContactMessage String
    | GotContactResponse (Result Http.Error ())
      -----------------------------------------
      -- News
      -----------------------------------------
    | GotBlogPosts (Result Http.Error String)
      -----------------------------------------
      -- Subscribe
      -----------------------------------------
    | GotSubscribeResponse (Result Http.Error ())
    | GotSubscriptionInput String
    | Subscribe
      -----------------------------------------
      -- 📭 Other
      -----------------------------------------
    | SmoothScroll { nodeId : String }



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
