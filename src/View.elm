module View exposing (..)

import Common
import Content.Metadata as Metadata exposing (Metadata)
import Content.Parsers as Interpretation exposing (Interpretation)
import Dict.Any exposing (AnyDict)
import Element exposing (Element)
import Element.Background
import Element.Font
import External.Blog
import Html exposing (Html)
import Html.Attributes
import Json.Decode.Exploration as StrictJson
import Kit
import Matter.Index
import Matter.NotFound
import Matter.Support
import Pages exposing (pages)
import Pages.PagePath as Pages
import Pages.Secrets as Secrets
import Pages.StaticHttp as StaticHttp
import Types exposing (..)



-- 🏔


pagesCatalog =
    [ ( pages.index, Matter.Index.render )
    , ( pages.support, Matter.Support.render )
    ]



-- ⛩


root contentList page =
    let
        withStyles interpretation model =
            Element.row
                [ Element.height Element.fill
                , Element.width Element.fill
                , Element.Font.color Kit.colors.gray_100
                ]
                [ Element.html fontStylesheetLink
                , Element.html mediaQueries
                , Element.html temporaryElmUiSafariCssFix
                , renderMatter contentList page model interpretation
                ]
    in
    -- External.Blog.latestPostsDecoder
    --     |> StaticHttp.get
    --         (Secrets.succeed External.Blog.feedUrl)
    []
        |> StaticHttp.succeed
        |> StaticHttp.map
            (\latestBlogPosts ->
                { head =
                    Metadata.head page.frontmatter
                , view =
                    \m i ->
                        { m | latestBlogPosts = latestBlogPosts }
                            |> withStyles i
                            |> Element.layout layoutAttributes
                            |> (\body ->
                                    { title = Metadata.title page.frontmatter
                                    , body = body
                                    }
                               )
                }
            )



-- 🖼


renderMatter : ContentList -> Page -> Model -> Interpretation Msg -> Element Msg
renderMatter contentList page model interpretation =
    case page.frontmatter of
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
                        |> (\renderer -> renderer contentList page.path meta data model)

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
        [ Html.Attributes.href "https://fonts.googleapis.com/css?family=Karla:400,400i,700,700i|Work+Sans:500,600,700&display=swap"
        , Html.Attributes.rel "stylesheet"
        ]
        []


mediaQueries : Html msg
mediaQueries =
    Html.node
        "style"
        [ Html.Attributes.type_ "text/css" ]
        [ Html.text """
            /* Small */
            @media (min-width: 640px) { [hide-gte-sm] { display: none !important }}
            @media (max-width: 639px) { [hide-lt-sm] { display: none !important }}

            /* Large */
            @media (min-width: 768px) { [hide-gte-md] { display: none !important }}
            @media (max-width: 767px) { [hide-lt-md] { display: none !important }}

            /* Large */
            @media (min-width: 1024px) { [hide-gte-lg] { display: none !important }}
            @media (max-width: 1023px) { [hide-lt-lg] { display: none !important }}

            /* Large */
            @media (min-width: 1280px) { [hide-gte-xl] { display: none !important }}
            @media (max-width: 1279px) { [hide-lt-xl] { display: none !important }}
          """
        ]


{-| Fixes Safari CSS issue with elm-ui.
See <https://github.com/mdgriffith/elm-ui/issues/152> for more info.
-}
temporaryElmUiSafariCssFix : Html Msg
temporaryElmUiSafariCssFix =
    Html.node "style" [] [ Html.text ".s.c > .s { flex-basis: auto; flex-shrink: 0; }" ]
