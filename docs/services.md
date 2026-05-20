# Service Reference

## Immich (Photo/Video Management)
**Type:** podman-compose | **Port:** 2283 | **Config:** ~/immich/
- Data: ~/immich/Photos/, ~/immich/postgres/
- Logs: ~/.supervisor/logs/immich.*

## Jellyfin (Media Server)
**Type:** Native binary | **Port:** 8096 | **Config:** ~/.config/jellyfin/
- Logs: ~/.supervisor/logs/jellyfin.*

## Copyparty (File Sharing)
**Type:** Python venv | **Port:** 19720 | **Config:** ~/copyparty/copyparty.conf
- Data: ~/files/
- Logs: ~/.supervisor/logs/copyparty.*

## Radicale (CalDAV/CardDAV)
**Type:** Python venv | **Port:** 5232 | **Config:** ~/radicale/config
- Data: ~/radicale/collections/
- Logs: ~/.supervisor/logs/radicale.*

## Deluge (Torrent Client)
**Type:** Native | **Ports:** 58846 (RPC), 8112 (web)
- Config: ~/.config/deluge/ | Watch: ~/watch/
- Logs: ~/.supervisor/logs/deluge*

## Tiny-Stats (Dashboard)
**Type:** Node.js | **Port:** 7828 | **Path:** ~/tiny-stats/

## Cloudflare Tunnel
**Type:** Go binary | **Binary:** ~/cloudflared | **Token:** Ansible Vault

## Supervisor
- Config: ~/.config/supervisord/supervisord.conf
- Service defs: ~/.config/supervisord/conf.d/*.ini
- Commands:
  - `supervisorctl status` - Show all services
  - `supervisorctl restart <service>` - Restart a service
