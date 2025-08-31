# Minimal, secure-ish Node runtime
FROM node:18-alpine
ENV NODE_ENV=production
WORKDIR /usr/src/app

# Install prod deps first for better layer caching
COPY app/package.json ./package.json
RUN npm install --omit=dev

# Copy app code
COPY app/ .

# Non-root user (provided by base image)
USER node
ENV PORT=8080
EXPOSE 8080
CMD ["node", "server.js"]
