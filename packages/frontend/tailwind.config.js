/** @type {import('tailwindcss').Config} */
export default {
    darkMode: 'selector',
    content: [
        "./index.html",
        "./src/**/*.{js,jsx,ts,tsx}",
    ],
    theme: {
        extend: {
            colors: {
                rosewater: 'rgba(var(--color-rosewater), <alpha-value>)',
                flamingo: 'rgba(var(--color-flamingo), <alpha-value>)',
                pink: 'rgba(var(--color-pink), <alpha-value>)',
                mauve: 'rgba(var(--color-mauve), <alpha-value>)',
                red: 'rgba(var(--color-red), <alpha-value>)',
                marron: 'rgba(var(--color-marron), <alpha-value>)',
                peach: 'rgba(var(--color-peach), <alpha-value>)',
                yellow: 'rgba(var(--color-yellow), <alpha-value>)',
                green: 'rgba(var(--color-green), <alpha-value>)',
                teal: 'rgba(var(--color-teal), <alpha-value>)',
                sky: 'rgba(var(--color-sky), <alpha-value>)',
                sapphire: 'rgba(var(--color-sapphire), <alpha-value>)',
                blue: 'rgba(var(--color-blue), <alpha-value>)',
                lavender: 'rgba(var(--color-lavender), <alpha-value>)',
                text: 'rgba(var(--color-text), <alpha-value>)',
                "subtext-1": 'rgba(var(--color-subtext-1), <alpha-value>)',
                "subtext-0": 'rgba(var(--color-subtext-0), <alpha-value>)',
                "overlay-2": 'rgba(var(--color-overlay-2), <alpha-value>)',
                "overlay-1": 'rgba(var(--color-overlay-1), <alpha-value>)',
                "overlay-0": 'rgba(var(--color-overlay-0), <alpha-value>)',
                "surface-2": 'rgba(var(--color-surface-2), <alpha-value>)',
                "surface-1": 'rgba(var(--color-surface-1), <alpha-value>)',
                "surface-0": 'rgba(var(--color-surface-0), <alpha-value>)',
                base: 'rgba(var(--color-base), <alpha-value>)',
                mantle: 'rgba(var(--color-mantle), <alpha-value>)',
                crust: 'rgba(var(--color-crust), <alpha-value>)'
            },
            height: {
                "9.5": "2.375rem"
            },
            width: {
                "68": "16rem"
            }
        },
    },
    plugins: [],
}

