# ── Build stage ──────────────────────────────────────────────────────────────
FROM node:20-alpine AS builder
WORKDIR /app

# Install deps first (cached layer)
COPY package.json package-lock.json ./
COPY backend/package.json ./backend/
COPY frontend/package.json ./frontend/
COPY prisma ./prisma/

RUN npm ci

RUN npx prisma generate

# Copy source and compile
COPY backend/src ./backend/src/
COPY backend/tsconfig.json ./backend/
COPY scripts ./scripts/
COPY tsconfig.json ./

RUN cd backend && npx tsc

# ── Production stage ──────────────────────────────────────────────────────────
FROM node:20-alpine AS production
WORKDIR /app

# Copy node_modules from builder (includes generated Prisma client + CLI)
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/backend/dist ./backend/dist
COPY --from=builder /app/prisma ./prisma
COPY package.json ./

EXPOSE 3001

CMD ["sh", "-c", "npx prisma migrate deploy && node backend/dist/server.js"]
