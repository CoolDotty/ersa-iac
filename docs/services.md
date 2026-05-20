# Service Reference

## Immich (Photo/Video Management)
| | |
|---|---|
| Type | podman-compose |
| Port | 2283 |
| Config | `~/immich/` |
| Data | `~/immich/Photos/`, `~/immich/postgres/` |
| Logs | `~/.supervisor/logs/immich.*` |
| Restart | `supervisorctl restart immich` |

## Copyparty (File Sharing)
| | |
|---|---|
| Type | Python venv |
| Port | 19720 |
| Config | `~/copyparty/copyparty.conf` |
| Data | `~/files/` |
| Logs | `~/.supervisor/logs/copyparty.*` |
| Restart | `supervisorctl restart copyparty` |

## Radicale (CalDAV/CardDAV)
| | |
|---|---|
| Type | Python venv |
| Port | 5232 |
| Config | `~/radicale/config` |
| Data | `~/radicale/collections/` |
| Logs | `~/.supervisor/logs/radicale.*` |
| Restart | `supervisorctl restart radicale` |

## Tiny-Stats (Dashboard)
| | |
|---|---|
| Type | Node.js |
| Port | 7828 |
| Path | `~/tiny-stats/` |
| Logs | `~/.supervisor/logs/tiny-stats.*` |
| Restart | `supervisorctl restart tiny-stats` |

## Whatbox-Managed (pre-installed)
| Service | Port | Notes |
|---|---|---|
| Jellyfin | 8096 | Managed by Whatbox |
| Deluge + WebUI | 8112 | Managed by Whatbox |
| Helm file browser | — | Managed by Whatbox |

## Supervisor
| | |
|---|---|
| Config | `~/.config/supervisord/supervisord.conf` |
| Service defs | `~/.config/supervisord/conf.d/*.ini` |
| Logs | `~/.supervisor/logs/` |
| Binary | `~/.supervisor/bin/supervisord` |

### Commands
```bash
supervisorctl status                    # Show all services
supervisorctl restart <service>         # Restart a service
supervisorctl tail <service>            # View recent logs
```
