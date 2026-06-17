---
name: karakeep
description: Manage the Karakeep bookmark manager running in podman on ersa.whatbox.ca. Use when the user asks about bookmarks, archiving, or Karakeep issues.
allowed-tools: read, bash, web_search
---

# Karakeep — Bookmark Manager

> **STUB** — If you are the AI agent picking up this task, you are expected to
> fill in what you learn: server details, common commands, file locations,
> restart procedures, and any known pitfalls. Delete this notice once the
> skill has real substance.

## What is it?

Karakeep (formerly Hoarder) is a self-hosted bookmark manager with archiving.
Runs in podman with Meilisearch and a headless Chrome for page capture.

## Known facts (as of 2025-06)

- Container group: `karakeep_web`, `karakeep_chrome`, `karakeep_meilisearch`, `karakeep_infra`
- Image: `ghcr.io/karakeep-app/karakeep:release`
- Port: `127.0.0.1:5272` → `3000`
- Ansible config: `ansible/files/karakeep/`
- Supervisor config: `~/.config/supervisord/conf.d/karakeep.ini`
- Data: `~/karakeep/`

## Common tasks (TODO — fill in as learned)

### Restart

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  "podman restart karakeep_web"
```

### Che
