---
name: openclaw-rss
description: Use sfeed to parse RSS/Atom feeds and push updates to OpenClaw. Use when: user wants to monitor RSS feeds and get notifications via OpenClaw, creating an AI-powered RSS reader.
---

# OpenClaw RSS Reader

Use `sfeed` CLI to parse RSS/Atom feeds and integrate with OpenClaw for automated feed monitoring and notifications.

## Installation

```bash
brew tap frankieew/tap && brew install sfeed
```

## Quick Start

### Basic RSS Parsing

```bash
# Parse RSS feed to plain text
curl -sL "FEED_URL" | sfeed | sfeed_plain

# Example: AppInn feed
curl -sL "https://www.appinn.com/feed/" | sfeed | sfeed_plain
```

### Output Formats

| Command | Description |
|---------|-------------|
| `sfeed` | RSS/Atom parser (TAB-separated) |
| `sfeed_plain` | Convert to plain text |
| `sfeed_html` | Convert to HTML |
| `sfeed_json` | Convert to JSON Feed |
| `sfeed_mbox` | Convert to mbox format |

### Common Feeds

| Feed | URL |
|------|-----|
| AppInn | https://www.appinn.com/feed/ |
| Hacker News | https://hnrss.org/frontpage |
| GitHub Releases | https://github.com/chneukirchen/sfeed/releases.atom |
| TechCrunch | https://techcrunch.com/feed/ |

## OpenClaw Integration

### Feed Monitoring Script

Create `~/.sfeed/rss_notify.sh`:

```bash
#!/bin/bash
FEEDS=(
    "https://www.appinn.com/feed/"
    "https://github.com/chneukirchen/sfeed/releases.atom"
)
CACHE_DIR="$HOME/.sfeed/feeds"
mkdir -p "$CACHE_DIR"

for feed in "${FEEDS[@]}"; do
    feed_name=$(echo "$feed" | md5)
    cache_file="$CACHE_DIR/$feed_name"
    content=$(curl -sL "$feed" | sfeed)
    
    if [[ -f "$cache_file" ]]; then
        new_items=$(diff "$cache_file" <(echo "$content") | grep "^>" | sed 's/^> //')
    else
        new_items="$content"
    fi
    
    echo "$content" > "$cache_file"
    
    if [[ -n "$new_items" ]]; then
        echo "$new_items" | sfeed_plain | head -5
    fi
done
```

### Real-time Watch

```bash
#!/bin/bash
FEED_URL="${1:-https://www.appinn.com/feed/}"
POLL_INTERVAL="${2:-300}"

while true; do
    data=$(curl -sL "$FEED_URL" | sfeed)
    title=$(echo "$data" | cut -f2 | head -1)
    echo "[$(date)] $title"
    sleep "$POLL_INTERVAL"
done
```

## sfeed_update Configuration

Create `~/.sfeed/sfeedrc`:

```bash
#!/bin/sh
feeds() {
    feed "appinn" "https://www.appinn.com/feed/" "UTF-8"
    feed "github" "https://github.com/chneukirchen/sfeed/releases.atom" "UTF-8"
}
sfeed_update
sfeed_plain ~/.sfeed/feeds/* > ~/.sfeed/feeds.txt
```

## Filter Examples

```bash
# Get only titles
curl -sL "FEED_URL" | sfeed | cut -f2

# Filter by keyword
curl -sL "https://www.appinn.com/feed/" | sfeed | sfeed_plain | grep -i "OpenClaw"

# Extract URLs only
curl -sL "FEED_URL" | sfeed | cut -f3
```

## Troubleshooting

- **SSL errors**: Use `curl -ksL` instead of `curl -sL`
- **Encoding issues**: Specify encoding in sfeedrc: `feed "name" "url" "GB2312"`
- **Debug**: Run `curl -sL "FEED_URL" | sfeed` to see raw parsed output
