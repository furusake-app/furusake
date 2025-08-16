import { defineConfig } from "orval";


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
