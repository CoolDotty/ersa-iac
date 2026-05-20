# ersa-iac

Infrastructure as Code for `ersa.whatbox.ca` — a Whatbox seedbox VPS running
Gentoo Linux with user-scoped services.

## Services

| Service | Port | Type | Config |
|---|---|---|---|
| [Immich](https://immich.app) | 2283 | Docker (podman-compose) | `ansible/files/immich/` |
| [Jellyfin](https://jellyfin.org) | 8096 | Native binary | supervisord managed |
| [Copyparty](https://github.com/9001/copyparty) | 19720 | Python (venv) | `ansible/templates/copyparty/` |
| [Radicale](https://radicale.org) | 5232 | Python (venv) | `ansible/templates/radicale/` |
| [Deluge](https://deluge-torrent.org) | 8112 | Native | supervisord managed |
| Tiny-Stats | 7828 | Node.js | supervisord managed |
| Cloudflare Tunnel | — | Go binary | supervisord managed |

## Architecture

```
         Cloudflare
       (cloudflared)
            │
    Whatbox Shared Nginx
   (configured via CP panel)
            │
   user@ersa.whatbox.ca
   ┌─────────────────────┐
   │     supervisord      │
   │  ┌──────┬──────┬───┐ │
   │  │immich│native│node│ │
   │  │compose│binals│js │ │
   │  └──────┴──────┴───┘ │
   └─────────────────────┘
```

## Quick Start

```bash
# 1. Fill in secrets
cp ansible/vars/vault.yml.example ansible/vars/vault.yml
# Edit vault.yml with your tokens/passwords

# 2. Bootstrap (one-time): install supervisor, create dirs
./scripts/bootstrap.sh

# 3. Deploy: push all configs, restart services
./scripts/deploy.sh
```

## Structure

```
ersa-iac/
├── ansible/
│   ├── ansible.cfg          # Ansible config
│   ├── inventory.yml        # Host: ersa.whatbox.ca
│   ├── playbooks/
│   │   ├── bootstrap.yml    # One-time setup
│   │   └── deploy.yml       # Config + service deploy
│   ├── files/
│   │   ├── immich/          # Static compose files
│   │   └── supervisord/     # Supervisor defs + config
│   ├── templates/           # Jinja2 templates
│   └── vars/
│       ├── main.yml         # Service definitions
│       └── vault.yml.example # Secrets template
├── docs/
│   ├── reverse-proxy.md     # Whatbox CP proxy mappings
│   └── services.md          # Per-service reference
├── scripts/
│   ├── bootstrap.sh         # Bootstrap runner
│   ├── deploy.sh            # Deploy runner
│   └── vps-cron.sh          # @reboot supervisor starter
├── .gitignore
└── README.md
```

## Data vs Config

Your **data stays on the VPS** — never in Git:

| In Git (Config) | On VPS (Data) |
|---|---|
| `docker-compose.yml` | `~/immich/Photos/` |
| `copyparty.conf` | `~/files/` |
| Supervisor `.ini` files | `~/immich/postgres/` |
| `immich.env.j2` (template) | All 11TB+ mpath drives |

## Remote Repo

```bash
git remote add origin <your-repo-url>
git push -u origin master
```
