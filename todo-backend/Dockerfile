# Build stage
FROM --platform=$TARGETPLATFORM node:22-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .

# Production stage
FROM  node:22-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production && \
    npm install pm2 -g
COPY --from=builder /app .
ENV NODE_ENV=production

# Expose the port
EXPOSE 3002

# Start the application with PM2
CMD ["pm2-runtime", "start.js"]