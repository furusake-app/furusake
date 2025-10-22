import { honoFactory } from './factory'

const app = honoFactory.createApp()

export const routes = app.basePath('/api').get('/', (c) => c.json({ message: 'Hello, Hono!' }))

export default app
