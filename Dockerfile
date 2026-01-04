# syntax=docker/dockerfile:1

FROM node:22-alpine AS build
WORKDIR /app

RUN npm i -g pnpm@9.15.0
ENV PNPM_STORE_PATH=/pnpm/store
RUN pnpm config set store-dir $PNPM_STORE_PATH

COPY package.json pnpm-lock.yaml ./
RUN pnpm fetch

COPY . .
RUN pnpm install --frozen-lockfile
RUN pnpm build
RUN pnpm prune --prod

FROM node:22 AS runtime
ENV NODE_ENV=production
WORKDIR /app

RUN npm i -g pm2@latest

COPY --from=build /app/package.json ./
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist

EXPOSE 3000
CMD ["pm2-runtime", "dist/main.js", "--name", "gitops-server"]