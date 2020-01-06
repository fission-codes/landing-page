module View.Blog.Index exposing (view)

import Common exposing (..)
import Content.Metadata as Metadata exposing (MetadataForPages)
import Content.Parsers exposing (EncodedData)
import Element exposing (Element)
import Kit
import Pages exposing (pages)
import Pages.Directory as Directory
import Types exposing (..)



-- 🌈


view : ContentList -> PagePath -> MetadataForPages -> EncodedData -> Element Msg
view contentList currentPagePath meta _ =
    contentList
        |> List.filterMap
            (\( pagePath, metadata ) ->
                case metadata of
                    Metadata.BlogPost m ->
                        if m.published then
                            Just ( pagePath, m )

                        else
                            Nothing

                    _ ->
                        Nothing
            )
        |> List.map
            (\( pagePath, metadata ) ->
                { url =
                    relativePagePath
                        { from = currentPagePath
                        , to = pagePath
                        }
                , label =
                    Element.text metadata.title
                , title =
                    metadata.title
                }
                    |> Kit.link
            )
        |> Element.column
            [ Element.padding (Kit.scales.spacing 10)
            , Element.spacing (Kit.scales.spacing 3)
            ]
