import type { Hono } from 'hono'
import { type CloudflareEnv, honoFactory } from './factory'

const app: Hono<CloudflareEnv> = honoFactory.createApp()

export const routes = app.basePath('/api').get('/', (c) => c.json({ message: 'Hello, Hono!' }))

export default app
