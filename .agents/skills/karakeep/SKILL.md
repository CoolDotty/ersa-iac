---
name: karakeep
description: Manage the Karakeep bookmark manager running in podman on ersa.whatbox.ca. Use when the user asks about bookmarks, archiving, or Karakeep issues.
allowed-tools: read, bash, web_search
---

# Karakeep — Bookmark Manager

## What is it?

Karakeep (formerly Hoarder) is a self-hosted bookmark manager with archiving.
Runs in podman with Meilisearch and a headless Chrome for page capture.

## Server Details

- Domain: `keep.x3c.ca`
- Container group: `karakeep_web`, `karakeep_chrome`, `karakeep_meilisearch`, `karakeep_infra`
- Image: `ghcr.io/karakeep-app/karakeep:release`
- Port: `127.0.0.1:5272` → `3000` (container internal)
- Data: `~/karakeep/`
  - SQLite DB: `~/karakeep/data/db.db`
  - Queue DB: `~/karakeep/data/queue.db`
  - Assets: `~/karakeep/data/assets/`
- Ansible config: `ansible/files/karakeep/`
- Supervisor config: `~/.config/supervisord/conf.d/karakeep.ini`
- Admin user email: `nxlgfkqb@x3c.ca`
- API key: stored in agent chat context / user settings page on keep.x3c.ca

## AI Inference Setup

- Provider: **Google Gemini** (via OpenAI-compatible endpoint)
- Base URL: `https://generativelanguage.googleapis.com/v1beta`
- Text model: `gemini-3.1-flash-lite`
- Image model: `gemini-3.1-flash-lite`
- API key: stored in container env `OPENAI_API_KEY`
- Rate limit: Gemini free tier is ~10 requests per minute — can get 429 errors on bursty inference
- Worker count: `INFERENCE_NUM_WORKERS=1` (default, only 1 concurrent inference job)

## Database Access

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca
cd ~/karakeep
sqlite3 data/db.db
```

Key tables:
- `user` — users (note: table name is `user` not `users`)
- `apiKey` — API keys (`id`, `name`, `keyId`, `keyHash`, `userId`, `scopes`)
- `bookmarks` — all bookmarks
- `bookmarkLinks` — link-type bookmark crawl data (has `crawlStatus` field)
- `session` — web sessions (`sessionToken`, `userId`, `expires`)

## Container Info

```bash
# List containers
podman ps --filter name=karakeep

# Check environment
podman exec karakeep_web env

# View logs
podman logs karakeep_web --tail 100

# Restart
podman restart karakeep_web
```

The container is a single combined web+worker image. The web app runs Next.js with bundled server.js at `/app/apps/web/server.js`. All packages are bundled into the binary — no separate dist folders.

## API Access (tRPC)

All admin endpoints are tRPC mutations. To call them via curl, use the format:

```bash
curl -s -X POST "https://keep.x3c.ca/api/trpc/<PROCEDURE>?batch=1" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <API_KEY>" \
  -d '{"0":{"json":{...}}}'
```

For GET queries:
```bash
curl -s -X GET "https://keep.x3c.ca/api/trpc/<PROCEDURE>?batch=1" \
  -H "Authorization: Bearer <API_KEY>"
```

### Useful Admin Procedures

| Procedure | Type | Input | Description |
|---|---|---|---|
| `admin.recrawlLinks` | mutation | `{"crawlStatus": "all"\|"failure"\|"pending"\|"success", "runInference": true\|false}` | Recrawl link bookmarks with optional inference |
| `admin.reRunInferenceOnAllBookmarks` | mutation | `{"type": "tag"\|"summarize", "status": "all"\|"failure"\|"pending"\|"success"}` | Regenerate AI tags or summaries |
| `admin.reindexAllBookmarks` | mutation | `{}` | Rebuild Meilisearch search index |
| `admin.backgroundJobsStats` | query | — | Get queue stats (queued/pending/failed counts) |
| `admin.checkConnections` | query | — | Check if search, browser, queue are connected |
| `admin.adminRetagBookmark` | mutation | `{"bookmarkId": "..."}` | Retag a single bookmark |
| `admin.adminRecrawlBookmark` | mutation | `{"bookmarkId": "..."}` | Recrawl a single bookmark |

## Common Tasks

### Restart

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  "podman restart karakeep_web"
```

### Check logs

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  "podman logs karakeep_web --tail 100"
```

### Trigger a full recrawl of all links with AI inference

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  'curl -s -X POST "https://keep.x3c.ca/api/trpc/admin.recrawlLinks?batch=1" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer <API_KEY>" \
    -d '{"0":{"json":{"crawlStatus":"all","runInference":true}}}'
```

### Trigger AI tag regeneration for all bookmarks

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  'curl -s -X POST "https://keep.x3c.ca/api/trpc/admin.reRunInferenceOnAllBookmarks?batch=1" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer <API_KEY>" \
    -d '{"0":{"json":{"type":"tag","status":"all"}}}'
```

### Retry failed inference

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  'curl -s -X POST "https://keep.x3c.ca/api/trpc/admin.reRunInferenceOnAllBookmarks?batch=1" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer <API_KEY>" \
    -d '{"0":{"json":{"type":"tag","status":"failure"}}}'
```

### Check queue stats

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  'curl -s -X GET "https://keep.x3c.ca/api/trpc/admin.backgroundJobsStats?batch=1" \
    -H "Authorization: Bearer <API_KEY>" | python3 -m json.tool'
```

## Known Pitfalls

- **Gemini 429 rate limits**: The free Gemini API key is limited to ~10 RPM. With `INFERENCE_NUM_WORKERS=1`, the single worker still processes ~20-30 inference calls per minute, triggering 429 errors. Retry failed ones in small batches, or switch to a local Ollama model for unlimited inference.
- **No built-in rate limiter**: Karakeep has no `INFERENCE_RATE_LIMIT` config. To throttle, you'd need a rate-limiting proxy or a different API provider.
- **Container is ephemeral**: Code changes inside the container are lost on restart. Config changes via env vars survive. Ansible config is the source of truth for the compose setup.
- **Supervisor autorestart**: The supervisor `karakeep.ini` has `autorestart=true`, so if the containers crash, supervisor will restart them via `podman-compose down && podman-compose up -d`. However, podman-compose's `up -d` can fail if the pod/containers already exist — it falls through to `podman start`. If containers are truly gone (e.g., after a `podman system prune`), the compose will create them fresh.
