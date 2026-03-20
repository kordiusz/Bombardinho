# Stage 1: Build
FROM node:20-slim AS builder
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy all your local source code into the builder stage
COPY . .

# Stage 2: Production
FROM node:20-slim
WORKDIR /app
ENV NODE_ENV=production

# Copy only the necessary parts from the builder stage
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/server.js ./server.js
COPY --from=builder /app/public ./public

# Fly.io default port
EXPOSE 8080

CMD ["node", "server.js"]