---
name: radicale
description: Manage the Radicale CalDAV/CardDAV server on ersa.whatbox.ca. Use when the user asks about calendars, contacts, or Radicale issues.
allowed-tools: read, bash, web_search
---

# Radicale — CalDAV / CardDAV Server

> **STUB** — If you are the AI agent picking up this task, you are expected to
> fill in what you learn: server details, common commands, file locations,
> restart procedures, and any known pitfalls. Delete this notice once the
> skill has real substance.

## What is it?

Radicale is a lightweight CalDAV (calendar) and CardDAV (contacts) server.

## Known facts (as of 2025-06)

- Started via `cron.reboot`: `screen -S radicale -d -m ./radicale/radicale.sh`
- Binary: Python module, runs in a virtualenv at `~/radicale/virtualenv/`
- Config: `~/radicale/.config`
- Supervisor config: `~/.config/supervisord/conf.d/radicale.ini`
- Data: `~/radicale/`

## Common tasks (TODO — fill in as learned)

### Check if running

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  "screen -ls | grep radicale"
```

### Restart

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  "screen -S radicale -X quit; sleep 1; cd ~ && screen -S radicale -d -m ./radicale/radicale.sh"
```
