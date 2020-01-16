module External.Blog exposing (..)

import Json.Decode.Exploration as StrictJson



-- ⛰


feedUrl : String
feedUrl =
    "https://blog.fission.codes/ghost/api/v2/content/posts/?key=83876461c60a6d08e2b9ac7b9c"



-- 🧩


type alias Post =
    { url : String
    , title : String
    }



-- DECODERS


postDecoder : StrictJson.Decoder Post
postDecoder =
    StrictJson.map2 Post
        (StrictJson.field "url" StrictJson.string)
        (StrictJson.field "title" StrictJson.string)


latestPostsDecoder : StrictJson.Decoder (List Post)
latestPostsDecoder =
    postDecoder
        |> StrictJson.list
        |> StrictJson.field "posts"
        |> StrictJson.map (List.take 5)
