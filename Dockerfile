# Minimal, secure-ish Node runtime
FROM node:20-alpine AS build
ENV NODE_ENV=production
WORKDIR /usr/src/app
COPY app/package.json ./package.json
RUN npm install --omit=dev
COPY app/ .

FROM gcr.io/distroless/nodejs20-debian12
WORKDIR /app
COPY --from=build /usr/src/app /app
USER nonroot
ENV PORT=8080
EXPOSE 8080
CMD ["server.js"]
