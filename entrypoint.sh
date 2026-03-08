#!/bin/sh
set -e

# ---------------------------------------------------------------------------
# entrypoint.sh — UID/GID remapping + stale SQLite cleanup
#
# Runs as root at container start. Remaps the in-container 'node' user/group
# to match the host UID/GID (passed via HOST_UID / HOST_GID env vars), fixes
# ownership of pre-built home directories, cleans up stale SQLite lock files,
# then drops privileges and execs the requested command as 'node'.
#
# This eliminates bind-mount permission mismatches without any host-side
# chgrp/chmod surgery.
# ---------------------------------------------------------------------------

TARGET_UID="${HOST_UID:-1000}"
TARGET_GID="${HOST_GID:-1000}"

echo "[entrypoint] Remapping node -> UID=${TARGET_UID} GID=${TARGET_GID}"

# Remap group first (usermod depends on the group already existing at new GID)
if [ "$TARGET_GID" != "1000" ]; then
    groupmod -g "$TARGET_GID" node
fi

# Remap user
if [ "$TARGET_UID" != "1000" ]; then
    usermod -u "$TARGET_UID" node
fi

# Fix ownership of home directories that were created at build time
# (they were chowned to the old UID 1000; update them to the new UID)
chown -R node:node /home/node

# ---------------------------------------------------------------------------
# Clean up any stale SQLite journal/WAL/SHM artifacts left behind by a
# previous crash or mismatched-UID run. These cause "database disk image is
# malformed" errors on gVisor.
# ---------------------------------------------------------------------------
for dir in \
    /home/node/.local/share/opencode \
    /home/node/.opencode \
    /home/node/.config/opencode; do
    if [ -d "$dir" ]; then
        find "$dir" \( -name "*.db-shm" -o -name "*.db-wal" -o -name "*.db-journal" \) \
            -exec rm -f {} + 2>/dev/null || true
    fi
done

echo "[entrypoint] Starting as node (UID=$(id -u node) GID=$(id -g node)): $*"

# Drop privileges and exec the application (becomes PID 1)
exec gosu node "$@"
