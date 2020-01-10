module View exposing (..)

import Content.Metadata as Metadata exposing (Metadata)
import Content.Parsers as Interpretation exposing (Interpretation)
import Dict.Any exposing (AnyDict)
import Element exposing (Element)
import Element.Background
import Element.Font
import Html exposing (Html)
import Html.Attributes
import Kit
import Matter.Blog.Index
import Matter.Blog.Post
import Matter.Index
import Matter.NotFound
import Pages exposing (pages)
import Pages.PagePath as Pages
import Pages.StaticHttp as StaticHttp
import Types exposing (..)



-- 🏔


pagesCatalog =
    [ ( pages.index, Matter.Index.render )
    , ( pages.blog.index, Matter.Blog.Index.render )
    ]



-- ⛩


root contentList page =
    let
        withFontStyles model interpretation =
            Element.row
                [ Element.height Element.fill
                , Element.width Element.fill
                ]
                [ Element.html fontStylesheetLink
                , renderMatter contentList page model interpretation
                ]
    in
    StaticHttp.succeed
        { head =
            Metadata.head page.frontmatter
        , view =
            \m i ->
                { title = Metadata.title page.frontmatter
                , body = Element.layout layoutAttributes (withFontStyles m i)
                }
        }



-- 🖼


renderMatter : ContentList -> Page -> Model -> Interpretation Msg -> Element Msg
renderMatter contentList page _ interpretation =
    case page.frontmatter of
        -----------------------------------------
        -- Blog Posts
        -----------------------------------------
        Metadata.BlogPost meta ->
            let
                renderedMarkdown =
                    case interpretation of
                        Interpretation.Data _ ->
                            Element.none

                        Interpretation.VirtualDom r ->
                            r
            in
            Matter.Blog.Post.render page.path meta renderedMarkdown

        -----------------------------------------
        -- Pages
        -----------------------------------------
        Metadata.Page meta ->
            let
                maybeData =
                    case interpretation of
                        Interpretation.Data d ->
                            Just d

                        Interpretation.VirtualDom _ ->
                            Nothing
            in
            case maybeData of
                Just data ->
                    -- Look up the associated Matter module in the catalog and render it.
                    -- If it's not found, render a 404 page.
                    pagesCatalogDictionary
                        |> Dict.Any.get page.path
                        |> Maybe.withDefault Matter.NotFound.render
                        |> (\renderer -> renderer contentList page.path meta data)

                Nothing ->
                    Element.none


pagesCatalogDictionary =
    Dict.Any.fromList Pages.toString pagesCatalog



-- 🎨


layoutAttributes : List (Element.Attribute Msg)
layoutAttributes =
    [ Element.Background.color Kit.colors.white
    , Element.Font.family Kit.fonts.body
    , Element.Font.size 16

    --
    , Element.htmlAttribute (Html.Attributes.style "text-rendering" "optimizelegibility")
    ]


fontStylesheetLink : Html msg
fontStylesheetLink =
    Html.node
        "link"
        [ Html.Attributes.href "https://fonts.googleapis.com/css?family=Karla:400,400i,700,700i|Work+Sans:600,700&display=swap"
        , Html.Attributes.rel "stylesheet"
        ]
        []
