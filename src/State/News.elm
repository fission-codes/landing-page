module State.News exposing (..)

import External.Blog
import Http
import Json.Decode.Exploration as StrictJson
import Return
import Types exposing (..)



-- 🛠


gotPosts : Result Http.Error String -> Manager
gotPosts result model =
    case result of
        Ok json ->
            case StrictJson.decodeString External.Blog.latestPostsDecoder json of
                StrictJson.Success latestBlogPosts ->
                    Return.singleton { model | latestBlogPosts = latestBlogPosts }

                StrictJson.WithWarnings _ latestBlogPosts ->
                    Return.singleton { model | latestBlogPosts = latestBlogPosts }

                _ ->
                    -- Can't decode the server response,
                    -- this should ideally never happen.
                    Return.singleton model

        Err err ->
            -- Ignore error, the user shouldn't care if this fails.
            -- Besides, we have a cached backup for this.
            Return.singleton model
