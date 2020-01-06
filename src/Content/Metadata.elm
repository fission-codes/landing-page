module Content.Metadata exposing (..)

import Color
import Date
import Head
import Head.Seo as Seo
import Json.Decode as Json
import Pages exposing (images, pages)
import Pages.Manifest as Manifest
import Pages.Manifest.Category as Manifest



-- 🧩


type Metadata
    = BlogPost MetadataForBlogPosts
    | Page MetadataForPages


type alias MetadataForBlogPosts =
    { date : String
    , published : Bool
    , title : String
    }


type alias MetadataForPages =
    {}



-- DECODING


markdownMetadataDecoder =
    Json.map BlogPost <|
        Json.map3
            MetadataForBlogPosts
            (Json.field "date" Json.string)
            (Json.field "published" Json.bool)
            (Json.field "title" Json.string)


yamlMetadataDecoder =
    Json.succeed
        (Page {})



-- HTML & STATIC CONTENT


{-| Canonical URL for this website.
-}
canonicalSiteUrl : String
canonicalSiteUrl =
    "TODO"


{-| HTML `head` contents based on page metadata.
-}
head : Metadata -> List (Head.Tag Pages.PathKey)
head metadata =
    -- TODO
    case metadata of
        BlogPost meta ->
            Seo.summaryLarge
                { canonicalUrlOverride = Nothing
                , siteName = "FISSION"
                , image =
                    { url = images.favicon
                    , alt = meta.title
                    , dimensions = Nothing
                    , mimeType = Nothing
                    }
                , description = meta.title
                , locale = Nothing
                , title = meta.title
                }
                |> Seo.article
                    { tags = []
                    , section = Nothing
                    , publishedTime = Just meta.date
                    , modifiedTime = Nothing
                    , expirationTime = Nothing
                    }

        Page _ ->
            []


{-| PWA Manifest.
-}
manifest : Manifest.Config Pages.PathKey
manifest =
    -- TODO
    { backgroundColor = Just Color.white
    , categories = [ Manifest.education ]
    , displayMode = Manifest.Standalone
    , orientation = Manifest.Portrait
    , description = "elm-pages-starter - A statically typed site generator."
    , iarcRatingId = Nothing
    , name = "FISSION"
    , themeColor = Just Color.white
    , startUrl = pages.index
    , shortName = Just "elm-pages-starter"
    , sourceIcon = images.favicon
    }


{-| Document title.
-}
title : Metadata -> String
title metadata =
    case metadata of
        BlogPost m ->
            m.title ++ " — FISSION"

        Page _ ->
            "FISSION"
