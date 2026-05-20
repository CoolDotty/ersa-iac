# Reverse Proxy Configuration

Whatbox runs a shared nginx that reverse-proxies traffic to your user services.
This is configured through the **Whatbox Control Panel** at cp.whatbox.ca.

## Current Proxy Mappings

| Domain / Subdomain | Target | Service |
|---|---|---|
| *(via Cloudflare Tunnel)* | `127.0.0.1:2283` | Immich |
| *(via Cloudflare Tunnel)* | `127.0.0.1:19720` | Copyparty |
| *(via Cloudflare Tunnel)* | `127.0.0.1:5232` | Radicale |
| *(via Cloudflare Tunnel)* | `127.0.0.1:7828` | Tiny-Stats |
| *(via Cloudflare Tunnel)* | `127.0.0.1:8096` | Jellyfin |

> TODO: Fill in actual subdomain/domain mappings from your Whatbox CP panel.

## Port Reference

| Service | Port | Proxy Via |
|---|---|---|
| Immich | 2283 | Whatbox Nginx / Cloudflare |
| Jellyfin | 8096 | Cloudflare Tunnel |
| Copyparty | 19720 | Cloudflare Tunnel |
| Radicale | 5232 | Cloudflare Tunnel |
| Deluge Web | 8112 | Cloudflare Tunnel |
| Tiny-Stats | 7828 | Cloudflare Tunnel |
