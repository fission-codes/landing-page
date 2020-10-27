module View exposing (..)

import Content.Metadata as Metadata
import Content.Parsers as Interpretation exposing (Interpretation)
import Dict.Any
import External.Blog
import Head
import Html exposing (Html)
import Html.Extra as Html
import Matter.Artwork
import Matter.Index
import Matter.Ipfs404
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
    , ( pages.artwork, Matter.Artwork.render )
    , ( pages.ipfs404, Matter.Ipfs404.render )
    ]



-- ⛩


root :
    ContentList
    -> Page
    ->
        StaticHttp.Request
            { view :
                Model
                -> Interpretation Msg
                ->
                    { title : String
                    , body : Html Msg
                    }
            , head : List (Head.Tag Pages.PathKey)
            }
root contentList page =
    let
        view latestBlogPosts model interpretation =
            { title = Metadata.title page.frontmatter
            , body =
                renderMatter
                    contentList
                    page
                    { model | latestBlogPosts = latestBlogPosts }
                    interpretation
            }
    in
    External.Blog.latestPostsDecoder
        |> StaticHttp.get (Secrets.succeed External.Blog.feedUrl)
        |> StaticHttp.map
            (\latestBlogPosts ->
                { head = Metadata.head page.frontmatter
                , view = view latestBlogPosts
                }
            )



-- 🖼


renderMatter : ContentList -> Page -> Model -> Interpretation Msg -> Html Msg
renderMatter contentList page model interpretation =
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
                |> (\renderer -> renderer contentList page.path page.frontmatter data model)

        Nothing ->
            Html.nothing


pagesCatalogDictionary =
    Dict.Any.fromList Pages.toString pagesCatalog
