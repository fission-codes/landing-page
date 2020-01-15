module State exposing (..)

import Ease
import SmoothScroll
import Task
import Types exposing (..)



-- 🌱


init : Maybe PagePath -> ( Model, Cmd Msg )
init _ =
    -- Not needed at the moment
    ( (), Cmd.none )



-- 📣


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- Don't do anything.
        Bypass ->
            ( model
            , Cmd.none
            )

        -- Smooth scroll to a certain node on the page.
        SmoothScroll { nodeId } ->
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
