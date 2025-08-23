import nativewind from "nativewind/preset";

/** @type {import('tailwindcss').Config} */
export default {
  content: ["./**/*.{jsx,tsx}"],
  presets: [nativewind],
  theme: {
    extend: {},
  },
  plugins: [],
};
