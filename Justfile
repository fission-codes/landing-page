
# Variables
# ---------

bin := "./node_modules/.bin"


# Tasks
# -----

@default:
	{{bin}}/elm-pages develop

@build:
	{{bin}}/elm-pages build
