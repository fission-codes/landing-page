const plugin = require("tailwindcss/plugin");
const kit = require("@fission-suite/kit");

module.exports = {
  mode: "jit",
  darkMode: "media",
  purge: ["./src/**/*.{html,md,njk}", ...kit.tailwindPurgeList()],
  theme: {
    fontFamily: kit.fonts,

    extend: {
      backgroundImage: {
        "hero-dark":
          "linear-gradient(358.98deg, rgba(100, 70, 250, 0) 10.03%, rgba(100, 70, 250, 0.2) 99.18%);",
        "hero-light":
          "linear-gradient(358.98deg, rgba(100, 70, 250, 0) 10.03%, rgba(100, 70, 250, 0.2) 99.18%)",
        "text-bg-dark": "linear-gradient(92.57deg, #FF5274 0%, #6446FA 99.99%)",
        "newsletter-dark":
          "linear-gradient(134.46deg, rgba(255, 82, 116, 0.4) 0%, rgba(100, 70, 250, 0.4) 100%)",
        "newsletter-light":
          "linear-gradient(92.57deg, #FF5274 0%, #6446FA 99.99%)",
        "overlay-menu":
          "linear-gradient(358.98deg, rgba(255, 82, 116, 0) 10.03%, rgba(100, 70, 250, 0.2) 99.18%)",
      },
      colors: {
        ...kit.dasherizeObjectKeys(kit.colors),
        neutral: {
          0: "#FBFBFC",
          50: "#F5F5F9",
          100: "#EEEEF5",
          200: "#E3E3EF",
          300: "#CBCCDE",
          400: "#A3A3BE",
          500: "#696A8B",
          600: "#3F4161",
          700: "#1F223D",
          800: "#0E1225",
          900: "#070B16",
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
          500: "#6446FA",
          600: "#5133D3",
          700: "#3C2399",
          800: "#26155E",
          900: "#160A38",
        },
        newpink: {
          50: "#FFDAE1",
          100: "#FFA4B5",
          200: "#FF7390",
          300: "#FF5274",
          400: "#E9254F",
          500: "#CC1139",
          600: "#A20827",
          700: "#74051C",
          800: "#4C0514",
          900: "#340612",
        },
      },
      fontFamily: {
        display: ["PPFragment"],
        sans: ["UncutSans"],
      },
      fontSize: {
        "body-xs": ["12px", { lineHeight: "17px" }],
        "body-sm": ["15px", { lineHeight: "20px" }],
        "body-base": ["18px", { lineHeight: "23px" }],
        "body-lg": ["22px", { lineHeight: "29px" }],
        "body-xl": ["26px", { lineHeight: "34px" }],
        "body-2xl": ["31px", { lineHeight: "40px" }],
        xs: ["13px", { lineHeight: "15px" }],
        sm: ["16px", { lineHeight: "24px" }],
        base: ["18px", { lineHeight: "21px" }],
        lg: ["24px", { lineHeight: "30px" }],
        xl: ["32px", { lineHeight: "38px" }],
        "2xl": ["43px", { lineHeight: "52px" }],
        "3xl": ["57px", { lineHeight: "69px" }],
      },
      maxWidth: {
        "3xl": "775px",
        "5xl": "936px",
      },
      zIndex: {
        max: "1000",
      },
    },
  },
  plugins: [
    require("daisyui"),
    plugin(function ({ addBase }) {
      // this `fontsPath` will be the relative path
      // to the fonts from the generated stylesheet
      kit.fontFaces({ fontsPath: "./fonts/" }).forEach((fontFace) => {
        addBase({ "@font-face": fontFace });
      });
    }),
  ],
};
