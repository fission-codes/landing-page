module RemoteAction exposing (..)

import Html
import Tailwind as T



-- 🧩


type RemoteAction
    = Failed String
    | InProgress
    | Stopped
    | Succeeded



-- 🛠


backgroundColor : RemoteAction -> Html.Attribute msg
backgroundColor r =
    case r of
        Failed _ ->
            T.bg_red

        InProgress ->
            T.bg_gray_400

        Stopped ->
            T.bg_purple

        Succeeded ->
            T.bg_gray_300


recoverFromFailure : RemoteAction -> RemoteAction
recoverFromFailure r =
    case r of
        Failed _ ->
            Stopped

        _ ->
            r
