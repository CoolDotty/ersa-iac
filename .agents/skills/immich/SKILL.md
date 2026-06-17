---
name: immich
description: Manage the Immich photo/video backup server running in podman on ersa.whatbox.ca. Use when the user asks about photo uploads, Immich issues, or media backup.
allowed-tools: read, bash, web_search
---

# Immich — Photo & Video Backup

> **STUB** — If you are the AI agent picking up this task, you are expected to
> fill in what you learn: server details, common commands, file locations,
> restart procedures, and any known pitfalls. Delete this notice once the
> skill has real substance.

## What is it?

Immich is a self-hosted Google Photos alternative. Runs in podman with
PostgreSQL, Redis, and a machine-learning container.

## Known facts (as of 2025-06)

- Container group: `immich_server`, `immich_postgres`, `immich_redis`, `immich_machine_learning`, `immich_infra`
- Image: `ghcr.io/immich-app/immich-server:v2`
- Port: `2283`
- Ansible config: `ansible/files/immich/`
- Supervisor config: `~/.config/supervisord/conf.d/immich.ini`
- Started via `cron.reboot` with `podman-compose up`
- Data: `~/immich/`

## Common tasks (TODO — fill in as learned)

### Restart

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  "cd ~/immich && podman-compose down && podman-compose up -d"
```

### Check status

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  "podman ps --filter name=immich --format '{{.Names}} {{.Status}}'"
```

### Health check

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  "curl -s -o /dev/null -w '%{http_code}' http://localhost:2283"
```
