module.exports = {
  // These are the files that Purgecss will search through
  content: ["./**/*.html", "./**/*.js"],

  // These are the stylesheets that will be subjected to the purge
  css: ["./dist/main.css"],
  defaultExtractor: content => content.match(/[\w-/:]+(?<!:)/g) || []
};
