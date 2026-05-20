# Reverse Proxy Configuration

All services route through **Whatbox's shared nginx** (apphost), configured
via their control panel at [cp.whatbox.ca](https://cp.whatbox.ca).

## Proxy Mappings

| Service | Port | Target |
|---|---|---|
| Immich | 2283 | `127.0.0.1:2283` |
| Copyparty | 19720 | `127.0.0.1:19720` |
| Radicale | 5232 | `127.0.0.1:5232` |
| Tiny-Stats | 7828 | `127.0.0.1:7828` |
| Jellyfin | 8096 | Whatbox-managed |
| Deluge | 8112 | Whatbox-managed |

> **TODO:** Fill in your actual subdomains once set up in the CP panel.

## Setup

1. Log into https://cp.whatbox.ca
2. Navigate to **Domain / Proxy Setup**
3. For each service, add an entry:
   - **Source:** your subdomain (e.g. `photos`)
   - **Target:** `127.0.0.1:<port>`
   - **Type:** HTTP proxy
