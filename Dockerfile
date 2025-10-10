FROM node:22-alpine AS base
RUN apk add --no-cache python3 make g++

FROM base AS deps
WORKDIR /app
COPY package*.json ./
RUN npm install --legacy-peer-deps

FROM base AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install --legacy-peer-deps
COPY content ./
RUN npm run build

FROM base AS runner
RUN apk add --no-cache vips-dev tini
WORKDIR /app
ENV NODE_ENV=development
COPY --from=builder /app ./

# Create LazyCAT platform directory structure
RUN mkdir -p /init/ && \
    cp -r config /init/ && \
    cp -r src /init/

EXPOSE 1337
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["npm", "run", "develop"]
