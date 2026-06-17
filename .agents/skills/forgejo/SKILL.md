---
name: forgejo
description: Manage the Forgejo git forge running in podman on ersa.whatbox.ca. Use when the user asks about git repos, Forgejo config, or CI/CD issues.
allowed-tools: read, bash, web_search
---

# Forgejo — Git Forge

> **STUB** — If you are the AI agent picking up this task, you are expected to
> fill in what you learn: server details, common commands, file locations,
> restart procedures, and any known pitfalls. Delete this notice once the
> skill has real substance.

## What is it?

Forgejo is a self-hosted git forge (fork of Gitea). Runs in podman.

## Known facts (as of 2025-06)

- Container group: `forgejo`, `forgejo_infra`
- Image: `codeberg.org/forgejo/forgejo:15`
- Port: `127.0.0.1:3100` → `3100`
- Ansible config: `ansible/files/forgejo/`
- Supervisor config: `~/.config/supervisord/conf.d/forgejo.ini`
- Data: `~/forgejo/`

## Common tasks (TODO — fill in as learned)

### Restart

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  "podman restart forgejo"
```

### Check status

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  "podman ps --filter name=forgejo --format '{{.Names}} {{.Status}}'"
```

### Health check

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  "curl -s -o /dev/null -w '%{http_code}' http://localhost:3100"
```
