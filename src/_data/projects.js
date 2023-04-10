require("dotenv").config();

var Airtable = require('airtable');
const { AssetCache } = require("@11ty/eleventy-cache-assets");
var base = new Airtable({apiKey: process.env.AIRTABLE_API_KEY}).base('appZ0oSEl4e6naQCD');
const assetCacheId = "airtableCMS";

require("dotenv").config();

var Airtable = require("airtable");
var base = new Airtable({ apiKey: process.env.AIRTABLE_API_KEY }).base(
    process.env.AIRTABLE_PROJECTS_BASE
);

module.exports = function() {

    let asset = new AssetCache(assetCacheId);

    // Cache the data in 11ty for one day
    // if (asset.isCacheValid("1d")) {
    //   console.log("Serving airtable data from the cache…");
    //   return asset.getCachedValue();
    // }

    return new Promise((resolve, reject) => {
        const allCases = [];

        base("Projects")
            .select({ view: "Grid view" })
            .eachPage(
                function page(records, fetchNextPage) {
                records.forEach(record => {
                    allCases.push({
                        id: record._rawJson.id,
                        ...record._rawJson.fields
                    });
                });
                fetchNextPage();
            },
            function done(err) {
                if (err) {
                    reject(err);
                } else {
                    resolve(allCases);
                }
            }
        );
  });
};
