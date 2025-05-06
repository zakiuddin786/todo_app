# Build stage
FROM --platform=$TARGETPLATFORM node:22-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# Production stage
FROM  node:22-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install && \
    npm install pm2 -g
COPY --from=builder /app .
ENV NODE_ENV=production

# Expose the port
EXPOSE 3002

VOLUME ["/var/log/todo-app"]
# Start the application with PM2
CMD ["pm2-runtime", "start.js"]