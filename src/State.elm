module State exposing (..)

import Types exposing (..)



-- 🌱


init : Maybe PagePath -> ( Model, Cmd Msg )
init _ =
    -- Not needed at the moment
    ( (), Cmd.none )



-- 📣


update : Msg -> Model -> ( Model, Cmd Msg )
update _ _ =
    -- Not needed at the moment
    ( (), Cmd.none )



-- 📰


subscriptions : Model -> Sub Msg
subscriptions _ =
    -- Not needed at the moment
    Sub.none
