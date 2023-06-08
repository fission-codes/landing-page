# Making Changes To The Website Content

You can find a guide here on how to make or request changes to various content on the site:
https://talk.fission.codes/t/making-content-updates-to-fission-codes/4845

# Fission Eleventy Headless Ghost

The [Publish action](https://github.com/fission-suite/landing-page/actions/workflows/publish.yml) will build and publish the site to https://fission.codes for every main branch commit.

## Eleventy

Install dependencies

```bash
yarn
```

# Create .env

Get the Content API key from `Settings > Integrations > Eleventy` on the blog.

```
GHOST_API_URL=https://blog.fission.codes
GHOST_CONTENT_API_KEY=()
SITE_URL=http://localhost:8080
```

# Running

Start the development server

```bash
yarn start
```

This will grab all posts and images and the site will be running at `https://localhost:8080`
# Optimising

You can disable the default Ghost Handlebars Theme front-end by enabling the `Make this site private` flag within your Ghost settings. This enables password protection in front of the Ghost install and sets `<meta name="robots" content="noindex" />` so your Eleventy front-end becomes the source of truth for SEO.

# Extra options

```bash
# Build the site locally
yarn build
```
