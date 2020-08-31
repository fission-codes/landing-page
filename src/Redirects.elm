module Redirects exposing (generate)

import Content.Metadata as Metadata
import Pages
import Pages.PagePath as PagePath exposing (PagePath)
import Pages.StaticHttp as StaticHttp


generate :
    List { path : PagePath pathKey, frontmatter : Metadata.Frontmatter, body : String }
    ->
        StaticHttp.Request
            (List
                (Result String
                    { path : List String
                    , content : String
                    }
                )
            )
generate =
    \_ ->
        StaticHttp.succeed
            [ Ok
                { path = [ "ipfs-404.html" ]
                , content = redirectHtml ("/" ++ PagePath.toString Pages.pages.ipfs404)
                }
            ]


redirectHtml : String -> String
redirectHtml url =
    """<!DOCTYPE HTML>
<html lang="en-US">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="refresh" content="0; url=http://example.com">
        <script type="text/javascript">
            window.location.href = "http://example.com"
        </script>
        <title>Page Redirection</title>
    </head>
    <body>
        <!-- Note: don't tell people to `click` the link, just tell them that it is a link. -->
        If you are not redirected automatically, follow this <a href='http://example.com'>link to example</a>.
    </body>
</html>"""
        |> String.replace "http://example.com" url
