module Content.Metadata exposing (..)

import Color
import Head
import Json.Decode as Json
import Kit
import Pages exposing (images, pages)
import Pages.Manifest as Manifest
import Pages.Manifest.Category as Manifest



-- 🧩


type alias Metadata =
    {}



-- DECODING


metadataDecoder =
    -- We actually don't need to use a YAML parser here,
    -- because elm-pages translates YAML metadata into JSON.
    Json.succeed {}



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
    , themeColor = Just Kit.colors.gray_600
    , startUrl = pages.index
    , shortName = Just "Fission"
    , sourceIcon = images.logoIconColoredBordered
    }


{-| Document title.
-}
title : Metadata -> String
title metadata =
    "Fission"
