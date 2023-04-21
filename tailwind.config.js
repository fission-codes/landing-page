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
        "purple-fade":
          "linear-gradient(360deg, rgba(100, 70, 250, 0) 10.03%, rgba(100, 70, 250, 0.04) 32.78%, rgba(100, 70, 250, 0.08) 51.82%, rgba(100, 70, 250, 0.12) 70.86%, rgba(100, 70, 250, 0.16) 84.79%, rgba(100, 70, 250, 0.2) 99.18%);",
      },
      colors: {
        newneutral: {
          "0": "#fcfcfd",
          "100": "#eeeef5",
          "200": "#c8c8d4",
          "300": "#a3a3b3",
          "400": "#808094",
          "500": "#5e5f76",
          "600": "#3e3f59",
          "700": "#1f223d",
          "800": "#17172b"
        },
        pink: {
          "100": "#ffdbe2",
          "200": "#ffadb8",
          "300": "#ff8697",
          "400": "#fd5375",
          "500": "#fa2e55",
          "600": "#ec1345"
        },
        purple: {
          "100": "#e0deff",
          "200": "#c0baff",
          "300": "#a195ff",
          "400": "#836fff",
          "500": "#6446fa",
          "600": "#523ee5"
        },
        yellow: {
          "100": "#fff0ad",
          "200": "#f9dd90",
          "300": "#f2ca74",
          "400": "#eab757"
        },
        red: {
          "100": "#ffbdc8",
          "200": "#ff9c9f",
          "300": "#fd7977",
          "400": "#f65555"
        },
        green: {
          "100": "#a1e2c1",
          "200": "#82d1a6",
          "300": "#61c18c",
          "400": "#3bb073"
        }, 
      },
      fontFamily: {
        display: ["PPFragment"],
        sans: ["UncutSans"],
      },
      fontSize: {
        "heading-2xl": ["3.052rem", { lineHeight: "120%", letterSpacing: "-0.01em"  }],
        "heading-xl": ["2.441rem", { lineHeight: "120%", letterSpacing: "-0.01em"  }],
        "heading-lg": ["1.953rem", { lineHeight: "120%", letterSpacing: "-0.01em"  }],
        "heading-base": ["1.563rem", { lineHeight: "120%", letterSpacing: "-0.01em"  }],
        "heading-sm": ["1.266rem", { lineHeight: "120%", letterSpacing: "-0.01em"  }],
        "heading-xs": ["1rem", { lineHeight: "120%", letterSpacing: "-0.01em" }],
        "body-3xl": ["1.602rem", { lineHeight: "130%" }],
        "body-2xl": ["1.424rem", { lineHeight: "130%" }],
        "body-xl": ["1.266rem", { lineHeight: "130%" }],
        "body-lg": ["1.1rem", { lineHeight: "130%" }],
        "body-base": ["1rem", { lineHeight: "130%" }],
        "body-sm": [".889rem", { lineHeight: "130%" }],
        "body-xs": ["0.79rem", { lineHeight: "130%" }],
        "body-2xs": ["0.702rem", { lineHeight: "130%" }],
        "button-xl": ["1.266rem", { lineHeight: "100%" }],
        "button-lg": ["1.1rem", { lineHeight: "100%" }],
        "button-base": ["1rem", { lineHeight: "100%" }],
        "button-sm": [".889rem", { lineHeight: "100%" }],
        "button-xs": ["0.79rem", { lineHeight: "100%" }]
      },
      zIndex: {
        max: "1000",
      },
      borderWidth: {
        DEFAULT: '1.4px',
      },
      "borderRadius": {
        "none": "0",
        "xs": "0.5rem",
        "sm": "0.7rem"
      },
      screens: {
        'xl': '1352px',
      }
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
    require('@tailwindcss/typography'),
  ],
};
