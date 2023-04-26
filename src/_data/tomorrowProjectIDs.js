require("dotenv").config();

const Airtable = require("airtable");
const base = new Airtable({ apiKey: process.env.AIRTABLE_API_KEY }).base(
    process.env.AIRTABLE_BASE
);

module.exports = function() {
    return new Promise((resolve, reject) => {
        const projectIDs = [];    

        base("tblGc9MFKGecJMvjW")
            .select({ 
                view: "viwTykDNBRvolzyhY",
                fields: [],
            })
            .firstPage(function(err, records) {
                if (err) { reject(err) }
                records.forEach(function(record) {
                    projectIDs.push(record._rawJson.id);
                });
                resolve(projectIDs)
            });
    });
};
