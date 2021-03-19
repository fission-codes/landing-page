
// prefer default export if available
const preferDefault = m => (m && m.default) || m


exports.components = {
  "component---src-pages-404-js": preferDefault(require("/Users/agentofuser/.local/src/github.com/fission-suite/landing-page/src/pages/404.js")),
  "component---src-templates-author-js": preferDefault(require("/Users/agentofuser/.local/src/github.com/fission-suite/landing-page/src/templates/author.js")),
  "component---src-templates-index-js": preferDefault(require("/Users/agentofuser/.local/src/github.com/fission-suite/landing-page/src/templates/index.js")),
  "component---src-templates-page-js": preferDefault(require("/Users/agentofuser/.local/src/github.com/fission-suite/landing-page/src/templates/page.js")),
  "component---src-templates-post-js": preferDefault(require("/Users/agentofuser/.local/src/github.com/fission-suite/landing-page/src/templates/post.js")),
  "component---src-templates-tag-js": preferDefault(require("/Users/agentofuser/.local/src/github.com/fission-suite/landing-page/src/templates/tag.js"))
}

