module Common exposing (relativeImagePath, relativePagePath)

import Pages.ImagePath
import Pages.PagePath
import Types exposing (..)


relativeImagePath : { from : PagePath, to : ImagePath } -> String
relativeImagePath { from, to } =
    relativePath
        { from = Pages.PagePath.toString from
        , to = Pages.ImagePath.toString to
        }


relativePagePath : { from : PagePath, to : PagePath } -> String
relativePagePath { from, to } =
    relativePath
        { from = Pages.PagePath.toString from
        , to = Pages.PagePath.toString to
        }



-- ㊙️


relativePath : { from : String, to : String } -> String
relativePath { from, to } =
    from
        |> String.dropLeft 1
        |> String.split "/"
        |> List.drop 1
        |> List.map (\_ -> "..")
        |> String.join "/"
        |> (\prefix ->
                String.append prefix to
           )
        |> (\merged ->
                if String.startsWith "/" merged then
                    String.dropLeft 1 merged

                else
                    merged
           )
