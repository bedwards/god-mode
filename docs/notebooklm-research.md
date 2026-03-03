# NotebookLM Automation — Research Notes
> Researched: 2026-03-03

## Current State (March 2026)
- **No official public API** for consumer NotebookLM
- **Enterprise API** exists (Pre-GA) for NotebookLM Enterprise via Vertex AI
- **Best CLI tool**: `notebooklm-mcp-cli` (v0.3.19) — community-built, reverse-engineers internal APIs

## Winner: notebooklm-mcp-cli

### What It Is
A unified CLI (`nlm`) and MCP server (`notebooklm-mcp`) for programmatic NotebookLM access. Maintained by jacob-bd on GitHub. Jan 2026 unified release merged separate CLI and MCP packages.

### Installation
```bash
pipx install notebooklm-mcp-cli    # recommended
# or: uv tool install notebooklm-mcp-cli
# or: pip install notebooklm-mcp-cli
```

### Authentication
Uses Chrome cookie-based auth (no API key):
```bash
nlm login          # Opens Chrome, logs into Google, saves cookies
nlm doctor         # Verify installation and auth
```
- Requires Google Chrome installed
- Saves profile to `~/.notebooklm-mcp-cli/profiles/<name>/`
- Supports multiple Google accounts via `--profile`
- Auto-refreshes CSRF tokens

### All Available Commands (v0.3.19)

#### Notebook Management
```bash
nlm notebook list                    # List all notebooks
nlm notebook create --title "X"      # Create notebook
nlm notebook delete <id>             # Delete notebook
nlm rename notebook <id> --title "Y" # Rename
nlm share notebook <id>              # Share settings
```

#### Source Management
```bash
nlm source list <notebook-id>        # List sources in notebook
nlm add source <notebook-id> --url "https://..." # Add URL source
nlm add source <notebook-id> --file /path/to/file # Add file source
nlm delete source <notebook-id> <source-id>
nlm content <notebook-id> <source-id>  # Get parsed text
```

#### Studio Artifacts (All 9 Types)
```bash
nlm audio create <notebook-id>       # 🎙️ Audio Overview (podcast-style)
nlm video create <notebook-id>       # 🎬 Video Overview
nlm mindmap create <notebook-id>     # 🧠 Mind Map
nlm report create <notebook-id>      # 📝 Report
nlm flashcards create <notebook-id>  # 🃏 Flashcards
nlm quiz create <notebook-id>        # ❓ Quiz
nlm infographic create <notebook-id> # 📊 Infographic
nlm slides create <notebook-id>      # 📑 Slide Deck
nlm data-table create <notebook-id>  # 📋 Data Table
```

#### Research & Query
```bash
nlm research <notebook-id> "query"   # Research with sources
nlm query <notebook-id> "question"   # Chat with sources
nlm describe <notebook-id>           # AI-generated summary
```

#### AI Tool Integration (MCP Server)
```bash
nlm setup add gemini                 # Configure for Gemini/Antigravity
nlm setup add claude-desktop         # Configure for Claude
nlm setup add cursor                 # Configure for Cursor
nlm setup add json                   # Interactive config generator
```

### MCP Server Usage
The `notebooklm-mcp` binary runs as a Model Context Protocol server, allowing AI tools (Claude, Gemini, Cursor) to directly interact with NotebookLM programmatically.

## Alternatives Evaluated

### AutoContent API
- Paid SaaS service (autocontentapi.com)
- Mimics NotebookLM features via cloud automation
- Not open source, costs money

### NotebookLM Enterprise API
- Official Google API (Pre-GA)
- Enterprise customers only via Vertex AI
- Create/list/delete/share notebooks
- No consumer access

### Browser Automation (Selenium/Playwright)
- DIY approach using browser automation
- Fragile, slow, hard to maintain
- `nlm` does this better under the hood

## Risks & Limitations
> ⚠️ `notebooklm-mcp-cli` uses **undocumented internal APIs**. Could break without notice if Google changes their backend. Use at your own risk.

- Auth requires Chrome (no headless-only option for first login)
- No official support or SLA
- Cookie-based auth may expire and need refresh
- Some features may not work with all account types

## Verdict
**Use `notebooklm-mcp-cli`.** It's the only viable path for CLI/programmatic NotebookLM access. The `nlm` CLI covers all 9 studio artifact types and the MCP server enables AI agent integration. Accept the risk of using undocumented APIs — there's literally no alternative for consumer accounts.
