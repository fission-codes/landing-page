module View.Blog.Post exposing (view)

import Content.Metadata exposing (MetadataForBlogPosts)
import Element exposing (Element)
import Kit
import Types exposing (..)



-- 🌈


view : PagePath -> MetadataForBlogPosts -> Element Msg -> Element Msg
view pagePath meta renderedMarkdown =
    Element.el
        [ Element.width (Element.maximum 700 Element.fill)
        , Element.padding (Kit.scales.spacing 10)
        ]
        renderedMarkdown
