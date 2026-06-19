FROM alexberkovich/ubuntu-snapshot:2025-06-16

#[HARDWARE_CONFIG]: Deterministic execution and compilation flags
# Consolidated environment variables to reduce layer allocation overhead.
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    NODE_ENV=development

# Absolute path lock: Guarantees that bare-metal Kate LSP and Docker DAP
# share the exact same source map trajectories.
WORKDIR /work/js-hello-world

#[RUNTIME_ENVIRONMENT]: Deterministic APT Projection
# Hard package pinning for maximum reproducibility in base image.
RUN set -ex && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        nano \
        curl \
        xz-utils \
    && rm -rf /var/lib/apt/lists/* \
    && echo 'set syntax "none"' >> /etc/nanorc

#[HARDWARE_BRIDGE]: Injecting Node.js Runtime
# Direct binary extraction ensures 100% deterministic resolution matching the host version.
ENV NODE_VERSION=22.22.3 \
    NODE_DIST=linux-x64 \
    PATH="/usr/local/bin:$PATH"

RUN set -ex && \
    curl -fsSLO --compressed "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-${NODE_DIST}.tar.xz" && \
    tar -xJf "node-v${NODE_VERSION}-${NODE_DIST}.tar.xz" -C /usr/local --strip-components=1 --no-same-owner && \
    rm "node-v${NODE_VERSION}-${NODE_DIST}.tar.xz" && \
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
##CMD ["sleep", "infinity"]


#mise prune
#mise install
#mise use node@22

#docker build --no-cache --progress=plain -t js-hello-world-i .
#docker run -it js-hello-world-i
# The --entrypoint /bin/bash flag overrides the default script execution.
# You get a Linux command line INSIDE the container.
#docker run -it --entrypoint /bin/bash js-hello-world-i


#docker tag js-hello-world-i alexberkovich/js-hello-world:0.0.1
#docker tag js-hello-world-i alexberkovich/js-hello-world:latest
#docker push alexberkovich/js-hello-world:0.0.1
#docker push alexberkovich/js-hello-world:latest


# Delete all containers
# docker rm -f $(docker ps -a -q)

# This command will only show the dangling images
# (images that are not tagged or referenced by any container)
# docker images -f "dangling=true"

# Delete all dangling images
# docker image prune -f

# Delete all unused images
# docker image prune -a -f

# Delete all images
# docker rmi -f $(docker images -q)

# Delete all build cache
# docker builder prune --all
# Verify builder cache deleted
# docker builder du

# https://gallery.ecr.aws/lambda/python/
# docker volume ls -f dangling=true
# docker volume ls -q -f dangling=true > volumes-to-delete.txt
# Review volumes-to-delete.txt and delete only anonymous or never be used one.
# xargs -r docker volume rm < volumes-to-delete.txt
# docker system prune --all
# docker rm -f js-hello-world
# docker rmi -f js-hello-world-i

# docker build --no-cache . -t js-hello-world-i
# docker build --no-cache --progress=plain . -t js-hello-world-i

# docker run --rm -it js-hello-world-i bash
# docker exec -it $(docker ps -q -n=1) bash

# sudo docker stats | sudo tee -a docker_stats.log
# sudo watch -n 15 "docker stats --no-stream | sudo tee -a docker_stats.log"
# RAM+SWAP memory
# watch -n 1 free -h
