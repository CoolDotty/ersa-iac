---
name: tiny-stats
description: Manage the TinyStats server on ersa.whatbox.ca. Use when the user asks about server stats, monitoring, or TinyStats issues.
allowed-tools: read, bash, web_search
---

# TinyStats — Server Statistics

> **STUB** — If you are the AI agent picking up this task, you are expected to
> fill in what you learn: server details, common commands, file locations,
> restart procedures, and any known pitfalls. Delete this notice once the
> skill has real substance.

## What is it?

TinyStats is a lightweight server statistics/monitoring dashboard.

## Known facts (as of 2025-06)

- Started via `cron.reboot`: `./tiny-stats/redeploy.sh`
- Binary: Node.js (`/usr/bin/node ~/tiny-stats/server.js`)
- Supervisor config: `~/.config/supervisord/conf.d/tiny-stats.ini`
- Data: `~/tiny-stats/`

## Common tasks (TODO — fill in as learned)

### Check if running

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  "pgrep -f 'tiny-stats/server.js'"
```

### Restart

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  "cd ~/tiny-stats && ./redeploy.sh"
```
