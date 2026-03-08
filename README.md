# aicli Sandbox

A sandboxed OpenCode AI server running inside Docker with:
- **gVisor (`runsc`)** for kernel-level isolation
- **Tinyproxy egress filter** restricting outbound internet to an explicit allowlist of AI/dev API endpoints
- **CoreDNS** for internal service name resolution within the isolated network
- **Dynamic UID/GID remapping** so bind-mounted host directories always match the host user — no manual `chgrp`/`chmod` needed

---

## Architecture

```
host
 └── docker compose (docker-compose-sandbox-v4.yml)
      ├── internal-dns   (CoreDNS, 172.28.0.53)
      ├── egress-proxy   (Tinyproxy — allowlist-only outbound)
      └── opencode-sandbox
           ├── runtime: gVisor (runsc)
           ├── entrypoint.sh  ← remaps UID/GID, cleans SQLite locks, drops to node
           └── opencode serve --port 4096
```

---

## Prerequisites

- Docker Engine with the **gVisor** (`runsc`) runtime installed
- Docker Compose v2
- A `.env` file in this directory (see below)

---

## Configuration

### `.env` file

Create a `.env` file in this directory (it is gitignored and machine-specific):

```bash
# Host UID/GID — must match the owner of the bind-mounted directories
HOST_UID=1002
HOST_GID=1002

# API keys
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-...
```

The `HOST_UID`/`HOST_GID` values must match the UID/GID of your host user (the owner
of `~/.config/opencode`, `~/.local/share/opencode`, `~/.opencode`, etc.).
Check with:

```bash
id
# uid=1002(asurace) gid=1002(asurace) ...
```

### Overriding the UID/GID on the fly

There are three ways, in order of precedence:

**1. Inline shell variable (one-off override, highest precedence):**
```bash
HOST_UID=1003 HOST_GID=1003 \
  AICLI_WORKSPACE="../getinspiredbythebible" \
  docker compose -f docker-compose-sandbox-v4.yml up
```

**2. Edit `.env` (persistent default for this machine):**
```bash
HOST_UID=1003
HOST_GID=1003
```

**3. Derive from the current shell user (portable, zero-config):**
```bash
HOST_UID=$(id -u) HOST_GID=$(id -g) \
  AICLI_WORKSPACE="../getinspiredbythebible" \
  docker compose -f docker-compose-sandbox-v4.yml up
```

Precedence: `inline shell var` > `.env file` > compose default (`1002`)

---

## How UID/GID remapping works

The container starts as root and runs `entrypoint.sh`, which:

1. Remaps the in-container `node` user/group to `HOST_UID`/`HOST_GID`
2. Re-chowns `/home/node` to the new UID/GID
3. Removes any stale SQLite lock files (`.db-shm`, `.db-wal`, `.db-journal`) that
   cause *"database disk image is malformed"* errors on gVisor
4. Drops privileges via `gosu node` and execs the application as PID 1

This means every file written by the container process is owned by the same UID as
your host user — no `chgrp`/`chmod` surgery required, ever.

---

## Build

```bash
docker compose -f docker-compose-sandbox-v4.yml build opencode-sandbox
```

---

## Run

```bash
# Use current directory as workspace
docker compose -f docker-compose-sandbox-v4.yml up

# Use a specific workspace directory
AICLI_WORKSPACE="../getinspiredbythebible" \
  docker compose -f docker-compose-sandbox-v4.yml up

# Follow logs
docker compose -f docker-compose-sandbox-v4.yml logs -f
```

---

## Client

Connect from the host using the OpenCode CLI:

```bash
opencode attach http://localhost:4096
# or attach to an existing session
opencode attach http://localhost:4096 -s ses_33dc7306cffeNyfefWQb7w6MZL
```

---

## Claude Code integration

1. Run `claude code init` on the host
2. Check `~/.claude/credentials.json` for the `accessToken`
3. In the OpenCode UI, use that token when connecting to Anthropic

The `~/.claude` directory is bind-mounted into the container at `/home/node/.claude`.

---

## Egress allowlist

Only the following hosts are reachable from the sandbox (see `tinyproxy-filter`):

```
api.anthropic.com
platform.claude.com
api.githubcopilot.com
copilot-proxy.githubusercontent.com
openrouter.ai
api.openrouter.ai
github.com
api.github.com
pypi.org
```

All other outbound HTTP/HTTPS is blocked by default.
