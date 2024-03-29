require("dotenv").config();

const cleanCSS = require("clean-css");
const https = require("https");
const fs = require("fs");
const pluginRSS = require("@11ty/eleventy-plugin-rss");
const Image = require("@11ty/eleventy-img");
// const localImages = require("eleventy-plugin-local-images");
// const lazyImages = require("eleventy-plugin-lazyimages");
const ghostContentAPI = require("@tryghost/content-api");
const svgContents = require("eleventy-plugin-svg-contents");
const path = require("path");

const htmlMinTransform = require("./src/transforms/html-min-transform.js");
const relativeLocalImages = require("./src/plugins/relative-local-images.js");

// Init Ghost API
const api = new ghostContentAPI({
  url: process.env.GHOST_API_URL,
  key: process.env.GHOST_CONTENT_API_KEY,
  version: "v2"
});


// Strip Ghost domain from urls
const stripDomain = url => {
  return url.replace(process.env.GHOST_API_URL, "");
};

// Resize image
const imageShortcode = async (src, alt, widths, formats = ['webp']) => {
  if (alt === undefined) {
    // You bet we throw an error on missing alt (alt="" works okay)
    throw new Error(`Missing \`alt\` on myImage from: ${src}`);
  }

  let metadata = await Image(src, {
    widths: widths,
    formats: formats,
    outputDir: "./dist/resized-images/",
    urlPath: "/resized-images/",
    sharpOptions: {
      animated: true
    }
  });

  return {
    feature: {
      url: metadata[formats[0]][1] ? metadata[formats[0]][1].url : metadata[formats[0]][0].url,
      width: metadata[formats[0]][1] ? metadata[formats[0]][1].width : metadata[formats[0]][0].width,
      height: metadata[formats[0]][1] ? metadata[formats[0]][1].height : metadata[formats[0]][0].height,
    },
    thumbnail: {
      url: metadata[formats[0]][0].url,
      width: metadata[formats[0]][0].width,
      height: metadata[formats[0]][0].height,
    },
  };
}

// Download media files and save them locally
const downloadFile = async (fileName, url, dest, cb) => {
  fs.mkdir(dest, { recursive: true }, (err) => {
    if (err) throw err;
    const file = fs.createWriteStream(`${dest}/${fileName}`, { flags: 'w' });

    https.get(url, (response) => {
      response.pipe(file);

      file.on("finish", () => {
        file.close(cb);
      });
    });
  });
};

