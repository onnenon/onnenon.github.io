/** @type {import('tailwindcss').Config} */

module.exports = {
  content: ["./src/**/*.{html,elm,js}"],
  theme: {
    fontFamily: {
      sans: ["Titillium Web, Open Sans", "sans-serif"],
      serif: ["Merriweather", "serif"],
      mono: ["Ubuntu Mono", "monospace"],
    },
    colors: {
      "prime-white": "#f0f6fc",
      "prime-white-bg": "#eaeef2",
      "prime-black": "#0d1117",
      "prime-purple": "#8957e5",
      "prime-gray": "#b1bac4",
    },
    extend: {
      keyframes: {
        blink: {
          "0%, 100%": { color: "transparent" },
          "50%": { color: "rgb(168, 171, 177)" },
        },
      },
      animation: {
        blink: "blink 1.2s step-end infinite",
      },
    },
  },
  plugins: [],
  darkMode: "selector",
};
