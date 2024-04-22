FROM node:20-slim AS base

# Install dependencies
FROM base AS deps

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY package.json pnpm-lock.yaml ./
RUN corepack enable \
  && pnpm i

# Install jemalloc
RUN apt-get update \
  && apt-get install -y curl wget pwgen gcc make bzip2 \
  && wget -q https://github.com/jemalloc/jemalloc/releases/download/5.3.0/jemalloc-5.3.0.tar.bz2 \
  && tar xjf jemalloc-5.3.0.tar.bz2 \
  && cd jemalloc-5.3.0 \
  && ./configure \
  && make \
  && make install \
  && cd ..


# Build app only if the source code has changed
FROM base AS builder

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY --from=deps /usr/src/app/node_modules ./node_modules
COPY --from=deps /usr/local/lib/libjemalloc.so /usr/local/lib/libjemalloc.so
COPY . .

# Disable Next.js telemetry
ENV NEXT_TELEMETRY_DISABLED 1
ENV NEXT_PUBLIC_BASE_URL https://api-challenge.sesims.com.br/
ENV LD_PRELOAD=/usr/local/lib/libjemalloc.so
ENV MALLOC_CONF=prof:true,prof_leak:true,lg_prof_interval:26,lg_prof_sample:16

# Build the app
RUN corepack enable \
  && pnpm build

# Production image, copy all the build and run node
FROM base AS runner

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ENV NODE_ENV production
ENV LD_PRELOAD="jemalloc-config --libdir /usr/local/lib/libjemalloc.so"
ENV MALLOC_CONF=prof:true,prof_leak:true,lg_prof_interval:26,lg_prof_sample:16

RUN addgroup --system --gid 1001 nodejs \
  && adduser --system --uid 1001 --ingroup nodejs nextjs \
  && mkdir .next \
  && chown nextjs:nodejs .next

COPY --from=builder --chown=nextjs:nodejs /usr/src/app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /usr/src/app/.next/static ./.next/static
COPY --from=builder --chown=nextjs:nodejs /usr/src/app/public ./public
COPY --from=deps /usr/local/lib/libjemalloc.so /usr/local/lib/libjemalloc.so

USER nextjs

EXPOSE 3000

ENV PORT 3000
ENV HOSTNAME "0.0.0.0"

CMD ["node", "server.js"]