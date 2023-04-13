require("dotenv").config();

var Airtable = require("airtable");
var base = new Airtable({ apiKey: process.env.AIRTABLE_API_KEY }).base(
    process.env.AIRTABLE_BASE
);
// const { AssetCache } = require("@11ty/eleventy-cache-assets");
// const assetCacheId = "airtableCMS";

var md = require('markdown-it')();

module.exports = function() {

    // let asset = new AssetCache(assetCacheId);

    // Cache the data in 11ty for one day
    // if (asset.isCacheValid("1d")) {
    //   console.log("Serving airtable data from the cache…");
    //   return asset.getCachedValue();
    // }

    return new Promise((resolve, reject) => {
        const allTeamMembers = [];

        base("tbloh8MYmRjLgbuw7")
            .select({ 
                view: "viwbLobc6pRDfTobz",
            })
            .eachPage(
                function page(records, fetchNextPage) {
                    console.log("# of members", records.length);
                    records.forEach(record => {
                        var tempRecord = {
                            id: record._rawJson.id,
                            name: record._rawJson.fields.Name,
                            avatar: record._rawJson.fields.Avatar ? record._rawJson.fields.Avatar[0] : null,
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
                },
                function done(err) {
                    if (err) {
                        reject(err);
                    } else {
                        resolve(allTeamMembers);
                    }
                }
            );
    });
};
