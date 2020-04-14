module State exposing (..)

import Ease
import External.Blog
import Http
import RemoteAction exposing (RemoteAction(..))
import Return
import SmoothScroll
import State.News as News
import State.Other as Other
import State.Subscribe as Subscribe
import Types exposing (..)
import Validation exposing (Validated(..))



-- 🌱


init :
    Maybe
        { path : PagePath
        , query : Maybe String
        , fragment : Maybe String
        }
    -> ( Model, Cmd Msg )
init _ =
    Tuple.pair
        -----------------------------------------
        -- Model
        -----------------------------------------
        { latestBlogPosts = []
        , subscribeToEmail = Blank
        , subscribing = Stopped
        }
        -----------------------------------------
        -- Command
        -----------------------------------------
        (Http.get
            { url = External.Blog.feedUrl
            , expect = Http.expectString GotBlogPosts
            }
        )



-- 📣


update : Msg -> Model -> ( Model, Cmd Msg )
update msg =
    case msg of
        Bypass ->
            -- Don't do anything.
            Return.singleton

        -----------------------------------------
        -- News
        -----------------------------------------
        GotBlogPosts a ->
            News.gotPosts a

        -----------------------------------------
        -- Subscribe
        -----------------------------------------
        GotSubscribeResponse a ->
            Subscribe.gotResponse a

        GotSubscriptionInput a ->
            Subscribe.gotInput a

        Subscribe ->
            Subscribe.subscribe

        -----------------------------------------
        -- 📭 Other
        -----------------------------------------
        OpenChat ->
            Other.openChat

        SmoothScroll a ->
            Other.smoothScroll a



-- 📰


subscriptions : Model -> Sub Msg
subscriptions _ =
    -- Not needed at the moment
    Sub.none
