# n8n Git Sync

Two-way sync between n8n (on ersa.whatbox.ca) and CoolDotty/n8n-workflows.

## Architecture

```
n8n (publish) ──push──> CoolDotty/n8n-workflows (main)
                                │
                          push to main
                                │
                                ▼
CoolDotty/n8n-workflows ──pull──> n8n (webhook workflow)
```

- **Push**: `sync-to-github.sh` runs every 5 min via cron on the host. Exports published workflows via n8n API, commits changes to GitHub.
- **Pull**: GitHub Action POSTs changed filenames to an n8n webhook workflow, which fetches and imports them.
- **Canonical direction**: GitHub is truth. Local unpublished changes in n8n are skipped (not overwritten).

## Setup

### 1. Create GitHub repo

```bash
gh repo create CoolDotty/n8n-workflows --private --push --source ./n8n-workflows-repo/
```

Or create it manually at https://github.com/new, push the files from `n8n-workflows-repo/`.

### 2. Generate an n8n API key

1. Open https://n8n.x3c.ca/settings/api
2. Create a new API key
3. Save it to the host:

```bash
ssh dotanarchy@ersa.whatbox.ca "mkdir -p ~/.n8n-sync && chmod 700 ~/.n8n-sync"
# paste the key:
echo "<api-key>" | ssh dotanarchy@ersa.whatbox.ca "cat > ~/.n8n-sync/api-key && chmod 600 ~/.n8n-sync/api-key"
```

### 3. Pull-webhook workflow (already created)

The pull-webhook workflow **`n8n Pull Webhook Sync`** exists at:
https://n8n.x3c.ca/workflow/cNyZx8zOIOcEa4WT (ID: `cNyZx8zOIOcEa4WT`)

It has 5 nodes — Webhook → Parse Changed Files → Loop → Fetch from GitHub → Upsert in n8n.
The webhook validates `X-Sync-Token` header built-in (no external credential needed).

**Required — set up credentials in the workflow UI:**

1. Open the workflow at https://n8n.x3c.ca/workflow/FxOmPzb0EmlXS2YI
2. Create three **HTTP Header Auth** credentials:
   | Credential name | Header name | Header value |
   |----------------|-------------|--------------|
   | `SyncTokenAuth` | `X-Sync-Token` | Any random secret (same as `N8N_SYNC_TOKEN` GitHub secret below) |
   | `GitHubTokenAuth` | `Authorization` | `Bearer <your-github-token>` (with repo scope) |
   | `n8nApiKeyAuth` | `X-N8N-API-KEY` | The n8n API key from step 2 |
3. Assign them to the three nodes that need them:
   - **Pull Webhook** → `SyncTokenAuth`
   - **Fetch Workflow from GitHub** → `GitHubTokenAuth`
   - **Upsert Workflow in n8n** → `n8nApiKeyAuth`
4. Save and publish the workflow again

### 4. Exclusion (already configured)

`~/.n8n-sync/config` on the server already has:
```ini
EXCLUDE_IDS="cNyZx8zOIOcEa4WT"
```

`.gitignore` in the repo already has:
```
workflows/cNyZx8zOIOcEa4WT-*.json
```

### 5. Set GitHub secrets

In the repo settings:

| Secret | Value |
|--------|-------|
| `N8N_PULL_WEBHOOK_URL` | `https://n8n.x3c.ca/webhook/pull-sync` (production URL) |
| `N8N_SYNC_TOKEN` | The header auth token from step 3 |

### 6. Clone repo on host and run first export

```bash
ssh dotanarchy@ersa.whatbox.ca
git clone git@github.com:CoolDotty/n8n-workflows.git ~/n8n-workflows
```

Run the sync script manually to seed:

```bash
~/n8n/scripts/sync-to-github.sh
```

### 7. Deploy via ansible

```bash
cd ~/ersa-iac
ansible-playbook ansible/playbooks/deploy.yml
```

This deploys the sync script and sets up the cron job (`*/5 * * * *`).

## Monitoring

- Sync logs: `~/.supervisor/logs/n8n-sync.log`
- Manual run: `~/n8n/scripts/sync-to-github.sh`
- Check cron: `crontab -l | grep n8n-sync`
