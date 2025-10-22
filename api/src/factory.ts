import { cors } from 'hono/cors'
import { createFactory, type Factory } from 'hono/factory'
import { logger } from 'hono/logger'
import { poweredBy } from 'hono/powered-by'
import { trimTrailingSlash } from 'hono/trailing-slash'

export type CloudflareEnv = {
  Bindings: CloudflareBindings
}

export const honoFactory: Factory<CloudflareEnv> = createFactory<CloudflareEnv>({
  initApp: (app) => {
    app.basePath('/api')

    app.use(
      cors({
        origin: (_, c) => c.env.FRONTEND_ORIGIN ?? '',
      }),
    )
    app.use(trimTrailingSlash())
    app.use(logger())
    app.use(poweredBy())
  },
})
