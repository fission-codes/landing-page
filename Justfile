
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

	@# Replace 'href="/' and 'src="/' with the correct prefix
	@# based on where you are in the directory structure.
	just fix-absolute-paths

	@# Gzip everything
	gzip --best --recursive --keep dist/


fix-absolute-paths:
	#!/usr/bin/env node
	const fs = require( "fs" )
	const glob = require( "{{invocation_directory()}}/node_modules/glob/glob.js" )

	glob("**/*.html", { cwd: "dist" }, (err, paths) => {
		if (err) return console.error(err)

		paths.forEach(path => {
			const prefix = path.split("/").slice(0, -1).map(_ => "..").join("/")
			const sep = prefix === "" ? "" : "/"
			const html = fs.readFileSync(`dist/${path}`, { encoding: "utf-8" })
			const fixedHtml = html
				.replace(/href=\"\/(\w)/g, `href="${prefix}${sep}$1`)
				.replace(/src=\"\/(\w)/g, `src="${prefix}${sep}$1`)
				.replace(/\.register\(\"\/(\w)/g, `.register("${prefix}${sep}$1`)

			fs.writeFileSync(`dist/${path}`, fixedHtml)
		})
	})


install-deps:
	@yarn install
	{{node_bin}}/elm-git-install
