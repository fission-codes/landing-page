const path = require("path");
const { JSDOM } = require("jsdom");

let config = {}

// Pull the page url front matter in from the data-page-url attribute and
// use it to build a relative image path based on the src attribute
const generateRelativePath = (img) => {
  const ASSETS_PATH = "assets/images";
  const SRC_ATTR = "src";
  const PAGE_URL_ATTR = "data-page-url";

  const imgPath = img.getAttribute(SRC_ATTR);
  const pageUrl = img.getAttribute(PAGE_URL_ATTR);

  // Create relative paths for images in assets/images
  if (pageUrl && imgPath.includes(ASSETS_PATH)) {
    const relativePath = path.relative(pageUrl, imgPath);
    img.setAttribute(SRC_ATTR, relativePath);
    if (config.verbose) {
      console.log(
        `relative-local-images: src updated to ${relativePath}`
      );
    }
  }

  return img;
};

// Iterate over the img tags and create relative paths for the external images
// that have been saved to the assets/images directory
const addRelativeImagePaths = (rawContent, outputPath) => {
  const selector = "img";
  let content = rawContent;

  if (outputPath && outputPath.endsWith(".html")) {
    const dom = new JSDOM(content);
    const images = [...dom.window.document.querySelectorAll(selector)];

    if (images.length > 0) {
      images.map((i) => generateRelativePath(i));
      content = dom.serialize();
    }
  }

  return content;
};

module.exports = {
  initArguments: {},
  configFunction: (eleventyConfig, pluginOptions = {}) => {
    config = pluginOptions
    eleventyConfig.addTransform("relativeLocalImages", addRelativeImagePaths);
  },
};
