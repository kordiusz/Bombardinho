# Stage 1: Build
FROM node:20-slim AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY --from=builder /app .

# Stage 2: Production
FROM node:20-slim
WORKDIR /app
ENV NODE_ENV=production

# Copy the installed dependencies and all source files
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/server.js ./server.js
COPY --from=builder /app/public ./public

# Fly.io requires your app to listen on port 8080 by default
EXPOSE 8080

CMD ["node", "server.js"]