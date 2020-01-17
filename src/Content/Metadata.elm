module Content.Metadata exposing (..)

import Color
import Color.Transform as Color
import Date
import Head
import Head.Seo as Seo
import Json.Decode as Json
import Kit
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
    -- We actually don't need to use a YAML parser here,
    -- because elm-pages translates YAML metadata into JSON.
    Json.succeed
        (Page {})



-- HTML & STATIC CONTENT


{-| Canonical URL for this website.
-}
canonicalSiteUrl : String
canonicalSiteUrl =
    "https://fission.codes"


{-| HTML `head` contents based on page metadata.
-}
head : Metadata -> List (Head.Tag Pages.PathKey)
head metadata =
    -- TODO
    case metadata of
        BlogPost meta ->
            Seo.summaryLarge
                { canonicalUrlOverride = Nothing
                , siteName = "Fission"
                , image =
                    { url = images.icon
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
    { backgroundColor = Just Color.white
    , categories = [ Manifest.utilities ]
    , displayMode = Manifest.Standalone
    , orientation = Manifest.Any
    , description = "App & website hosting with user-controlled data" -- TODO
    , iarcRatingId = Nothing
    , name = "Fission"
    , themeColor = Just (Color.transform Kit.colors.gray_600)
    , startUrl = pages.index
    , shortName = Just "Fission"
    , sourceIcon = images.logoIconColoredBordered
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
