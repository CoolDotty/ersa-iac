---
name: cloudflared
description: Manage the Cloudflare tunnel (cloudflared) on ersa.whatbox.ca. Use when the user asks about the tunnel, x3c.ca routing, or DNS/proxy issues.
allowed-tools: read, bash, web_search
---

# Cloudflared — Cloudflare Tunnel

> **STUB** — If you are the AI agent picking up this task, you are expected to
> fill in what you learn: server details, common commands, file locations,
> restart procedures, and any known pitfalls. Delete this notice once the
> skill has real substance.

## What is it?

Cloudflared tunnels traffic from `ersa.whatbox.ca` through Cloudflare, enabling
the `x3c.ca` domain without exposing ports directly.

## Known facts (as of 2025-06)

- Started via `cron.reboot` in a `screen` session named `cloudflared`
- Binary: `~/cloudflared`
- Runs as: `screen -S cloudflared -d -m ./cloudflared tunnel run --token <token>`

## Common tasks (TODO — fill in as learned)

### Check if running

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  "screen -ls | grep cloudflared"
```

### Restart

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  "screen -S cloudflared -X quit; sleep 1; cd ~ && screen -S cloudflared -d -m ./cloudflared tunnel run"
```
