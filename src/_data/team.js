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
                            ...record._rawJson.fields,
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
