# 🎯 God Mode — AI-Powered Research & Content Hub

Multi-topic research platform powered by CLI automation, YouTube search, and Google NotebookLM. 
All tools tested, documented, and ready for LLM-assisted workflows.

## Quick Start

```bash
# YouTube search (returns URLs in ~1.5s)
yt-dlp "ytsearch5:your query" --flat-playlist --print url

# YouTube search with metadata
yt-dlp "ytsearch5:your query" --flat-playlist --print "%(title)s | %(url)s | %(duration_string)s"

# NotebookLM CLI
nlm login                   # One-time Chrome auth
nlm notebook list           # List all notebooks
nlm notebook create --title "My Research"
nlm audio create <notebook>  # Generate audio overview
```

## Project Structure

```
god-mode/
├── README.md                           # You are here
├── .memory/
│   └── context.md                      # LLM memory — current state & key facts
├── scripts/
│   ├── test_yt_search.sh               # yt-dlp search benchmark
│   ├── test_yt_python.py               # Python YouTube search comparison
│   ├── test_notebooklm.sh              # NotebookLM CLI test suite
│   └── nlm_all_artifacts.sh            # Generate ALL NotebookLM artifact types
├── docs/
│   ├── yt-search-research.md           # YouTube CLI tools research
│   └── notebooklm-research.md          # NotebookLM automation research
├── topics/
│   └── music-production-bitwig/        # First topic
│       ├── README.md                   # Topic overview & goals
│       ├── research/                   # Research notes & findings
│       ├── prompts/                    # Curated prompts for content gen
│       ├── scripts/                    # Topic-specific automation
│       └── results/                    # Generated artifacts & outputs
└── results/                            # Global test outputs
```

## Tools Tested

| Tool | Version | Purpose | Speed | Verdict |
|------|---------|---------|-------|---------|
| **yt-dlp** | 2026.02.04 | YouTube search & metadata | 5 URLs in 1.5s | ⭐ **Winner** — fast, reliable, no API key |
| **nlm** | 0.3.19 | NotebookLM automation | — | ⭐ **Best option** — full artifact support |
| youtube-search-python | 1.6.6 | Python YouTube search | — | Good alternative |
| fast-yt-search | — | Python YouTube search | — | Not yet tested |

## NotebookLM Artifact Types

The `nlm` CLI supports generating all studio artifact types:

| Artifact | Command | Description |
|----------|---------|-------------|
| 🎙️ Audio Overview | `nlm audio create` | AI podcast-style explainer/summary |
| 🎬 Video Overview | `nlm video create` | AI video summary |
| 🧠 Mind Map | `nlm mindmap create` | Visual knowledge map |
| 📝 Report | `nlm report create` | Detailed written report |
| 🃏 Flashcards | `nlm flashcards create` | Study flashcards |
| ❓ Quiz | `nlm quiz create` | Knowledge quiz |
| 📊 Infographic | `nlm infographic create` | Visual infographic |
| 📑 Slides | `nlm slides create` | Slide deck |
| 📋 Data Table | `nlm data-table create` | Structured data extraction |

## Current Topics

### 🎸 Music Production with Bitwig Studio
Making acoustic, folk, folk rock, indie rock, and alt-country music in Bitwig Studio — a DAW known for ambient/EDM. Tips, tricks, plugins, FX, instruments, MIDI, AI tools, and ABC format for polished professional results.

→ See [topics/music-production-bitwig/README.md](topics/music-production-bitwig/README.md)

## Setup

```bash
# YouTube search (already installed)
yt-dlp --version

# NotebookLM CLI
pipx install notebooklm-mcp-cli
nlm login                    # Opens Chrome for Google auth
nlm doctor                   # Verify installation

# Optional: Add as MCP server to AI tools
nlm setup add gemini         # For Antigravity/Gemini
nlm setup add claude-desktop # For Claude
```
