#!/usr/bin/env python3
"""
test_yt_python.py — Compare Python YouTube search libraries vs yt-dlp CLI.

Tests:
  1. yt-dlp (subprocess) — baseline
  2. youtube-search-python (pip install youtube-search-python)
  3. fast-yt-search (pip install git+https://github.com/justfoolingaround/fast-yt-search)

Usage:
  python3 scripts/test_yt_python.py [query]
"""

import json
import os
import subprocess
import sys
import time

QUERY = sys.argv[1] if len(sys.argv) > 1 else "best programming tutorials 2025"
NUM_RESULTS = 5
RESULTS_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "results")
os.makedirs(RESULTS_DIR, exist_ok=True)

results = {}


def banner(title: str):
    print(f"\n{'='*50}")
    print(f"  {title}")
    print(f"{'='*50}")


# ──────────────────────────────────────────────
# Test 1: yt-dlp via subprocess
# ──────────────────────────────────────────────
def test_ytdlp():
    banner("Test 1: yt-dlp (subprocess)")
    start = time.time()
    try:
        proc = subprocess.run(
            [
                "yt-dlp",
                f"ytsearch{NUM_RESULTS}:{QUERY}",
                "--flat-playlist",
                "--dump-json",
                "--no-warnings",
            ],
            capture_output=True,
            text=True,
            timeout=30,
        )
        videos = []
        for line in proc.stdout.strip().split("\n"):
            if line:
                d = json.loads(line)
                videos.append(
                    {
                        "title": d.get("title", ""),
                        "url": d.get("url", ""),
                        "channel": d.get("channel", ""),
                    }
                )
        elapsed = time.time() - start
        print(f"⏱  Time: {elapsed:.2f}s")
        print(f"📦 Results: {len(videos)}")
        for v in videos:
            print(f"  • {v['title'][:60]} — {v['url']}")
        results["yt-dlp"] = {
            "time": round(elapsed, 2),
            "count": len(videos),
            "videos": videos,
            "status": "success",
        }
    except Exception as e:
        elapsed = time.time() - start
        print(f"❌ Error: {e}")
        results["yt-dlp"] = {"time": round(elapsed, 2), "status": "error", "error": str(e)}


# ──────────────────────────────────────────────
# Test 2: youtube-search-python
# ──────────────────────────────────────────────
def test_youtube_search_python():
    banner("Test 2: youtube-search-python")
    start = time.time()
    try:
        from youtubesearchpython import VideosSearch

        search = VideosSearch(QUERY, limit=NUM_RESULTS)
        raw = search.result()
        videos = []
        for v in raw.get("result", []):
            videos.append(
                {
                    "title": v.get("title", ""),
                    "url": v.get("link", ""),
                    "channel": v.get("channel", {}).get("name", ""),
                }
            )
        elapsed = time.time() - start
        print(f"⏱  Time: {elapsed:.2f}s")
        print(f"📦 Results: {len(videos)}")
        for v in videos:
            print(f"  • {v['title'][:60]} — {v['url']}")
        results["youtube-search-python"] = {
            "time": round(elapsed, 2),
            "count": len(videos),
            "videos": videos,
            "status": "success",
        }
    except ImportError:
        elapsed = time.time() - start
        print("⚠️  Not installed. Run: pip install youtube-search-python")
        results["youtube-search-python"] = {
            "time": round(elapsed, 2),
            "status": "not_installed",
        }
    except Exception as e:
        elapsed = time.time() - start
        print(f"❌ Error: {e}")
        results["youtube-search-python"] = {
            "time": round(elapsed, 2),
            "status": "error",
            "error": str(e),
        }


# ──────────────────────────────────────────────
# Test 3: fast-yt-search
# ──────────────────────────────────────────────
def test_fast_yt_search():
    banner("Test 3: fast-yt-search")
    start = time.time()
    try:
        from fast_yt_search import search as fyt_search

        raw = list(fyt_search(QUERY))[:NUM_RESULTS]
        videos = []
        for v in raw:
            videos.append(
                {
                    "title": v.get("title", str(v)),
                    "url": v.get("url", v.get("link", "")),
                }
            )
        elapsed = time.time() - start
        print(f"⏱  Time: {elapsed:.2f}s")
        print(f"📦 Results: {len(videos)}")
        for v in videos:
            print(f"  • {v['title'][:60]} — {v['url']}")
        results["fast-yt-search"] = {
            "time": round(elapsed, 2),
            "count": len(videos),
            "videos": videos,
            "status": "success",
        }
    except ImportError:
        elapsed = time.time() - start
        print(
            "⚠️  Not installed. Run: pip install git+https://github.com/justfoolingaround/fast-yt-search"
        )
        results["fast-yt-search"] = {
            "time": round(elapsed, 2),
            "status": "not_installed",
        }
    except Exception as e:
        elapsed = time.time() - start
        print(f"❌ Error: {e}")
        results["fast-yt-search"] = {
            "time": round(elapsed, 2),
            "status": "error",
            "error": str(e),
        }


# ──────────────────────────────────────────────
# Run all tests
# ──────────────────────────────────────────────
if __name__ == "__main__":
    print(f'🔍 Query: "{QUERY}"')
    print(f"📊 Requesting {NUM_RESULTS} results per tool\n")

    test_ytdlp()
    test_youtube_search_python()
    test_fast_yt_search()

    # Summary
    banner("COMPARISON SUMMARY")
    print(f"{'Tool':<25} {'Time (s)':<10} {'Results':<10} {'Status':<15}")
    print("-" * 60)
    for tool, data in results.items():
        print(
            f"{tool:<25} {data['time']:<10} {data.get('count', 'N/A'):<10} {data['status']:<15}"
        )

    # Save results
    outfile = os.path.join(RESULTS_DIR, "python_comparison.json")
    with open(outfile, "w") as f:
        json.dump(
            {"query": QUERY, "num_results": NUM_RESULTS, "results": results}, f, indent=2
        )
    print(f"\n💾 Results saved to: {outfile}")
