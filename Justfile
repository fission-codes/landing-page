
# Variables
# ---------

node_bin := "./node_modules/.bin"


# Tasks
# -----

@default:
	yarn run dev


build:
	@rm -rf dist
	@yarn run build

	@# Gzip everything
	gzip --best --recursive --keep dist/


install-deps:
	@yarn install
	{{node_bin}}/elm-git-install
