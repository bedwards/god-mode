# LLM Context — God Mode Project
> Last updated: 2026-03-03T16:46:00-06:00

## Project Purpose
Multi-topic AI-powered research and content generation platform using CLI tools.

## Environment
- macOS, Antigravity IDE (Google)
- Python 3.12.8
- yt-dlp 2026.02.04 (installed, tested, working)
- nlm 0.3.19 / notebooklm-mcp-cli (installed via pipx, NOT yet authenticated)
- uv, pipx available
- Git repo at /Users/bedwards/vibe/god-mode

## Tool Status
| Tool | Status | Notes |
|------|--------|-------|
| yt-dlp | ✅ Working | 5 URLs in 1.46s via `ytsearch` |
| nlm | ⚠️ Needs auth | Run `nlm login` to authenticate via Chrome |
| youtube-search-python | ⚠️ Installed to wrong Python | pip3 → Python 3.11, scripts use 3.12 |
| fast-yt-search | ❌ Not installed | GitHub-only install |

## Key Commands
```bash
# YouTube search
yt-dlp "ytsearchN:query" --flat-playlist --print url
yt-dlp "ytsearchN:query" --flat-playlist --dump-json

# NotebookLM
nlm login                           # Auth via Chrome
nlm notebook list                   # List notebooks
nlm notebook create --title "X"     # Create notebook
nlm audio create <notebook-id>      # Audio overview
nlm video create <notebook-id>      # Video overview
nlm mindmap create <notebook-id>    # Mind map
nlm report create <notebook-id>     # Report
nlm flashcards create <notebook-id> # Flashcards
nlm quiz create <notebook-id>       # Quiz
nlm infographic create <notebook-id> # Infographic
nlm slides create <notebook-id>     # Slides
nlm data-table create <notebook-id> # Data table
```

## Current Topics
1. **music-production-bitwig** — Acoustic/folk/indie rock in Bitwig Studio

## Auth State
- Google account: NOT authenticated
- nlm profile: none (run `nlm login`)

## What Needs Doing Next
1. Run `nlm login` (requires interactive Chrome)
2. Create NotebookLM notebook for Bitwig music production topic
3. Add YouTube research links as sources
4. Generate all 9 artifact types
5. Add more research topics as needed
