const plugin = require("tailwindcss/plugin")
const kit = require("@fission-suite/kit")


module.exports = {
  mode: "jit",
  darkMode: "media",

  purge: ["./src/**/*.{html,md,njk}", ...kit.tailwindPurgeList()],

  theme: {
    fontFamily: kit.fonts,

    extend: {
      backgroundImage: {
        "hero-bg-dark":
          "linear-gradient(134.46deg, rgba(255, 82, 116, 0.1) 0%, rgba(100, 70, 250, 0.1) 100%)",
        "hero-bg-light":
          "linear-gradient(134.46deg, rgba(255, 82, 116, 0.15) 0%, rgba(100, 70, 250, 0.15) 100%)",
        "text-bg-dark": "linear-gradient(92.57deg, #FF5274 0%, #6446FA 99.99%)",
        "discord-bg-dark":
          "linear-gradient(134.46deg, rgba(255, 82, 116, 0.4) 0%, rgba(100, 70, 250, 0.4) 100%)",
        "discord-bg-light":
          "linear-gradient(92.57deg, #FF5274 0%, #6446FA 99.99%)",
      },
      colors: {
        ...kit.dasherizeObjectKeys(kit.colors),
        "dark-body-bg": "#101632",

        "blue-dark": "#1E2347",

        "gray-dark": "#A3A3BE",
        "gray-light": "#CBCBDE",
        "gray-lighest": "#ECECF5",
        "gray-white": "#F5F5FA",

        neutral: "#101632",

        pink: "#FF4A70",
        "pink-light": "#FF7390",

        purple: "#6144F3",
        "purple-dark": "#281566",
        "purple-light": "#5133D3",
        "purple-lightest": "#E0DEFF",

        yellow: "#FFB238",
      },
    },
  },

  plugins: [
    plugin(function ({ addBase }) {
      // this `fontsPath` will be the relative path
      // to the fonts from the generated stylesheet
      kit.fontFaces({ fontsPath: "./fonts/" }).forEach((fontFace) => {
        addBase({ "@font-face": fontFace });
      });
    }),
  ],
};
