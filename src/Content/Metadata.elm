module Content.Metadata exposing (..)

import Color
import Head
import Head.Seo as Seo
import Json.Decode as Json
import Kit
import List.Extra as List
import Pages exposing (images, pages)
import Pages.ImagePath as ImagePath exposing (ImagePath)
import Pages.Manifest as Manifest
import Pages.Manifest.Category as Manifest



-- 🧩


type alias Frontmatter =
    { title : String
    , image : ImagePath Pages.PathKey
    , imageAlt : String
    , siteName : String
    , description : String
    , summaryType : SummaryType
    }


type SummaryType
    = SummaryLarge
    | SummaryNormal



-- DECODING


frontmatterDecoder : Json.Decoder Frontmatter
frontmatterDecoder =
    -- We actually don't need to use a YAML parser here,
    -- because elm-pages translates YAML frontmatter into JSON.
    Json.map6 Frontmatter
        (Json.field "title" Json.string)
        (Json.field "image" imageDecoder)
        (Json.field "image_alt" Json.string)
        (Json.field "site_name" Json.string)
        (Json.field "description" Json.string)
        (Json.field "summary_type"
            (Json.string
                |> Json.andThen
                    (\summary ->
                        case summary of
                            "normal" ->
                                Json.succeed SummaryNormal

                            "large" ->
                                Json.succeed SummaryLarge

                            other ->
                                Json.fail ("Unrecognized summary_type: " ++ other ++ ".")
                    )
            )
        )


imageDecoder : Json.Decoder (ImagePath Pages.PathKey)
imageDecoder =
    Json.string
        |> Json.andThen
            (\imageAssetPath ->
                case findMatchingImage imageAssetPath of
                    Nothing ->
                        Json.fail "Couldn't find image. Metadata images must be included in 'images/'."

                    Just imagePath ->
                        Json.succeed imagePath
            )


findMatchingImage : String -> Maybe (ImagePath Pages.PathKey)
findMatchingImage imageAssetPath =
    Pages.allImages
        |> List.find
            (\image ->
                ImagePath.toString image
                    == imageAssetPath
            )



-- HTML & STATIC CONTENT


{-| Canonical URL for this website.
-}
canonicalSiteUrl : String
canonicalSiteUrl =
    "https://fission.codes"


{-| HTML `head` contents based on page frontmatter.
-}
head : Frontmatter -> List (Head.Tag Pages.PathKey)
head frontmatter =
    let
        summary =
            case frontmatter.summaryType of
                SummaryNormal ->
                    Seo.summary

                SummaryLarge ->
                    Seo.summaryLarge
    in
    summary
        { canonicalUrlOverride = Nothing
        , siteName = frontmatter.siteName
        , image =
            { url = frontmatter.image
            , alt = frontmatter.imageAlt
            , dimensions = ImagePath.dimensions frontmatter.image
            , mimeType = Nothing
            }
        , description = frontmatter.description
        , locale = Nothing
        , title = frontmatter.title
        }
        |> Seo.website


siteName : String
siteName =
    "Fission"


siteTagline : String
siteTagline =
    -- TODO
    "App & website hosting with user-controlled data"


{-| PWA Manifest.
-}
manifest : Manifest.Config Pages.PathKey
manifest =
    { backgroundColor = Just Color.white
    , categories = [ Manifest.utilities ]
    , displayMode = Manifest.Standalone
    , orientation = Manifest.Any
    , description = siteTagline
    , iarcRatingId = Nothing
    , name = siteName
    , themeColor = Just Kit.colors.gray_600
    , startUrl = pages.index
    , shortName = Just "Fission"
    , sourceIcon = images.logoIconColoredBordered
    }


{-| Document title.
-}
title : Frontmatter -> String
title frontmatter =
    frontmatter.title
