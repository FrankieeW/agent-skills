---
name: openclaw-rss
description: >
  Use sfeed to parse RSS/Atom feeds and push updates to OpenClaw. 
  Use when: user wants to monitor RSS feeds and get notifications via OpenClaw,
  creating an AI-powered RSS reader with automated notifications.
---

# OpenClaw RSS Reader

This skill integrates sfeed (RSS/Atom parser) with OpenClaw for automated feed monitoring and notifications.

## Installation

### Install sfeed via Homebrew Tap

```bash
# Tap the custom formula
brew tap frankieew/tap

# Install sfeed
brew install sfeed
```

### Verify Installation

```bash
# List all sfeed binaries
ls /opt/homebrew/Cellar/sfeed/*/bin/

# Test sfeed
curl -sL "https://www.appinn.com/feed/" | sfeed | sfeed_plain
```

## Quick Start

### 1. Basic RSS to Plain Text

```bash
# Parse RSS feed to plain text
curl -sL "FEED_URL" | sfeed | sfeed_plain

# Example: AppInn feed
curl -sL "https://www.appinn.com/feed/" | sfeed | sfeed_plain
```

### 2. Generate HTML Output

```bash
# Parse to HTML
curl -sL "FEED_URL" | sfeed | sfeed_html > feeds.html

# With style
cp /opt/homebrew/Cellar/sfeed/*/share/doc/sfeed/style.css ./
curl -sL "FEED_URL" | sfeed | sfeed_html > feeds.html
```

### 3. JSON Feed Output

```bash
# Parse to JSON (for programmatic use)
curl -sL "FEED_URL" | sfeed | sfeed_json
```

## OpenClaw Integration

### Automated Feed Monitoring Script

Create `~/bin/rss_notify.sh`:

```bash
#!/bin/bash
# rss_notify.sh - Monitor RSS feeds and notify via OpenClaw

FEEDS=(
    "https://www.appinn.com/feed/"
    "https://github.com/chneukirchen/sfeed/releases.atom"
    # Add more feeds here
)

CACHE_DIR="$HOME/.sfeed/feeds"
mkdir -p "$CACHE_DIR"

for feed in "${FEEDS[@]}"; do
    feed_name=$(echo "$feed" | md5)
    cache_file="$CACHE_DIR/$feed_name"
    
    # Fetch and parse feed
    content=$(curl -sL "$feed" | sfeed)
    
    # Get new items (compare with cached)
    if [[ -f "$cache_file" ]]; then
        new_items=$(diff "$cache_file" <(echo "$content") | grep "^>" | sed 's/^> //')
    else
        new_items="$content"
    fi
    
    # Save current state
    echo "$content" > "$cache_file"
    
    # Send to OpenClaw if new items
    if [[ -n "$new_items" ]]; then
        echo "$new_items" | sfeed_plain | while read -r line; do
            openclaw notify "RSS Update: $line" 2>/dev/null || \
            echo "New feed item: $line"
        done
    fi
done
```

### 2. Simple OpenClaw Notification

```bash
#!/bin/bash
# notify_openclaw.sh - Send notification to OpenClaw

FEED_URL="https://www.appinn.com/feed/"

# Get latest items
items=$(curl -sL "$FEED_URL" | sfeed | sfeed_plain | head -5)

# Send to OpenClaw (if openclaw CLI exists)
if command -v openclaw &> /dev/null; then
    echo "$items" | openclaw --print-only << 'EOF'
Please summarize these RSS feed updates:
{input}
EOF
else
    # Fallback: just print
    echo "$items"
fi
```

### 3. Real-time Feed to OpenClaw

```bash
#!/bin/bash
# watch_feed.sh - Watch a feed and send updates to OpenClaw

FEED_URL="${1:-https://www.appinn.com/feed/}"
POLL_INTERVAL="${2:-300}"  # 5 minutes default

echo "Watching $FEED_URL every $POLL_INTERVAL seconds..."

while true; do
    # Get timestamp and items
    data=$(curl -sL "$FEED_URL" | sfeed)
    timestamp=$(echo "$data" | cut -f1)
    title=$(echo "$data" | cut -f2 | head -1)
    
    echo "[$(date)] New: $title"
    
    # Send to OpenClaw via stdin (if supported)
    # Replace with your OpenClaw integration method
    echo "Feed update: $title - $FEED_URL"
    
    sleep "$POLL_INTERVAL"
done
```

## Advanced Usage

### sfeed_update Configuration

Create `~/.sfeed/sfeedrc`:

```bash
#!/bin/sh
# ~/.sfeed/sfeedrc - Feed configuration

# Feed definitions: name url [encoding]
feeds() {
    # Example feeds
    feed "appinn" "https://www.appinn.com/feed/" "UTF-8"
    feed "github" "https://github.com/chneukirchen/sfeed/releases.atom" "UTF-8"
    feed "hackernews" "https://hnrss.org/frontpage" "UTF-8"
}

# Update all feeds
sfeed_update

# Format output
sfeed_plain ~/.sfeed/feeds/* > ~/.sfeed/feeds.txt
```

### Filter and Transform

```bash
# Get only titles from multiple feeds
cat ~/.sfeed/feeds/* | cut -f2

# Filter by keyword
curl -sL "https://www.appinn.com/feed/" | sfeed | sfeed_plain | grep -i "OpenClaw"

# Extract URLs only
curl -sL "https://www.appinn.com/feed/" | sfeed | cut -f3
```

### cron Job for Automatic Updates

```bash
# Add to crontab (crontab -e)
# Check feeds every hour
0 * * * * /path/to/rss_notify.sh >> ~/.sfeed/logs/notify.log 2>&1
```

## Common Feeds

| Feed | URL |
|------|-----|
| AppInn | https://www.appinn.com/feed/ |
| Hacker News | https://hnrss.org/frontpage |
| GitHub Releases | https://github.com/chneukirchen/sfeed/releases.atom |
| TechCrunch | https://techcrunch.com/feed/ |
| Ars Technica | https://feeds.arstechnica.com/arstechnica/index |

## sfeed Binary Reference

| Binary | Description |
|--------|-------------|
| `sfeed` | RSS/Atom parser (core) |
| `sfeed_atom` | Atom feed parser |
| `sfeed_curses` | TUI feed reader |
| `sfeed_html` | Convert to HTML |
| `sfeed_plain` | Convert to plain text |
| `sfeed_json` | Convert to JSON Feed |
| `sfeed_xmlenc` | XML encoding/decoding |
| `sfeed_mbox` | Convert to mbox format |
| `sfeed_frames` | HTML frames output |
| `sfeed_update` | Feed update script |
| `sfeed_opml_import` | Import OPML |
| `sfeed_opml_export` | Export OPML |

## Troubleshooting

### SSL Certificate Errors

```bash
# macOS: Install certificates
/Applications/Python\*/Install\Certificates.command

# Or use curl with insecure flag (not recommended)
curl -ksL "FEED_URL" | sfeed
```

### Character Encoding Issues

```bash
# Specify encoding in sfeedrc
feed "name" "url" "GB2312"  # For Chinese feeds
```

### Debug Feed Parsing

```bash
# Show raw parsed output
curl -sL "FEED_URL" | sfeed

# Show with debug info
curl -sL "FEED_URL" | sfeed 2>&1 | cat -A
```