module.exports = function(config) {
  // Minify HTML
  config.addTransform("htmlmin", htmlMinTransform);

  // Assist RSS feed template
  config.addPlugin(pluginRSS);

  // Apply performance attributes to images
  // NOTE: LazyImages seems to keep re-processing and is soooo slow, so turned off
  /*
  config.addPlugin(lazyImages, {
    cacheFile: ".lazyimages.json"
  });
  */

  // // Copy images over from Ghost
  // config.addPlugin(localImages, {
  //   distPath: "dist",
  //   assetPath: "/assets/images",
  //   selector: "img",
  //   /* attribute: "data-src", // Lazy images attribute */
  //   attribute: "src", // if not using LazyImages, just grab src
  //   verbose: true,
  // });

  // Post-processor to add relative paths to localImages
  // note: this needs to be placed after the localImages plugin because
  // it relies on its modifications already having been made
  config.addPlugin(relativeLocalImages, {
    verbose: true,
  });

  // Copy static assets
  config.addPassthroughCopy("src/fonts");
  config.addPassthroughCopy("src/images");

  // Inline CSS
  config.addFilter("cssmin", (code) => {
    return new cleanCSS({}).minify(code).styles;
  });

  // Inline SVG
  config.addPlugin(svgContents);

  /*
  config.addFilter("getReadingTime", text => {
    const wordsPerMinute = 200;
    const numberOfWords = text.split(/\s/g).length;
    return Math.ceil(numberOfWords / wordsPerMinute);
  });
*/

  // Date formatting filter
  config.addFilter("htmlDateString", (dateObj) => {
    return new Date(dateObj).toISOString().split("T")[0];
  });

  // Relative path filter
  config.addNunjucksFilter("relativePath", (pathToFilter, page) => {
    if (!pathToFilter.startsWith("/")) {
      console.log(`Path is already relative: ${pathToFilter}`);
      return pathToFilter;
    }

    return path.relative(page.url, pathToFilter);
  });

  // Function to return the full year to use in the copyright
  config.addNunjucksGlobal("fullYear", () => new Date().getFullYear());

  // Function to return the last build date
  const date = new Date();
  const dateStr =
    ("00" + (date.getMonth() + 1)).slice(-2) +
    "/" +
    ("00" + date.getDate()).slice(-2) +
    "/" +
    date.getFullYear() +
    " " +
    ("00" + date.getHours()).slice(-2) +
    ":" +
    ("00" + date.getMinutes()).slice(-2) +
    ":" +
    ("00" + date.getSeconds()).slice(-2);
  config.addNunjucksGlobal("lastBuildDate", () => dateStr);

  // Don't ignore the same files ignored in the git repo
  config.setUseGitIgnore(false);

  // Custom filter to get the first N items
  config.addNunjucksFilter("limit", (arr, limit) => arr.slice(0, limit));

  // Display 404 page in BrowserSnyc
  config.setBrowserSyncConfig({
    callbacks: {
      ready: (err, bs) => {
        const content_404 = fs.readFileSync("dist/ipfs_404.html");

        bs.addMiddleware("*", (req, res) => {
          // Provides the 404 content without redirect.
          res.write(content_404);
          res.end();
        });
      },
    },
  });

  /////////////////////////////////////////////
  // COLLECTIONS
  /////////////////////////////////////////////

  // Docs
  // ====
  // Get all pages, called 'docs' to prevent
  // conflicting the eleventy page object

  config.addCollection("docs", async function (collection) {
    collection = await api.pages
      .browse({
        include: "authors",
        limit: "all",
      })
      .catch((err) => {
        console.error(err);
      });

    collection.forEach(async (doc) => {
      doc.url = stripDomain(doc.url);
      doc.primary_author.url = stripDomain(doc.primary_author.url);

      // Convert publish date into a Date object
      doc.published_at = new Date(doc.published_at);

      // Resize image and save locally
      if (doc.feature_image) {
        const { feature } = await imageShortcode(doc.feature_image, doc.title, ['auto', 800]);
        doc.feature_image = feature.url;
        doc.feature_image_width = feature.width;
        doc.feature_image_height = feature.width;
      }

      return doc;
    });

    return collection;
  });

  // Posts
  // =====

  config.addCollection("posts", async function (collection) {
    collection = await api.posts
      .browse({
        include: "tags,authors",
        limit: "all",
      })
      .catch((err) => {
        console.error(err);
      });

    collection.forEach(async (post) => {
      post.url = stripDomain(post.url);
      post.primary_author.url = stripDomain(post.primary_author.url);
      post.tags.map((tag) => (tag.url = stripDomain(tag.url)));

      // Resize feature_image for detail views and generate smaller thumbnail_image for archive views
      const { feature, thumbnail } = await imageShortcode(post.feature_image, post.title, ['auto', 800]);
      post.feature_image = feature.url;
      post.feature_image_width = feature.width;
      post.feature_image_height = feature.width;
      post.thumbnail_image = thumbnail.url;
      post.thumbnail_image_width = thumbnail.width;
      post.thumbnail_image_height = thumbnail.height;

      // Parse audio player src and save it locally
      if (post.html.includes("<audio src=")) {
        let src;
        const audioSrcs = [];
        let rex = /<audio[^>]+src="?([^"\s]+)"?\s* /g;
        while ((src = rex.exec(post.html))) {
          audioSrcs.push(src[1]);
        }

        let callback = () => console.log("audio file downloaded");
        audioSrcs.forEach((audioSrc) => {
          const urlParts = audioSrc.split("/");
          const audioFileName = urlParts[urlParts.length - 1];
          downloadFile(audioFileName, audioSrc, "dist/relativeLocalAudio", callback);

          post.html = post.html.replace(
            audioSrc,
            `../../relativeLocalAudio/${audioFileName}`
          );
        });

        // Parse inline image src and save it locally
        if (post.html.includes("<img src=")) {
          let imageSrc;
          rex = /<img[^>]+src="?([^"\s]+)"?\s*/g;
          while ((src = rex.exec(post.html))) {
            // Trim the file name to remove any extraneous query params
            imageSrc = src[1].split("?")[0];
          }
          callback = () => console.log("image file downloaded");
          const urlParts = imageSrc.split("/");
          const imageFileName = urlParts[urlParts.length - 1];
          downloadFile(
            imageFileName,
            imageSrc,
            "dist/resized-images",
            callback
          );

          post.html = post.html.replace(
            imageSrc,
            `../../resized-images/${imageFileName}`
          );
        }
      }

      // Convert publish date into a Date object
      post.published_at = new Date(post.published_at);

      // Append discourse comments to `.html` of post
      post.html = `${post.html}<div id='discourse-comments' class='discourse-comments'></div>
        <script type="text/javascript">
          DiscourseEmbed = { discourseUrl: 'https://talk.fission.codes/',
                            discourseEmbedUrl: 'https://fission.codes/blog/${post.slug}/' };

          (function() {
            var d = document.createElement('script'); d.type = 'text/javascript'; d.async = true;
            d.src = DiscourseEmbed.discourseUrl + 'javascripts/embed.js';
            (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(d);
          })();
        </script>`;
    });

    // Bring featured post to the top of the list
    collection.sort((post, nextPost) => nextPost.featured - post.featured);

    return collection;
  });

  // Podcasts
  // =====

  config.addCollection("podcasts", async function (collection) {
    collection = await api.posts
      .browse({
        include: "tags,authors",
        limit: "all",
        filter: "tag:causal-islands-podcast",
      })
      .catch((err) => {
        console.error(err);
      });

    collection.forEach(async (post) => {
      post.url = stripDomain(post.url);
      post.primary_author.url = stripDomain(post.primary_author.url);
      post.tags.map((tag) => (tag.url = stripDomain(tag.url)));

      // Resize feature_image for detail views and generate smaller thumbnail_image for archive views
      const { feature, thumbnail } = await imageShortcode(post.feature_image, post.title, ['auto', 800], ['png']);
      post.feature_image = feature.url;
      post.feature_image_width = feature.width;
      post.feature_image_height = feature.width;
      post.thumbnail_image = thumbnail.url;
      post.thumbnail_image_width = thumbnail.width;
      post.thumbnail_image_height = thumbnail.height;

      // Parse audio player src and save it locally
      if (post.html.includes("<audio src=")) {
        let src;
        const audioSrcs = [];
        const rex = /<audio[^>]+src="?([^"\s]+)"?\s*/g;
        while ((src = rex.exec(post.html))) {
          audioSrcs.push(src[1]);
        }

        const callback = () => console.log('audio file downloaded')
        audioSrcs.forEach(audioSrc => {
          const urlParts = audioSrc.split('/')
          const fileName = urlParts[urlParts.length - 1]
          downloadFile(fileName, audioSrc, "dist/relativeLocalAudio", callback);

          post.html = post.html.replace(audioSrc, `../../relativeLocalAudio/${fileName}`);
          post.audioFile = `/relativeLocalAudio/${fileName}`;
        })
      }

      // Convert publish date into a Date object
      post.published_at = new Date(post.published_at);

      // Append discourse comments to `.html` of post
      post.html = `${post.html}<div id='discourse-comments' class='discourse-comments'></div>
        <script type="text/javascript">
          DiscourseEmbed = { discourseUrl: 'https://talk.fission.codes/',
                            discourseEmbedUrl: 'https://fission.codes/blog/${post.slug}/' };

          (function() {
            var d = document.createElement('script'); d.type = 'text/javascript'; d.async = true;
            d.src = DiscourseEmbed.discourseUrl + 'javascripts/embed.js';
            (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(d);
          })();
        </script>`;
    });

    // Bring featured post to the top of the list
    collection.sort((post, nextPost) => nextPost.featured - post.featured);

    return collection;
  });

  // Authors
  // =======

  config.addCollection("authors", async function (collection) {
    collection = await api.authors
      .browse({
        limit: "all",
      })
      .catch((err) => {
        console.error(err);
      });

    // Get all posts with their authors attached
    const posts = await api.posts
      .browse({
        include: "authors",
        limit: "all",
      })
      .catch((err) => {
        console.error(err);
      });

    // Attach posts to their respective authors
    collection.forEach(async (author) => {
      const authorsPosts = posts.filter((post) => {
        post.url = stripDomain(post.url);
        return post.primary_author.id === author.id;
      });
      if (authorsPosts.length) author.posts = authorsPosts;

      author.url = stripDomain(author.url);
    });

    return collection;
  });

  // Tags
  // ====

  config.addCollection("tags", async function (collection) {
    collection = await api.tags
      .browse({
        include: "count.posts",
        limit: "all",
      })
      .catch((err) => {
        console.error(err);
      });

    // Get all posts with their tags attached
    const posts = await api.posts
      .browse({
        include: "tags,authors",
        limit: "all",
      })
      .catch((err) => {
        console.error(err);
      });

    // Attach posts to their respective tags
    collection.forEach(async (tag) => {
      const taggedPosts = posts.filter((post) => {
        post.url = stripDomain(post.url);
        return post.primary_tag && post.primary_tag.slug === tag.slug;
      });
      if (taggedPosts.length) tag.posts = taggedPosts;

      tag.url = stripDomain(tag.url);
    });

    return collection;
  });

  config.addCollection("causalIslandsTag", async function () {
    const tag = await api.tags
      .read({ slug: "causal-islands-podcast" })
      .catch((err) => {
        console.error(err);
      });

    tag.url = stripDomain(tag.url);

    // Resize feature_image and save it locally
    const { feature } = await imageShortcode(
      tag.feature_image,
      tag.name,
      ["auto", 3000],
      ['png']
    );

    tag.feature_image = feature.url;
    tag.feature_image_width = feature.width;
    tag.feature_image_height = feature.width;

    return tag;
  });

  /////////////////////////////////////////////
  // 11TY CONFIG
  /////////////////////////////////////////////

  return {
    dir: {
      input: "src",
      output: "dist",
    },

    // Files read by Eleventy, add as needed
    templateFormats: ["css", "njk", "md", "txt"],
    htmlTemplateEngine: "njk",
    markdownTemplateEngine: "njk",
    passthroughFileCopy: true,
  };
};
