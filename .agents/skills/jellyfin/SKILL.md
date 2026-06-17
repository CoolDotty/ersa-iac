---
name: jellyfin
description: Manage Jellyfin media server on ersa.whatbox.ca. Use when the user asks to fix media organization, scan libraries, check show/movie structure, or troubleshoot Jellyfin not picking up content. Covers file layout conventions, API-driven library scans, and common folder-structure fixes.
allowed-tools: read, bash, web_search
---

# Jellyfin Media Server

Jellyfin runs natively on `ersa.whatbox.ca` (not containerized). Media is served
from `/home/dotanarchy/files/` and the API is available on port `25945`.

## Server Details

| What | Value |
|------|-------|
| Host | `ersa.whatbox.ca` |
| SSH | `ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca` |
| API base | `http://localhost:25945` |
| API token | Stored in `~/.jellyfin-api-token` |
| Jellyfin binary | `/usr/bin/jellyfin` |
| Data dir | `~/.config/jellyfin/data` |
| Config dir | `~/.config/jellyfin/config` |
| Log dir | `~/.config/jellyfin/log` |

## Libraries

| Library | Type | Path | ItemId |
|---------|------|------|--------|
| Movies | movies | `/home/dotanarchy/files/Movies` | `f137a2dd21bbc1b99aa5c0f6bf02a805` |
| Shows | tvshows | `/home/dotanarchy/files/Shows` | `a656b907eb3a73532e40e44b968d0225` |
| Anime | tvshows | `/home/dotanarchy/files/Anime` | `0c41907140d802bb58430fed7e2cd79e` |

## Common Operations

### Scan a library

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  "curl -s -X POST 'http://localhost:25945/Library/Refresh?id=<ItemId>' \
   -H \"X-MediaBrowser-Token: \$(cat ~/.jellyfin-api-token)\""
```

Expect an empty (204) response — that means the scan was queued successfully.

### Check scan status

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  'curl -s "http://localhost:25945/Library/VirtualFolders" \
   -H "X-MediaBrowser-Token: $(cat ~/.jellyfin-api-token)" \
   | python3 -c "import sys,json; [print(f\"{v[\"Name\"]}: {v[\"RefreshStatus\"]}\") for v in json.load(sys.stdin)]"'
```

### List all libraries

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  'curl -s "http://localhost:25945/Library/VirtualFolders" \
   -H "X-MediaBrowser-Token: $(cat ~/.jellyfin-api-token)" \
   | python3 -m json.tool'
```

### Search for a show by name

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  'curl -s "http://localhost:25945/Items?SearchTerm=<name>&IncludeItemTypes=Series&Recursive=true" \
   -H "X-MediaBrowser-Token: $(cat ~/.jellyfin-api-token)" \
   | python3 -m json.tool'
```

### Restart Jellyfin

Jellyfin runs as a standalone process (PID varies). To restart:

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  "kill \$(pgrep -f '/usr/bin/jellyfin') && sleep 2 && \
   nohup /usr/bin/jellyfin \
     -d ~/.config/jellyfin/data \
     -C ~/.config/jellyfin/cache \
     -c ~/.config/jellyfin/config \
     -l ~/.config/jellyfin/log \
     -w /usr/share/jellyfin/jellyfin-web \
     --ffmpeg /usr/bin/ffmpeg \
     > /dev/null 2>&1 &"
```

---

## Fixing Media Structure

### TV Show Naming Convention

Jellyfin expects this layout for TV shows:

```
Shows/
  Show Name (Year)/
    Season 01/
      Show Name - S01E01 - Episode Title.ext
      Show Name - S01E02 - Episode Title.ext
    Season 02/
      Show Name - S02E01 - Episode Title.ext
```

Alternative format (no year, episode title optional):
```
Shows/
  Show Name/
    Season 01/
      Show Name S01E01.ext
```

Episode files **must** contain `SxxEyy` in the filename. Common patterns:
- `The Last of Us S01E01.mp4` ✓
- `The.Last.of.Us.S01E01.1080p.mp4` ✓
- `Episode 1.mp4` ✗ (won't match)

### Common Mistake: Seasons as Separate Shows

**Problem:** Two top-level folders `Show Name Season 1` and `Show Name Season 2` get treated as two separate shows.

**Fix:** Nest them under a single show folder with `Season 01` / `Season 02` subfolders:

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca "
cd ~/files/Shows
mkdir -p 'Show Name (Year)/Season 01' 'Show Name (Year)/Season 02'
mv 'Show Name Season 1/'*.mp4 'Show Name (Year)/Season 01/'
mv 'Show Name Season 2/'*.mp4 'Show Name (Year)/Season 02/'
rmdir 'Show Name Season 1' 'Show Name Season 2'
# Then rescan the Shows library (see above)
"
```

### Movie Naming Convention

```
Movies/
  Movie Name (Year)/
    Movie Name (Year).ext
```

Or flat:
```
Movies/
  Movie Name (Year).ext
```

## Checking File Layout Before Fixing

```bash
ssh -i ~/.ssh/dot dotanarchy@ersa.whatbox.ca \
  "find ~/files/Shows -maxdepth 1 -type d && echo '---' && find ~/files/Shows -maxdepth 3 -type f -name '*.mp4' | sort"
```

## Reference

- Jellyfin docs: https://jellyfin.org/docs/general/server/media/shows
- TV naming guide: https://jellyfin.org/docs/general/server/media/shows#shows-naming
