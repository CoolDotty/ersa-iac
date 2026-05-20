#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────
# Backup — creates a snapshot of everything on the VPS
# Run from the VPS or locally: ssh user@host bash < backup.sh
# ──────────────────────────────────────────────────────────

DATE=$(date +%F_%H%M)
BACKUP_DIR="$HOME/backups/ersa-$DATE"
IMMICH_DIR="$HOME/immich"

echo "==> Creating backup at $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"/{immich-db,immich-photos,configs}

# Immich database dump
echo "==> Dumping Immich database..."
podman exec immich_postgres pg_dump -U postgres -d immich -c \
  > "$BACKUP_DIR/immich-db/immich-db-$DATE.sql"
echo "    DB dump: $(wc -c < "$BACKUP_DIR/immich-db/immich-db-$DATE.sql") bytes"

# Immich config
cp "$IMMICH_DIR/.env" "$BACKUP_DIR/configs/immich.env" 2>/dev/null || true

# Immich Photos (real copy)
if [ -d "$IMMICH_DIR/Photos" ]; then
  echo "==> Copying Immich Photos..."
  cp -a "$IMMICH_DIR/Photos" "$BACKUP_DIR/immich-photos/"
  echo "    Photos: $(du -sh "$BACKUP_DIR/immich-photos/" | cut -f1)"
fi

# Service configs
echo "==> Copying service configs..."
cp -r "$HOME/copyparty/copyparty.conf" "$BACKUP_DIR/configs/" 2>/dev/null || true
cp -r "$HOME/radicale/config" "$BACKUP_DIR/configs/" 2>/dev/null || true
cp -r "$HOME/radicale/users" "$BACKUP_DIR/configs/" 2>/dev/null || true
cp -r "$HOME/radicale/collections" "$BACKUP_DIR/configs/" 2>/dev/null || true
cp -r "$HOME/tiny-stats/server.js" "$BACKUP_DIR/configs/" 2>/dev/null || true

echo ""
echo "==> Backup complete: $BACKUP_DIR"
du -sh "$BACKUP_DIR"
echo ""
echo "    To restore:"
echo "      DB:   cat backup/immich-db/*.sql | podman exec -i immich_postgres psql -U postgres -d immich"
echo "      Photos:  cp -a backup/immich-photos/Photos/* ~/immich/Photos/"
echo "      Configs: cp backup/configs/* ~/immich/"
