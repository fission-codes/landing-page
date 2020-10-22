import defaultTheme from "tailwindcss/defaultTheme.js"
import plugin from "tailwindcss/plugin.js"
import * as kit from "fission-kit"
import typography from "@tailwindcss/typography"


export default {

  /////////////////////////////////////////
  // THEME ////////////////////////////////
  /////////////////////////////////////////

  theme: {

    // Colors
    // ------

    colors: {
      ...kit.dasherizeObjectKeys(kit.colors),

      "current-color": "currentColor",
      "inherit": "inherit",
      "transparent": "transparent"
    },

    // Fonts
    // -----

    fontFamily: {
      ...defaultTheme.fontFamily,

      body: [ `"${kit.fonts.body}"`, ...defaultTheme.fontFamily.sans ],
      display: [ `"${kit.fonts.display}"`, ...defaultTheme.fontFamily.serif ],
      mono: [ `"${kit.fonts.mono}"`, ...defaultTheme.fontFamily.mono ],
    },

    // Inset
    // -----

    inset: {
      "auto": "auto",
      "0": 0,
      "1/4": "25%",
      "1/2": "50%",
      "3/4": "75%",
      "full": "100%"
    },

    // Opacity
    // -------

    opacity: {
      "0": "0",
      "10": ".1",
      "20": ".2",
      "25": ".25",
      "30": ".3",
      "40": ".4",
      "50": ".5",
      "60": ".6",
      "70": ".7",
      "75": ".75",
      "80": ".8",
      "90": ".9",
      "100": "1",
    },

    // Extensions
    // ==========

    extend: {

      fontSize: {
        "2_5xl": "1.6875rem",
        "3_5xl": "2.0625rem",
      },

      screens: {
        dark: { raw: '(prefers-color-scheme: dark)' }
      },

    },

  },


  /////////////////////////////////////////
  // VARIANTS /////////////////////////////
  /////////////////////////////////////////

  variants: {
    "margin": [ "first", "last", "responsive" ]
  },


  /////////////////////////////////////////
  // PLUGINS //////////////////////////////
  /////////////////////////////////////////

  plugins: [
    typography,
  ],

  typography: (theme) => ({
    default: {
      css: {
        color: theme('colors.gray.200'),
      },
    },
  }),

}
