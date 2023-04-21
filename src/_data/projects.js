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
        const allProjects = [];

        base("tblGc9MFKGecJMvjW")
            .select({ 
                view: "viwKEVkeHMc6J2ym4",
            })
            .eachPage(
                function page(records, fetchNextPage) {
                    records.forEach(record => {
                        var tempRecord = {
                            id: record._rawJson.id,
                            name: record._rawJson.fields.Name,
                            featureImage: record._rawJson.fields["Feature Image"] ? record._rawJson.fields["Feature Image"][0] : null,
                            thumbnailImage: record._rawJson.fields["Thumbnail Image"] ? record._rawJson.fields["Thumbnail Image"][0] : null,
                            fullImage: record._rawJson.fields["Full Image"] ? record._rawJson.fields["Full Image"][0] : null,

                            relationship: record._rawJson.fields["Fission Relationship"],
                            timeHorizon: record._rawJson.fields["Time Horizon"],
                            type: record._rawJson.fields.Type,
                            topics: record._rawJson.fields.Topics,

                            summary: record._rawJson.fields["Summary"],
                            fullDescription: md.render(record._rawJson.fields["Full Description"] || ''),
                            featureSummary: md.render(record._rawJson.fields["Feature Summary"] || ''),
                            primaryCTA: {
                                label: record._rawJson.fields["Primary CTA Label"],
                                url: record._rawJson.fields["Primary CTA URL"],
                            },
                            secondaryCTAs: md.render(record._rawJson.fields["Secondary CTAs"] || ''),

                            connectionIds: record._rawJson.fields.Connections || [],
                        }
                        allProjects.push(tempRecord);
                    });

                    // attach related projects info
                    allProjects.forEach((project, index) => {
                        project.relatedProjects = [];
                        project.connectionIds.forEach( id => 
                            allProjects[index].relatedProjects.push(
                                allProjects.find(proj => proj.id === id)
                            ))
                    });

                    fetchNextPage();
                },
                function done(err) {
                    if (err) {
                        reject(err);
                    } else {
                        resolve(allProjects);
                    }
                }
            );
    });
};
