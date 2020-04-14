module State.Other exposing (..)

import Ease
import Ports
import Return exposing (return)
import SmoothScroll
import Task
import Types exposing (..)



-- 🛠


openChat : Manager
openChat model =
    return model (Ports.showChat ())


{-| Smooth scroll to a certain node on the page.
-}
smoothScroll : { nodeId : String } -> Manager
smoothScroll { nodeId } model =
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
