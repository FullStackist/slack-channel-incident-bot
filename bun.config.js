// bun.config.js
export default {
    entry: "./app/javascript/application.js",
    outdir: "app/assets/builds", 
    minify: true,
    target: "es2020",
    sourcemap: true,
    publicPath: "/assets"
  };
  