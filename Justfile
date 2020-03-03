export NODE_OPTIONS := "--no-warnings"


# Variables
# ---------

node_bin := "./node_modules/.bin"



# Tasks
# -----

@default: css-large
	just watch-css & yarn run dev


build:
	@rm -rf dist
	@yarn run build

	@# Gzip everything
	gzip --best --recursive --keep dist/

	@# Css
	@rm dist/application.css
	@just css-small
	@cp static/application.css dist/application.css


install-deps:
	@yarn install
	{{node_bin}}/elm-git-install


@watch-css:
	echo "👀  Watching CSS"
	watchexec -p -w css -e "css,js" -- just css-large



# Parts
# -----

@css-large:
	echo "⚙️  Compiling CSS & Elm Tailwind Module"
	node ./css/Build.js


@css-small:
	echo "⚙️  Compiling Minified CSS"
	NODE_ENV=production node ./css/Build.js
