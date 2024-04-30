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
      "prime-white": "#e6edf3",
      "prime-white-bg": "#f6f8fa",
      "prime-black": "#0d1117",
      "prime-black-txt": "#1f2328",
      "prime-purple": "#d2a8ff",
      "prime-purple-lt": "#8250df",
      "prime-gray": "#b1bac4",
      "prime-gray-lt": "#484f58",
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
