module State exposing (..)

import Ease
import External.Blog
import Http
import Json.Decode.Exploration as StrictJson
import SmoothScroll
import Task
import Types exposing (..)



-- 🌱


init : Maybe PagePath -> ( Model, Cmd Msg )
init _ =
    ( { latestBlogPosts = [] }
      -- Get the posts from the blog
    , Http.get
        { url = External.Blog.feedUrl
        , expect = Http.expectString GotBlogRssFeed
        }
    )



-- 📣


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Bypass ->
            -- Don't do anything.
            ( model
            , Cmd.none
            )

        GotBlogRssFeed (Ok json) ->
            case
                json
                    |> StrictJson.decodeString External.Blog.latestPostsDecoder
                    |> StrictJson.strict
            of
                Ok latestBlogPosts ->
                    ( { model | latestBlogPosts = Debug.log "" latestBlogPosts }
                    , Cmd.none
                    )

                Err _ ->
                    -- Ignore error
                    ( model
                    , Cmd.none
                    )

        GotBlogRssFeed (Err err) ->
            -- Ignore error
            ( model
            , Cmd.none
            )

        SmoothScroll { nodeId } ->
            -- Smooth scroll to a certain node on the page.
            ( model
            , Task.attempt
                (\_ -> Bypass)
                (SmoothScroll.scrollToWithOptions smoothScrollConfig nodeId)
            )


smoothScrollConfig : SmoothScroll.Config
smoothScrollConfig =
    { offset = 0
    , speed = 35
    , easing = Ease.inOutCubic
    }



-- 📰


subscriptions : Model -> Sub Msg
subscriptions _ =
    -- Not needed at the moment
    Sub.none
