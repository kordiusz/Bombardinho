# Stage 1: Build
FROM node:20-slim AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# Stage 2: Production
FROM node:20-slim
WORKDIR /app
ENV NODE_ENV=production

# Copy only the necessary files from builder
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/src ./src 

# Fly.io requires your app to listen on port 8080 by default
EXPOSE 8080

CMD ["node", "server.js"]