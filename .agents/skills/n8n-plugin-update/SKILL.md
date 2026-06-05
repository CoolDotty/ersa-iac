---
name: n8n-plugin-update
description: Updates an n8n community plugin installed via GitHub in the n8n podman container on ersa.whatbox.ca. Use when the user asks to update, upgrade, or bump an n8n plugin, community node, or custom extension.
allowed-tools: read, bash, web_search, edit
---

# n8n Plugin Update

Updates a community plugin in the n8n container on `ersa.whatbox.ca` and pins
the new version/commit in the ansible config.

## Prerequisites

- Repo root: `ansible/files/n8n/custom-package.json` lists the plugin as a
  `github:owner/repo` dependency.
- The n8n container mounts `/home/dotanarchy/n8n/.n8n` → `/root/.n8n`, so
  `npm update` inside the container writes back to the host volume.

## Process

### 1. Check what's installed vs latest

```bash
# Installed version
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  "podman exec n8n cat /root/.n8n/custom/node_modules/<plugin-name>/package.json"

# Latest commit on GitHub
curl -s "https://api.github.com/repos/<owner>/<repo>/commits/main" \
  | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['sha']); print(d['commit']['message'])"
```

### 2. Update in the container

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  "podman exec n8n sh -c 'cd /root/.n8n/custom && npm update <plugin-name>'"
```

### 3. Restart n8n

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca "podman restart n8n"
```

Wait a few seconds, then verify:

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  "podman ps --filter name=n8n --format '{{.Names}} {{.Status}}'"
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  "curl -s -o /dev/null -w '%{http_code}' http://localhost:5678/healthz"
```

### 4. Pin the commit in ansible config

Edit `ansible/files/n8n/custom-package.json` and append `#<full-sha>` to the
GitHub URL:

```diff
-    "<plugin-name>": "github:<owner>/<repo>"
+    "<plugin-name>": "github:<owner>/<repo>#<full-commit-sha>"
```

## References

- Container: `n8n` (podman, image `docker.io/n8nio/n8n:stable`)
- Custom extensions path: `/root/.n8n/custom/` (container) → `/home/dotanarchy/n8n/.n8n/custom/` (host)
- Ansible config: `ansible/files/n8n/custom-package.json`
- n8n health check: `http://localhost:5678/healthz`
