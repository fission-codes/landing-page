port module Ports exposing (..)

import Fathom



-- 📣


port setFathomGoal : Fathom.Goal -> Cmd msg


port showChat : () -> Cmd msg
