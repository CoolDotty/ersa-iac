---
name: copyparty
description: Manage the Copyparty file-sharing server on ersa.whatbox.ca. Use when the user asks about file uploads, sharing links, or Copyparty issues.
allowed-tools: read, bash, web_search
---

# Copyparty — File Sharing

> **STUB** — If you are the AI agent picking up this task, you are expected to
> fill in what you learn: server details, common commands, file locations,
> restart procedures, and any known pitfalls. Delete this notice once the
> skill has real substance.

## What is it?

Copyparty is a portable file server for sharing files via browser.

## Known facts (as of 2025-06)

- Started via `cron.reboot` in a `screen` session named `copyparty`
- Binary: `~/copyparty/copyparty-sfx.py` (Python)
- Config: `~/copyparty/copyparty.conf`
- Script: `~/copyparty/copyparty.sh`
- Supervisor config: `~/.config/supervisord/conf.d/copyparty.ini`

## Common tasks (TODO — fill in as learned)

### Check if running

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  "screen -ls | grep copyparty"
```

### Restart

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  "screen -S copyparty -X quit; sleep 1; cd ~ && screen -S copyparty -d -m ./copyparty/copyparty.sh"
```
