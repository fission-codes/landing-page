require("dotenv").config();

const ghostContentAPI = require("@tryghost/content-api");

// Init Ghost API
const api = new ghostContentAPI({
  url: process.env.GHOST_API_URL,
  key: process.env.GHOST_CONTENT_API_KEY,
  version: "v2"
});

// Get all site information
module.exports = async function() {
  const siteData = await api.settings
    .browse({
      include: "icon,url"
    })
    .catch(err => {
      console.error(err);
    });

  siteData.subtitle = "We construct identity, data, and compute solutions for the future of the Internet";
  siteData.description = "Fission makes local-first methods a reality, starting at the protocols. We ship tools you can use today, and invent tech that will power tomorrow. Join us in creating a more compassionate and connected world of software."

  if (process.env.SITE_URL) siteData.url = process.env.SITE_URL;

  return siteData;
};
