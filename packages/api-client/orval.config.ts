import { defineConfig } from "orval";

console.log(process.env.AAA);

export default defineConfig({
  api: {
    input: "../../openapi.json",
    output: {
      target: "./src/api.ts",
      schemas: "./src/models",
      client: "fetch",
      baseUrl: process.env.API_BASE_URL,
      biome: true
    },
  },
});
