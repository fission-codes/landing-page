module Matter.Blog.Post exposing (render)

import Content.Metadata exposing (MetadataForBlogPosts)
import Element exposing (Element)
import Kit
import Types exposing (..)



-- 🖼


render : PagePath -> MetadataForBlogPosts -> Element Msg -> Element Msg
render pagePath meta renderedMarkdown =
    Element.el
        [ Element.width (Element.maximum 700 Element.fill)
        , Element.padding (Kit.scales.spacing 10)
        ]
        renderedMarkdown
