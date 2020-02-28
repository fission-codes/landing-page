module Types exposing (..)

import Content.Metadata exposing (Metadata)
import Content.Parsers exposing (Interpretation)
import External.Blog
import Http
import Pages
import Pages.ImagePath as Images
import Pages.PagePath as Pages
import Pages.Platform as Pages
import Yaml.Decode as Yaml



-- 🌱


{-| Model of our UI state.
-}
type alias Model =
    { latestBlogPosts : List External.Blog.Post
    , subscribeToEmail : Maybe String
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


type RemoteAction
    = Failed String
    | InProgress
    | Stopped
    | Succeeded
