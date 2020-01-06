const { Elm } = require("./src/Main.elm")
const initializePages = require("elm-pages")

initializePages({
  mainElmModule: Elm.Main
})
