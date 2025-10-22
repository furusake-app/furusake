import "server-only";

import type { routes } from "api";
import { hc } from "hono/client";

const { BACKEND_ORIGIN } = process.env;

if (BACKEND_ORIGIN === undefined || BACKEND_ORIGIN.length === 0) {
  throw new Error("BACKEND_ORIGIN is not defined");
}

export const apiClient = hc<typeof routes>(BACKEND_ORIGIN).api;
