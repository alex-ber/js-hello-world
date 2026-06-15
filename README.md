## [COMPOSE ORCHESTRATION (ENVIRONMENT SETUP)]
To avoid permission decoherence between the Host OS and the Docker runtime (especially on Linux environments), you must map your bare-metal User ID and Group ID into the container. This guarantees that files created by the runtime belong to you, preventing root-owned pollution on the host.

1. **Initialize the local environment bridge:**
   ```bash
   cp env.example .env
   ```

2. **Inject your bare-metal host IDs (Linux/Ubuntu):**
   ```bash
   echo "HOST_UID=$(id -u)" >> .env
   echo "HOST_GID=$(id -g)" >> .env
   ```

3. **Compile and ignite the orchestrated runtime:**
   ```bash
   docker compose build --no-cache --progress=plain
   docker compose up
   #docker compose up -d
   ```

4. **Terminate the application (`[DROP_PACKET]`):**
   ```bash
   docker compose down -v
   ```
   *Note: The `-v` parameter unmounts and destroys the anonymous `.venv` volume mapped in the `docker-compose.yml`. This wipes the isolated virtual environment state to prevent execution quirks across rebuilds, though it is not always strictly necessary.*
 
5. If you want to read logs use (for example, you've used `docker compose up -d` command)

   ```bash
   docker logs -f js-hello-world
   ```
