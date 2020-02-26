module State exposing (..)

import Ease
import External.Blog
import Fathom
import Http
import Json.Decode.Exploration as StrictJson
import Ports
import Return2 as Return exposing (return, returnWithModel)
import SmoothScroll
import Task
import Types exposing (..)



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
        , subscribeToEmail = Nothing
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
update msg model =
    case msg of
        Bypass ->
            -- Don't do anything.
            return model

        -----------------------------------------
        -- News
        -----------------------------------------
        GotBlogPosts (Ok json) ->
            case StrictJson.decodeString External.Blog.latestPostsDecoder json of
                StrictJson.Success latestBlogPosts ->
                    return { model | latestBlogPosts = latestBlogPosts }

                StrictJson.WithWarnings _ latestBlogPosts ->
                    return { model | latestBlogPosts = latestBlogPosts }

                _ ->
                    -- Can't decode the server response,
                    -- this should ideally never happen.
                    return model

        GotBlogPosts (Err err) ->
            -- Ignore error, the user shouldn't care if this fails.
            -- Besides, we have a cached backup for this.
            return model

        -----------------------------------------
        -- Subscribe
        -----------------------------------------
        GotSubscribeResponse (Ok ()) ->
            return { model | subscribing = Succeeded }

        GotSubscribeResponse (Err err) ->
            -- return { model | subscribing = Failed "HTTP Request Failed" }
            -- NOTE: We always get an error because of CORS issues with sendinblue.
            return { model | subscribing = Succeeded }

        GotSubscriptionInput input ->
            return { model | subscribeToEmail = Just input }

        Subscribe ->
            case Maybe.map String.trim model.subscribeToEmail of
                Just "" ->
                    return model

                Just email ->
                    ( { model | subscribing = InProgress }
                    , Cmd.batch
                        [ Http.post
                            { url = "https://5d04d668.sibforms.com/serve/MUIEAH9z71F3-xucvdxYTZ9rKE0dHzCDikuQqcnxjAyY3T2NBmxUOklz4XijWG0ML4E_sHeoyq1PBQM_-PpLAkraiFa51bhHUp64vZfo6XT38fr4H2eFpxjCSgcIpFDo1KFyRr3hWfQ4KZ8TCPG0YVqWEYDQVVGW_ZGwBgJcgjaLibCPjvshJzIeUYDSQPg2jHyvYshB1YuqPopz"
                            , body =
                                Http.multipartBody
                                    [ Http.stringPart "EMAIL" email
                                    , Http.stringPart "html_type" "simple"
                                    , Http.stringPart "locale" "en"
                                    ]
                            , expect =
                                Http.expectWhatever GotSubscribeResponse
                            }

                        --
                        , Ports.setFathomGoal Fathom.goals.emailSubscription
                        ]
                    )

                Nothing ->
                    return model

        -----------------------------------------
        -- 📭 Other
        -----------------------------------------
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
