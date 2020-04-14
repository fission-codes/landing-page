module Types exposing (..)

import Content.Metadata exposing (Metadata)
import External.Blog
import Http
import Management
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
    { latestBlogPosts : List External.Blog.Post
    , subscribeToEmail : Validated String
    , subscribing : RemoteAction
    }



-- 📣


{-| Messages, or actions, that influence our `Model`.
-}
type Msg
    = Bypass
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
    | OpenChat
    | SmoothScroll { nodeId : String }



-- 🧩


type alias ContentList =
    List ( PagePath, Metadata )


type alias ImagePath =
    Images.ImagePath Pages.PathKey


type alias Manager =
    Management.Manager Msg Model


type alias Page =
    { path : PagePath
    , frontmatter : Metadata
    }


type alias PagePath =
    Pages.PagePath Pages.PathKey
