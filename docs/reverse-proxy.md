# Reverse Proxy Configuration

All services route through **Whatbox's shared nginx** (apphost), configured
via their control panel at [cp.whatbox.ca](https://cp.whatbox.ca).

## Proxy Mappings

| Subdomain | Service | Target |
|---|---|---|
| `photos` → `yourdomain` | Immich | `127.0.0.1:2283` |
| `files` → `yourdomain` | Copyparty | `127.0.0.1:19720` |
| `cal` → `yourdomain` | Radicale | `127.0.0.1:5232` |
| `stats` → `yourdomain` | Tiny-Stats | `127.0.0.1:7828` |
| *(whatbox-managed)* | Jellyfin | `127.0.0.1:8096` |
| *(whatbox-managed)* | Deluge | `127.0.0.1:8112` |

## Whatbox CP Setup

1. Log into https://cp.whatbox.ca
2. Navigate to **Domain / Proxy Setup**
3. For each service:
   - **Source:** subdomain (e.g. `photos`)
   - **Target:** `127.0.0.1:<port>`
   - **Type:** HTTP proxy
