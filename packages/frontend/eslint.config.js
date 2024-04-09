import globals from "globals";
import tseslint from "typescript-eslint";

export default [
  { languageOptions: { globals: globals.browser } },
  ...tseslint.configs.recommended,
  {
    rules: {
      semi: [2, "always"]
    },
    files: ["src/**/*.tsx", "src/**/*.ts"]
  }
];