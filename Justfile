
# Variables
# ---------

node_bin := "./node_modules/.bin"


# Tasks
# -----

@default:
	yarn run dev

@build:
	rm -rf dist
	yarn run build

install-deps:
	@yarn install
	{{node_bin}}/elm-git-install
