# Reverse Proxy Configuration

Whatbox manages the main nginx reverse proxy via their control panel at cp.whatbox.ca.

## Services

| Service | Port | Proxy Via |
|---|---|---|
| Immich | 2283 | Cloudflare Tunnel |
| Copyparty | 19720 | Cloudflare Tunnel |
| Radicale | 5232 | Cloudflare Tunnel |
| Tiny-Stats | 7828 | Cloudflare Tunnel |
| Jellyfin | 8096 | Whatbox-managed |
| Deluge | 8112 | Whatbox-managed |

Your custom services route through **Cloudflare Tunnel** (`cloudflared`),
while the Whatbox-provided ones (Jellyfin, Deluge, Helm) go through their
shared nginx/apphost.

## Cloudflare Tunnel Config

Tunnel managed in Cloudflare Zero Trust dashboard:
1. Go to https://one.dash.cloudflare.com/
2. Access → Tunnels
3. Find the tunnel for ersa.whatbox.ca
4. Add/edit public hostname → service mappings

## Whatbox CP Proxy Setup (for Whatbox-managed services)

1. Log into https://cp.whatbox.ca
2. Navigate to Domain / Proxy Setup
3. Configure subdomains pointing to your user's ports
