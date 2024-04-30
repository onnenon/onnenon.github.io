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
      "prime-white": "c9d1d9",
      "prime-bg": "0d1117",
      "prime-purple": "8a63d2",
      "cursor-gray": "8b949e",
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
};
