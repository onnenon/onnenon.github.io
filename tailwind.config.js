/** @type {import('tailwindcss').Config} */

module.exports = {
  content: ["./src/**/*.{html,elm,js}"],
  theme: {
    fontFamily: {
      sans: ["Titillium Web, Open Sans", "sans-serif"],
      serif: ["Merriweather", "serif"],
      mono: ["Mononoki", "monospace"],
    },
    colors: {
      "prime-dark-black": "#0d1117",
      "prime-dark-purple": "#d2a8ff",
      "prime-dark-gray": "#b1bac4",
      "prime-dark-green": "#56d364",
      "prime-dark-yellow": "#e3b341",
      "prime-dark-white": "#e6edf3",
      "prime-dark-blue": "#79c0ff",
      "prime-light-purple": "#8250df",
      "prime-light-gray": "#484f58",
      "prime-light-black": "#1f2328",
      "prime-light-white": "#f6f8fa",
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
