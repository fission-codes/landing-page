const plugin = require("tailwindcss/plugin")
const kit = require("@fission-suite/kit")


module.exports = {
  mode: "jit",
  darkMode: "media",

  purge: [
    "./src/**/*.{html,md,njk}",
    ...kit.tailwindPurgeList()
  ],

  theme: {
    fontFamily: kit.fonts,

    extend: {
      colors: kit.dasherizeObjectKeys(kit.colors),
    }
  },

  plugins: [
    plugin(function({ addBase }) {
      // this `fontsPath` will be the relative path
      // to the fonts from the generated stylesheet
      kit.fontFaces({ fontsPath: "/fonts/" }).forEach(fontFace => {
        addBase({ "@font-face": fontFace })
      })
    })
  ]
}
