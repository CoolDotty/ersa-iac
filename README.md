# ersa-iac

Infrastructure as Code for `ersa.whatbox.ca` — a Whatbox seedbox VPS running
Gentoo Linux with user-scoped services.

The root domain `x3c.ca` is hosted on GitHub Pages from
[`CoolDotty/x3c.ca`](https://github.com/CoolDotty/x3c.ca).

## Services

| Service | Port | Type | Config |
|---|---|---|---|
| **Your services (supervisord-managed)** | | | |
| [Immich](https://immich.app) | 2283 | podman-compose | `ansible/files/immich/` |
| [Copyparty](https://github.com/9001/copyparty) | 19720 | Python (venv) | service config lives on VPS |
| [Radicale](https://radicale.org) | 5232 | Python (venv) | service config lives on VPS |
| Tiny-Stats | 7828 | Node.js | service config lives on VPS |
| [n8n](https://n8n.io) | 5678 | podman-compose | `ansible/files/n8n/` |
| [Karakeep](https://karakeep.app) | 5272 | podman-compose | `ansible/files/karakeep/` |
| **Whatbox-managed (pre-installed)** | | | |
| Jellyfin | 8096 | Native | via Whatbox CP panel |
| Deluge + WebUI | 8112 | Native | via Whatbox CP panel |
| Helm file browser | — | Native | via Whatbox CP panel |

## Architecture

```
    Whatbox Shared Nginx
   (configured via CP panel)
            │
   user@ersa.whatbox.ca
   ┌──────────────────────────────────────┐
   │            supervisord                 │
   │  ┌────────┬────────┬────────┬──────┬─────┐ │
   │  │ immich │  n8n   │karakeep│python│ node│ │
   │  │ compose│ compose│compose │venvs │  js │ │
   │  └────────┴────────┴────────┴──────┴─────┘ │
   └──────────────────────────────────────┘
```

## Usage

```bash
# 1. Bootstrap (one-time) — install supervisor, create dirs
ansible-playbook ansible/playbooks/bootstrap.yml

# 2. Deploy — push configs, update services
ansible-playbook ansible/playbooks/deploy.yml
```

Or use the convenience scripts:
```bash
./scripts/bootstrap.sh
./scripts/deploy.sh
```

## What This Manages

This repo handles **process management** only — it ensures your custom
services stay running and restart on crash or reboot via `supervisord`.

**Config files** for each service (.env, copyparty.conf, radicale config)
live directly on the VPS and are not versioned here. Back them up separately.

## Data

Your data stays on the VPS — never in Git:

| In Git (Config) | On VPS (Data) |
|---|---|
| `docker-compose.yml` (n8n, Immich) | `~/immich/Photos/` |
| Supervisor `.ini` files | `~/immich/postgres/` |
| `.env` template (n8n) | `~/n8n/.n8n/` (SQLite DB + encryption key) |
| | `~/files/` |
| | All 11TB+ mpath drives |

## Reverse Proxy

All services route through Whatbox's shared nginx. Configure subdomain →
port mappings at [whatbox.ca/manage/domain](https://whatbox.ca/manage/domain) → Domain/Proxy Setup.

See [`docs/reverse-proxy.md`](docs/reverse-proxy.md) for the port reference.
