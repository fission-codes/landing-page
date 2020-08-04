# FISSION Landing Page

## Setup

Prerequisites:
- [`brew install just`](https://github.com/casey/just)
- [`brew install pnpm`](https://pnpm.js.org)
- [`brew install watchexec`](https://github.com/watchexec/watchexec)

Uses `elm-git` for install, so you'll need to have your [SSH key setup for Github](https://help.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh).

## How to use

```shell
# 🍱
just install-deps

# Build, watch & start server
just


# Build for production and put in `dist` folder
just build-production
```
