module Content.Markdown exposing (process)

import Element exposing (Element)
import Element.Extra as Element
import Element.Font as Font
import Html
import Kit
import Markdown.Block as Block
import Markdown.Config as Markdown
import Markdown.Inline as Inline



-- 🛠


process : String -> List (Element msg)
process markdown =
    markdown
        |> Block.parse
            (Just
                { softAsHardLineBreak =
                    False
                , rawHtml =
                    Markdown.Sanitize
                        { allowedHtmlElements =
                            "abbr" :: defaultAllowedHtmlElements
                        , allowedHtmlAttributes =
                            "title" :: defaultAllowedHtmlAttributes
                        }
                }
            )
        |> List.map renderBlock
        |> List.concat



-- ㊙️


renderBlock : Block.Block b i -> List (Element msg)
renderBlock block =
    case block of
        Block.BlankLine _ ->
            []

        Block.BlockQuote blocks ->
            blocks
                |> List.map renderBlock
                |> List.concat
                |> Kit.blockquote
                |> List.singleton

        Block.CodeBlock (Block.Fenced _ model) codeStr ->
            [ Kit.codeBlock
                { body = codeStr
                , language = model.language
                }
            ]

        Block.CodeBlock Block.Indented codeStr ->
            [ Kit.codeBlock
                { body = codeStr
                , language = Nothing
                }
            ]

        Block.Heading _ level inlines ->
            [ Kit.heading
                { level = level }
                (List.map renderInline inlines)
            ]

        Block.List { type_ } items ->
            items
                |> List.map (List.map renderBlock >> List.concat)
                |> (case type_ of
                        Block.Ordered startIndex ->
                            Kit.orderedList startIndex

                        Block.Unordered ->
                            Kit.unorderedList
                   )
                |> List.singleton

        Block.Paragraph _ inlines ->
            inlines
                |> List.map renderInline
                |> Kit.paragraph
                |> List.singleton

        Block.PlainInlines inlines ->
            List.map renderInline inlines

        Block.ThematicBreak ->
            [ Kit.horizontalRule ]

        -----------------------------------------
        -- Custom
        -----------------------------------------
        Block.Custom customBlock blocks ->
            blocks
                |> List.map renderBlock
                |> List.concat


renderInline : Inline.Inline i -> Element msg
renderInline inline =
    case inline of
        Inline.CodeInline codeStr ->
            Kit.inlineCode codeStr

        Inline.Emphasis length inlines ->
            inlines
                |> concatInline
                |> renderInline
                |> (case length of
                        1 ->
                            Element.el [ Font.italic ]

                        _ ->
                            Element.el [ Font.bold ]
                   )

        Inline.HardLineBreak ->
            Element.html (Html.br [] [])

        Inline.HtmlInline tag attrs inlines ->
            inlines
                |> Inline.HtmlInline tag attrs
                |> Inline.toHtml
                |> Element.html

        Inline.Image src maybeTitle inlines ->
            Element.image
                [ Element.width Element.fill ]
                { description = Maybe.withDefault "" maybeTitle
                , src = src
                }

        Inline.Link url maybeTitle inlines ->
            Kit.link
                { label =
                    inlines
                        |> concatInline
                        |> renderInline
                , title =
                    Maybe.withDefault "" maybeTitle
                , url =
                    url
                }

        Inline.Text text ->
            Element.text text

        -----------------------------------------
        -- Custom
        -----------------------------------------
        Inline.Custom _ inlines ->
            -- NOTE: Not sure what this is about.
            --       Default HTML renderer doesn't seem to use it either.
            Element.none


concatInline : List (Inline.Inline i) -> Inline.Inline i
concatInline =
    -- NOTE: This should probably concat text or something.
    List.head >> Maybe.withDefault (Inline.Text "")


defaultAllowedHtmlElements =
    Markdown.defaultSanitizeOptions.allowedHtmlElements


defaultAllowedHtmlAttributes =
    Markdown.defaultSanitizeOptions.allowedHtmlAttributes
