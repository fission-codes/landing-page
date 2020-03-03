module Validation exposing (..)

import Email



-- 🧩


type Validated data
    = Blank
    | Valid data
    | Invalid { data : data, note : String }



-- 🦉


email : String -> Validated String
email a =
    case String.trim a of
        "" ->
            Blank

        str ->
            if Email.isValid str then
                Valid str

            else
                Invalid { data = str, note = "I need a valid email address" }


message : String -> Validated String
message str =
    let
        trimmed =
            String.trim str
    in
    if String.length trimmed < 7 then
        Invalid { data = str, note = "I need a message that's a bit longer" }

    else
        Valid str



-- 🛠


data : a -> Validated a -> a
data default val =
    case val of
        Blank ->
            default

        Valid a ->
            a

        Invalid properties ->
            properties.data


isValid : Validated a -> Bool
isValid val =
    case val of
        Blank ->
            False

        Valid _ ->
            True

        Invalid _ ->
            False


isInvalid : Validated a -> Bool
isInvalid =
    isValid >> not
