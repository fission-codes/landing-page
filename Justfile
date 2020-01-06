
# Variables
# ---------

bin := "./node_modules/.bin"


# Tasks
# -----

@default:
	{{bin}}/elm-pages develop

@build:
	rm -rf .cache
	rm -rf dist
	{{bin}}/elm-pages build
