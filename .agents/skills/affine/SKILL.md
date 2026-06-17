---
name: affine
description: Manage the Affine knowledge base running in podman on ersa.whatbox.ca. Use when the user asks about Affine docs, workspaces, or troubleshooting the Affine server.
allowed-tools: read, bash, web_search
---

# Affine — Knowledge Base

> **STUB** — If you are the AI agent picking up this task, you are expected to
> fill in what you learn: server details, common commands, file locations,
> restart procedures, and any known pitfalls. Delete this notice once the
> skill has real substance.

## What is it?

Affine is an open-source knowledge base / Notion alternative. It runs in podman
with Redis and PostgreSQL.

## Known facts (as of 2025-06)

- Container group: `affine_server`, `affine_postgres`, `affine_redis`, `affine_infra`
- Image: `ghcr.io/toeverything/affine:stable`
- Port: `127.0.0.1:3010` → `3010`
- Ansible config: `ansible/files/affine/`
- Supervisor config: `~/.config/supervisord/conf.d/affine.ini`
- Data: `~/affine/`

## Common tasks (TODO — fill in as learned)

### Restart

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  "podman restart affine_server"
```

### Check status

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  "podman ps --filter name=affine --format '{{.Names}} {{.Status}}'"
```

### Health check

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  "curl -s -o /dev/null -w '%{http_code}' http://localhost:3010"
```
