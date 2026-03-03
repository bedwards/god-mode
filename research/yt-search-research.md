# YouTube CLI Search Tools — Research Notes
> Researched: 2026-03-03

## Winner: yt-dlp

**yt-dlp** (v2026.02.04) is the fastest, most reliable CLI tool for YouTube search. No API key needed. Returns results in ~1.5 seconds.

### Key Commands

```bash
# Basic: get URLs only (fastest)
yt-dlp "ytsearch5:your query" --flat-playlist --print url

# With metadata
yt-dlp "ytsearch5:query" --flat-playlist --print "%(title)s | %(url)s | %(duration_string)s"

# JSON output for programmatic use
yt-dlp "ytsearch3:query" --flat-playlist --dump-json

# Control result count with the number after ytsearch
yt-dlp "ytsearch20:query" --flat-playlist --print url  # 20 results
```

### Benchmark Results (2026-03-03)
Query: "Bitwig Studio acoustic folk rock production tips"

| Test | Results | Time |
|------|---------|------|
| Flat search, 5 URLs | 5 | 1.46s |
| Flat search, 10 URLs | 10 | 1.57s |
| Full metadata, 5 | 5 | 1.54s |
| JSON dump, 3 | 3 | 1.39s |

### Useful Fields in JSON Output
- `title` — Video title
- `url` — Full YouTube URL
- `channel` — Channel name
- `duration_string` — Human-readable duration
- `view_count` — View count
- `upload_date` — Upload date (YYYYMMDD)
- `description` — Video description

## Alternatives Evaluated

### youtube-search-python (v1.6.6)
- Python library, no API key
- Web scraping approach
- `pip install youtube-search-python`
- Good for Python integration but adds dependency overhead vs shelling out to yt-dlp

### fast-yt-search
- Claims "fastest YouTube searching Python library"
- Install from GitHub only: `pip install git+https://github.com/justfoolingaround/fast-yt-search`
- Less mature, smaller community

### YouTube Data API v3
- Official Google API
- Requires API key and quota management
- Rate limited (10,000 units/day default)
- More complex setup
- **Not recommended for CLI use** — yt-dlp is simpler and faster

## Verdict
**Use yt-dlp.** It's already installed, absurdly fast, requires no API key, and handles everything from search to metadata extraction to downloading. The `ytsearch` prefix + `--flat-playlist --print url` pattern is the fastest way to get YouTube links from CLI.
