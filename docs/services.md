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

## AFFiNE (Notes & Knowledge Base)
| | |
|---|---|
| Type | podman-compose |
| Port | 3010 |
| URL | `https://notes.x3c.ca` |
| Config | `~/affine/` |
| Data | `~/affine/postgres/`, `~/affine/storage/`, `~/affine/config/` |
| Logs | `~/.supervisor/logs/affine.*` |
| Restart | `supervisorctl restart affine` |

## n8n (Workflow Automation)
| | |
|---|---|
| Type | podman-compose |
| Port | 5678 |
| Config | `~/n8n/` |
| Data | `~/n8n/.n8n/` (SQLite DB + encryption key), `~/n8n/local-files/` |
| Logs | `~/.supervisor/logs/n8n.*` |
| Restart | `supervisorctl restart n8n` |
| Git Backup | Workflows + credentials auto-backup to private GitHub repo |

## Forgejo (Git Hosting)
| | |
|---|---|
| Type | podman-compose |
| Port | 3100 |
| URL | `https://git.x3c.ca` |
| Config | `~/forgejo/` |
| Data | `~/forgejo/data/` (repos, SQLite DB, config, attachments) |
| Logs | `~/.supervisor/logs/forgejo.*` |
| Restart | `supervisorctl restart forgejo` |

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
