import nativewind from "nativewind/preset";

/** @type {import('tailwindcss').Config} */
export default {
  content: ["./**/*.{jsx,tsx}"],
  presets: [nativewind],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        primary: 'rgb(var(--color-primary))',
        text: 'rgb(var(--color-text))',
        background: 'rgb(var(--color-background))',
        icon: 'rgb(var(--color-icon))',
        border: 'rgb(var(--color-border))',
      },
    },
  },
  plugins: [],
};
