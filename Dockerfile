#[DECOHERENCE_BOUNDARY]: Ubuntu Base (Size Limit: IGNORED)
# Absolute Phase Lock. Pointer tags (e.g., :24.04) are PROHIBITED.
FROM ubuntu@sha256:c4a8d5503dfb2a3eb8ab5f807da5bc69a85730fb49b5cfca2330194ebcc41c7b

#[HARDWARE_CONFIG]: Deterministic execution and compilation flags
# Consolidated environment variables to reduce layer allocation overhead.
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    NODE_ENV=development

# Absolute path lock: Guarantees that bare-metal Kate LSP and Docker DAP 
# share the exact same source map trajectories.
WORKDIR /work/js-hello-world

#[RUNTIME_ENVIRONMENT]: Deterministic APT Projection
# Hard package pinning for maximum reproducibility.
RUN set -ex && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates=20240203 \
        nano \
        curl \
        xz-utils \
    && rm -rf /var/lib/apt/lists/* \
    && apt-mark hold ca-certificates nano \
    # Extra strict pinning: prevent newer versions even if they appear in repositories
    && echo 'Package: ca-certificates' > /etc/apt/preferences.d/ca-certificates-pin \
    && echo 'Pin: version 20240203' >> /etc/apt/preferences.d/ca-certificates-pin \
    && echo 'Pin-Priority: 1001' >> /etc/apt/preferences.d/ca-certificates-pin \
    && update-ca-certificates --fresh \
    && echo 'set syntax "none"' >> /etc/nanorc

#[HARDWARE_BRIDGE]: Injecting Node.js Runtime (Bypassing version managers)
# Container philosophy dictates the container IS the environment. No mise/nvm needed.
# Direct binary extraction ensures 100% deterministic resolution matching the host version.
ENV NODE_VERSION=22.22.3 \
    NODE_DIST=linux-x64 \
    PATH="/usr/local/bin:$PATH"

RUN set -ex && \
    curl -fsSLO --compressed "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-${NODE_DIST}.tar.xz" && \
    tar -xJf "node-v${NODE_VERSION}-${NODE_DIST}.tar.xz" -C /usr/local --strip-components=1 --no-same-owner && \
    rm "node-v${NODE_VERSION}-${NODE_DIST}.tar.xz" && \
    # Verify installation
    node --version && \
    npm --version

#[DEPENDENCY_INJECTION]: Top-Down Directed Acyclic Graph Mount
COPY package.json package-lock.json ./

#[POINTER_ALLOCATION]: Synthetic Mock-Node Cache Strategy
# npm ci is strictly deterministic based on package-lock.json.
# It bypasses dependency resolution entirely, isolating lockfile layer from source jitter.
RUN set -ex && \
    npm ci

#[AST_COPY]: Mount Root Logic
COPY . .

#[PROJECT_INJECTION]: Finalize Symbol Table Linkage
# Run TypeScript compiler to validate syntax and emit JavaScript to the ./dist directory.
RUN set -ex && \
    npx tsc

#[ENTRYPOINT]: Hardware Transition (Main Thread Execution)
# Execute the compiled AOT logic. 
# For live-reload dev mode, docker-compose will override this with `npx tsx watch index.ts`.
CMD ["node", "dist/index.js"]
