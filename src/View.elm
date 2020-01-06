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
import Pages exposing (pages)
import Pages.PagePath as Pages
import Pages.StaticHttp as StaticHttp
import Types exposing (..)
import View.Blog.Index
import View.Blog.Post
import View.Index
import View.NotFound
import Yaml.Decode as Yaml



-- 🍱


viewsCatalog =
    [ ( pages.index, View.Index.view )
    , ( pages.blog.index, View.Blog.Index.view )
    ]



-- 🌈


root contentList page =
    StaticHttp.succeed
        { head = Metadata.head page.frontmatter
        , view = rootView contentList page
        }


rootView : ContentList -> Page -> Model -> Interpretation Msg -> { title : String, body : Html Msg }
rootView contentList page model interpretation =
    let
        withFontStyles =
            Element.row
                [ Element.height Element.fill ]
                [ Element.html fontStylesheetLink
                , renderPage contentList page model interpretation
                ]
    in
    { title = Metadata.title page.frontmatter
    , body = Element.layout layoutAttributes withFontStyles
    }


renderPage : ContentList -> Page -> Model -> Interpretation Msg -> Element Msg
renderPage contentList page _ interpretation =
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
            View.Blog.Post.view page.path meta renderedMarkdown

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
                    viewsCatalogDictionary
                        |> Dict.Any.get page.path
                        |> Maybe.withDefault View.NotFound.view
                        |> (\view -> view contentList page.path meta data)

                Nothing ->
                    Element.none


viewsCatalogDictionary =
    Dict.Any.fromList Pages.toString viewsCatalog



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
