module External.Blog exposing (..)

import OptimizedDecoder as Decode



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


postDecoder : Decode.Decoder Post
postDecoder =
    Decode.map3 Post
        (Decode.field "featured" Decode.bool)
        (Decode.field "url" Decode.string)
        (Decode.field "title" Decode.string)


latestPostsDecoder : Decode.Decoder (List Post)
latestPostsDecoder =
    postDecoder
        |> Decode.list
        |> Decode.field "posts"
        |> Decode.map
            (\posts ->
                case List.filter .featured posts of
                    [] ->
                        posts

                    featured ->
                        featured
            )
        |> Decode.map (List.take 5)
