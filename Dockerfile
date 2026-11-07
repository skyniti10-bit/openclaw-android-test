# Isolated Railway gateway upgrade. Wrapper source: vignesh07/clawdbot-railway-template@b9e2467189d02dfe51a80173c40bad650a58eaf2
# Official OpenClaw release pinned to 2026.11.1; the supported Node 26 runtime is used.
FROM node:26-bookworm
ENV NODE_ENV=production
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates tini python3 python3-venv git make g++ \
 && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY package.json package-lock.json ./
# Use the official, version-pinned npm distribution instead of compiling from git.
RUN npm ci --omit=dev \
 && npm install --global --omit=dev openclaw@2026.11.1 \
 && test -f /usr/local/lib/node_modules/openclaw/dist/entry.js \
 && ln -s /usr/local/lib/node_modules/openclaw /openclaw
# Preserve the original wrapper's fixed CLI entrypoint and persistence contract.
ENV OPENCLAW_ENTRY=/openclaw/dist/entry.js
ENV NPM_CONFIG_PREFIX=/data/npm
ENV NPM_CONFIG_CACHE=/data/npm-cache
ENV PATH="/data/npm/bin:${PATH}"
COPY src ./src
EXPOSE 8080
ENTRYPOINT ["tini", "--"]
CMD ["node", "src/server.js"]
