# NexaTrade — SvelteKit (adapter-node) on Bun
# Single-stage build keeps the full workspace + hoisted node_modules so all
# runtime imports resolve reliably inside this Bun monorepo.
FROM oven/bun:1.3.14

WORKDIR /app

# Install deps first (better layer caching)
COPY package.json bun.lock turbo.json ./
COPY packages/ui/package.json ./packages/ui/package.json
COPY apps/portal/package.json ./apps/portal/package.json
RUN bun install --frozen-lockfile

# Build
COPY . .
RUN bun run build

ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=3000
ENV BODY_SIZE_LIMIT=10M

EXPOSE 3000

# adapter-node server bundle
CMD ["bun", "apps/portal/build/index.js"]
