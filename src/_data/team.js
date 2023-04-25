require("dotenv").config();
const Image = require("@11ty/eleventy-img");

const Airtable = require("airtable");
const base = new Airtable({ apiKey: process.env.AIRTABLE_API_KEY }).base(
    process.env.AIRTABLE_BASE
);
// const { AssetCache } = require("@11ty/eleventy-cache-assets");
// const assetCacheId = "airtableCMS";

const md = require('markdown-it')();

module.exports = async function() {

    // let asset = new AssetCache(assetCacheId);

    // Cache the data in 11ty for one day
    // if (asset.isCacheValid("1d")) {
    //   console.log("Serving airtable data from the cache…");
    //   return asset.getCachedValue();
    // }

    const allTeamMembers = [];

    await base("tbloh8MYmRjLgbuw7")
        .select({ 
            view: "viwbLobc6pRDfTobz",
        })
        .eachPage(
            function page(records, fetchNextPage) {
                records.forEach(record => {
                    const tempRecord = {
                        id: record._rawJson.id,
                        name: record._rawJson.fields.Name,
                        sourceAvatarURL: record._rawJson.fields.Avatar ? record._rawJson.fields.Avatar[0].url : '',
                        title: record._rawJson.fields.Title,
                        about: record._rawJson.fields.About,
                        personalWebsiteUrl: record._rawJson.fields["Personal Website"],
                        discordUsername: record._rawJson.fields["Discord Username"],
                        githubProfileUrl: record._rawJson.fields["Github Profile"],
                        twitterProfileUrl: record._rawJson.fields["Twitter Profile"],
                        mastodonProfileUrl: record._rawJson.fields["Mastodon Profile"],
                        blueskyProfileUrl: record._rawJson.fields["Bluesky Profile"],
                    }
                    allTeamMembers.push(tempRecord);
                });

                fetchNextPage();
            }
        );
    
    for (let i = 0; i < allTeamMembers.length; i++) {
        
        // cache images
        // TODO: make it so it wasn't written by a designer
        const teamMember = allTeamMembers[i];
        const resizedAvatar = await Image(teamMember.sourceAvatarURL, {
            widths: ["auto"],
            formats: ["webp"],
            outputDir: "./dist/resized-images/",
            urlPath: "/resized-images/",
            sharpOptions: {
                animated: true
            }
        });

        teamMember.avatar = resizedAvatar.webp[0];

    }

    return allTeamMembers;
};
