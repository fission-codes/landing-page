require("dotenv").config();
const Image = require("@11ty/eleventy-img");

var Airtable = require("airtable");
var base = new Airtable({ apiKey: process.env.AIRTABLE_API_KEY }).base(
    process.env.AIRTABLE_BASE
);
// const { AssetCache } = require("@11ty/eleventy-cache-assets");
// const assetCacheId = "airtableCMS";

var md = require('markdown-it')();

module.exports = async function() {

    const allProjects = [];

    await base("tblGc9MFKGecJMvjW")
        .select({ 
            view: "viwKEVkeHMc6J2ym4",
        })
        .eachPage(
            function page(records, fetchNextPage) {
                records.forEach(record => {
                    var tempRecord = {
                        id: record._rawJson.id,
                        name: record._rawJson.fields.Name,
                        sourceImageURL: record._rawJson.fields.Image ? record._rawJson.fields.Image[0].url : null,

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

                fetchNextPage();

        });

    for (let i = 0; i < allProjects.length; i++) {
        const project = allProjects[i];
        
        // cache images
        // TODO: make it so it wasn't written by a designer
        const imageSettings = {
            widths: ["400", null],
            formats: ["webp","svg"],
            svgShortCircuit: true,
            outputDir: "./dist/resized-images/",
            urlPath: "/resized-images/",
            sharpOptions: {
                animated: true
            }
        };

        let resizedImages = await Image(project.sourceImageURL, imageSettings);

        project.featureImage = resizedImages.svg.length > 0 ? resizedImages.svg[0] : resizedImages.webp[1];
        project.thumbnailImage = resizedImages.svg.length > 0 ? resizedImages.svg[0] : resizedImages.webp[0];

        // attach related projects info
        project.relatedProjects = [];

        for (const id of project.connectionIds) {
            const relatedProject = allProjects.find(proj => proj.id === id);
            // Use await here for asynchronous operations, if needed.
            // Example: const someData = await fetchSomeData(relatedProject);
            project.relatedProjects.push(relatedProject);
        }
    }
    
    return allProjects;

};
