require("dotenv").config();

var Airtable = require("airtable");
var base = new Airtable({ apiKey: process.env.AIRTABLE_API_KEY }).base(
    process.env.AIRTABLE_PROJECTS_BASE
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
        const allCases = [];

        base("Projects")
            .select({ 
                view: "Grid view",
            })
            .eachPage(
                function page(records, fetchNextPage) {
                records.forEach(record => {
                    // console.log(record);
                    var tempRecord = {
                        id: record._rawJson.id,
                        name: record._rawJson.fields.Name,
                        type: record._rawJson.fields.Type,
                        shortDesc: record._rawJson.fields["Short Description"],
                        // ...record._rawJson.fields,
                        longDesc: md.render(record._rawJson.fields["Long Description"] || ''),
                    }
                    // console.log(md.render(record._rawJson.fields["Long Description"] || ''));
                    allCases.push(tempRecord);
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
