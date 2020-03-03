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
                Invalid { data = str, note = "Please provide a valid email address" }



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
