# Service Reference

## Immich (Photo/Video Management)
**Type:** podman-compose | **Port:** 2283 | **Config:** ~/immich/
- Data: ~/immich/Photos/, ~/immich/postgres/
- Logs: ~/.supervisor/logs/immich.*

## Copyparty (File Sharing)
**Type:** Python venv | **Port:** 19720 | **Config:** ~/copyparty/copyparty.conf
- Data: ~/files/
- Logs: ~/.supervisor/logs/copyparty.*

## Radicale (CalDAV/CardDAV)
**Type:** Python venv | **Port:** 5232 | **Config:** ~/radicale/config
- Data: ~/radicale/collections/
- Logs: ~/.supervisor/logs/radicale.*

## Tiny-Stats (Dashboard)
**Type:** Node.js | **Port:** 7828 | **Path:** ~/tiny-stats/

## Cloudflare Tunnel
**Type:** Go binary | **Binary:** ~/cloudflared | **Token:** Ansible Vault

## Whatbox-Managed (not in IaC)
- Jellyfin (8096) — pre-installed by Whatbox
- Deluge + WebUI (8112) — pre-installed by Whatbox
- Helm file browser — pre-installed by Whatbox
- Prowlarr (28146) — pre-installed by Whatbox (not in use)

## Supervisor
- Config: ~/.config/supervisord/supervisord.conf
- Service defs: ~/.config/supervisord/conf.d/*.ini
- Commands:
  - `supervisorctl status` — Show all services
  - `supervisorctl restart <service>` — Restart a service
