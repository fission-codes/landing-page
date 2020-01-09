
# Tasks
# -----

@default:
	yarn run dev

@build:
	rm -rf dist
	yarn run build
