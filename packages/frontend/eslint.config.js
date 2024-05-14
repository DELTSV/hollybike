import tseslint from "typescript-eslint";
import stylisticJs from '@stylistic/eslint-plugin-js';
import stylisticJsx from '@stylistic/eslint-plugin-jsx';
import unusedImports from "eslint-plugin-unused-imports";

export default [
  ...tseslint.configs.recommended,
  {
    rules: {
      "no-unused-vars": ["off"],
      "@typescript-eslint/no-unused-vars": ["error", { argsIgnorePattern: "^_" }],
      "arrow-body-style": ["error", "as-needed"],
      "curly": ["error", "multi"],
      "no-undef-init": ["error"],
      "no-var": ["error"],
      "prefer-arrow-callback": ["error"],
      "prefer-const": ["error", { destructuring: "all" }],
      "prefer-destructuring": ["error"],
      "prefer-exponentiation-operator": ["error"],
      "prefer-numeric-literals": ["error"],
      "prefer-object-spread": ["error"],
      "prefer-template": ["error"],
      "eol-last": ["error"],
    },
    files: ["src/**/*.{tsx,ts}"]
  },
  {
    plugins: {
      "@stylistic/js": stylisticJs,
    },
    rules: {
      "@stylistic/js/array-bracket-newline": ["error", {multiline: true, minItems: 3}],
      "@stylistic/js/array-element-newline": ["error", {multiline: true, minItems: 3}],
      "@stylistic/js/arrow-parens": ["error", "as-needed", {requireForBlockBody: true}],
      "@stylistic/js/arrow-spacing": ["error", {before: true, after: true}],
      "@stylistic/js/block-spacing": ["error", "always"],
      "@stylistic/js/brace-style": ["error", "1tbs", {allowSingleLine: true}],
      "@stylistic/js/comma-dangle": ["error", "always-multiline"],
      "@stylistic/js/comma-spacing": ["error", {before: false, after: true}],
      "@stylistic/js/comma-style": ["error", "last"],
      "@stylistic/js/computed-property-spacing": ["error", "never", {enforceForClassMembers: true}],
      "@stylistic/js/dot-location": ["error", "property"],
      "@stylistic/js/eol-last": ["error", "always"],
      "@stylistic/js/function-call-argument-newline": ["error", "consistent"],
      "@stylistic/js/function-call-spacing": ["error", "never"],
      "@stylistic/js/function-paren-newline": ["error", "multiline"],
      "@stylistic/js/generator-star-spacing": ["error", "before"],
      "@stylistic/js/indent": ["off", "tab"],
      "@stylistic/js/jsx-quotes": ["error", "prefer-double"],
      "@stylistic/js/key-spacing": ["error", {beforeColon: false, afterColon: true, mode: "strict",}],
      "@stylistic/js/keyword-spacing": ["error", {before: true, after: true}],
      "@stylistic/js/linebreak-style": ["error", "unix"],
      "@stylistic/js/max-len": ["error", {code: 120, tabWidth: 2}],
      "@stylistic/js/no-extra-parens": ["error", "all"],
      "@stylistic/js/no-extra-semi": ["error"],
      "@stylistic/js/no-floating-decimal": ["error"],
      "@stylistic/js/no-multi-spaces": ["error"],
      "@stylistic/js/no-multiple-empty-lines": ["error"],
      "@stylistic/js/no-trailing-spaces": ["error"],
      "@stylistic/js/no-whitespace-before-property": ["error"],
      "@stylistic/js/object-curly-newline": ["error", {multiline: true, minProperties: 2}],
      "@stylistic/js/object-curly-spacing": ["error", "always", {objectsInObjects: false, arraysInObjects: false}],
      "@stylistic/js/object-property-newline": ["error"],
      "@stylistic/js/operator-linebreak": ["error", "before"],
      "@stylistic/js/padded-blocks": ["error", "never"],
      "@stylistic/js/quote-props": ["error", "as-needed"],
      "@stylistic/js/quotes": ["error", "double", {avoidEscape: true, allowTemplateLiterals: true}],
      "@stylistic/js/rest-spread-spacing": ["error", "never"],
      "@stylistic/js/semi": ["error", "always"],
      "@stylistic/js/semi-style": ["error", "last"],
      "@stylistic/js/space-before-blocks": ["error", "always"],
    },
    files: ["src/**/*.{tsx,ts}"],
  },
  {
    plugins: {
      "@stylistic/jsx": stylisticJsx,
    },
    rules: {
      "@stylistic/jsx/jsx-closing-bracket-location": ["error", "line-aligned"],
      "@stylistic/jsx/jsx-closing-tag-location": ["error"],
      "@stylistic/jsx/jsx-curly-newline": ["error", "consistent"],
      "@stylistic/jsx/jsx-curly-spacing": ["error", {when: "always", children: true, allowMultiline: false, spacing: { objectLiterals: "never" }, attributes: false}],
      "@stylistic/jsx/jsx-first-prop-new-line": ["error", "multiline"],
      "@stylistic/jsx/jsx-wrap-multilines": ["error", {return: "parens-new-line"}]
    },
    files: ["src/**/*.tsx"],
  },
  {
    plugins: {
      "unused-imports": unusedImports,
    },
    rules: {
      "unused-imports/no-unused-imports": ["error"],
    },
    files: ["src/**/*.{tsx,ts}"],
  },
];
