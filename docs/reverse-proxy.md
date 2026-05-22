# Reverse Proxy Configuration

All services route through **Whatbox's shared nginx** (apphost), configured
via their control panel at [whatbox.ca/manage/domain](https://whatbox.ca/manage/domain) →
**Domain / Proxy Setup**.

## Proxy Mappings

| App | Subdomain | Target | WebSockets |
|---|---|---|---|
| [Immich](https://immich.app) | `photos` | `127.0.0.1:2283` | On |
| [Copyparty](https://github.com/9001/copyparty) | `files` | `127.0.0.1:19720` | On |
| [Radicale](https://radicale.org) | `cal` | `127.0.0.1:5232` | Off |
| [Tiny-Stats](https://github.com/dot/) | `stats` | `127.0.0.1:7828` | On |
| [n8n](https://n8n.io) | `n8n` | `127.0.0.1:5678` | On |
| Jellyfin | *(whatbox-managed)* | `127.0.0.1:8096` | On |
| Deluge | *(whatbox-managed)* | `127.0.0.1:8112` | Off |

**Immich** needs WebSockets for live upload progress and notifications.

**Copyparty** uses WebSockets for file browsing and transfer progress.

**Tiny-Stats** uses a WebSocket server to push live CPU/RAM/disk charts to
the dashboard — without it the page loads but stays blank.

**n8n** uses WebSockets for live workflow execution updates and UI notifications.

## Whatbox CP Setup

1. Log into https://whatbox.ca/manage/domain
2. Navigate to **Domain / Proxy Setup**
3. For each service add an entry:
   - **Source:** subdomain (e.g. `photos`)
   - **Target:** `127.0.0.1:<port>`
   - **Type:** HTTP proxy
   - **WebSockets:** toggle on for Immich, Copyparty, and Tiny-Stats

## DNS

Point your domain's subdomains to the target shown in the Whatbox panel:

1. Go to https://whatbox.ca/manage/domain
2. Look for your **Server Hostname** or **IP** — use that as your DNS target
3. Create **CNAME** records (or A records if using an IP):

```
*.yourdomain.com → <target from Whatbox panel>
```

Or individual subdomains:

```
photos.yourdomain.com → <target from Whatbox panel>
files.yourdomain.com  → <target from Whatbox panel>
cal.yourdomain.com    → <target from Whatbox panel>
stats.yourdomain.com  → <target from Whatbox panel>
n8n.yourdomain.com    → <target from Whatbox panel>
```
