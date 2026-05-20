# Service Reference

## Immich (Photo/Video Management)
**Type:** podman-compose | **Port:** 2283 | **Config:** ~/immich/
- Data: ~/immich/Photos/, ~/immich/postgres/
- Logs: ~/.supervisor/logs/immich.*
- Proxy: via Whatbox nginx

## Copyparty (File Sharing)
**Type:** Python venv | **Port:** 19720 | **Config:** ~/copyparty/copyparty.conf
- Data: ~/files/
- Logs: ~/.supervisor/logs/copyparty.*
- Proxy: via Whatbox nginx

## Radicale (CalDAV/CardDAV)
**Type:** Python venv | **Port:** 5232 | **Config:** ~/radicale/config
- Data: ~/radicale/collections/
- Logs: ~/.supervisor/logs/radicale.*
- Proxy: via Whatbox nginx

## Tiny-Stats (Dashboard)
**Type:** Node.js | **Port:** 7828 | **Path:** ~/tiny-stats/
- Proxy: via Whatbox nginx

## Whatbox-Managed (pre-installed)
| Service | Port | Notes |
|---|---|---|
| Jellyfin | 8096 | Whatbox provides |
| Deluge + WebUI | 8112 | Whatbox provides |
| Helm file browser | — | Whatbox provides |

## Supervisor
- Config: ~/.config/supervisord/supervisord.conf
- Service defs: ~/.config/supervisord/conf.d/*.ini
- `supervisorctl status` — Show all services
- `supervisorctl restart <service>` — Restart
