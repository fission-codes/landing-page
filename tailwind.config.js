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
        neutral: {
          50: "#F5F5FA",
          100: "#ECECF5",
          200: "#E1E2EF",
          300: "#CBCBDE",
          400: "#A3A3BE",
          500: "#696A8B",
          600: "#3E4268",
          700: "#1E2347",
          800: "#101632",
          900: "#0A1024",
        },
        yellow: {
          50: "#FEFCE8",
          100: "#FFE8A4",
          200: "#FFC967",
          300: "#FFB238",
          400: "#EB971B",
          500: "#CC7B0B",
          600: "#A96103",
          700: "#7B4401",
          800: "#5E3403",
          900: "#4A2A07",
        },
        /* 
          Named `newpurple` and `newpink` to avoid breaking Fission Kit imports 
          TODO: these color definitions should be updated in Fission Kit,
          and then updated throughout templates that depend on them.

          For color migration guide, see the Fission Kit figma:
          https://www.figma.com/file/Np45Vc6bM943XFdXIeEGFJ/Fission-Kit?node-id=500%3A1624
        */
        newpurple: {
          50: "#E0DEFF",
          100: "#B1ABFF",
          200: "#9287FF",
          300: "#7967FF",
          400: "#6144F3",
          500: "#6950FF",
          600: "#5133D3",
          700: "#3C229B",
          800: "#281566",
          900: "#160A38",
        },
        newpink: {
          50: "#FFDAE1",
          100: "#FFA2B5",
          200: "#FF7390",
          300: "#FF4A70",
          400: "#E9254F",
          500: "#CC1139",
          600: "#A20827",
          700: "#74051C",
          800: "#4C0514",
          900: "#340612",
        },
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
