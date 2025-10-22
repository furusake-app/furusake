import { cors } from 'hono/cors'
import { createFactory } from 'hono/factory'
import { logger } from 'hono/logger'
import { poweredBy } from 'hono/powered-by'
import { trimTrailingSlash } from 'hono/trailing-slash'

type CloudflareEnv = {
  Bindings: CloudflareBindings
}

export const honoFactory = createFactory<CloudflareEnv>({
  initApp: (app) => {
    app.basePath('/api')

    app.use(cors({
      origin: (_, c) => c.env.FRONTEND_ORIGIN ?? '',
    }))
    app.use(trimTrailingSlash())
    app.use(logger())
    app.use(poweredBy())
  },
})
