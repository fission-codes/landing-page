module External.Blog exposing (..)

import Json.Decode.Exploration as StrictJson



-- ⛰


feedUrl : String
feedUrl =
    "https://blog.fission.codes/ghost/api/v2/content/posts/?key=83876461c60a6d08e2b9ac7b9c"



-- 🧩


type alias Post =
    { featured : Bool
    , url : String
    , title : String
    }



-- DECODERS


postDecoder : StrictJson.Decoder Post
postDecoder =
    StrictJson.map3 Post
        (StrictJson.field "featured" StrictJson.bool)
        (StrictJson.field "url" StrictJson.string)
        (StrictJson.field "title" StrictJson.string)


latestPostsDecoder : StrictJson.Decoder (List Post)
latestPostsDecoder =
    postDecoder
        |> StrictJson.list
        |> StrictJson.field "posts"
        |> StrictJson.map
            (\posts ->
                case List.filter .featured posts of
                    [] ->
                        posts

                    featured ->
                        featured
            )
        |> StrictJson.map (List.take 5)
