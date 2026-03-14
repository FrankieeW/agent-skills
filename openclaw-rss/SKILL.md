---
name: openclaw-rss
description: >
  Use sfeed to parse RSS/Atom feeds and push updates to OpenClaw.
  Use when: user wants to monitor RSS feeds and get notifications via OpenClaw.
---

# OpenClaw RSS Reader

Use `sfeed` CLI to parse RSS/Atom feeds and integrate with OpenClaw for automated feed monitoring, notifications, and AI-powered feed summarization.

## Installation

```bash
brew tap frankieew/tap && brew install sfeed
```

Verify installation:
```bash
ls /opt/homebrew/Cellar/sfeed/*/bin/
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
| `sfeed_curses` | TUI feed reader |
| `sfeed_frames` | HTML frames output |

### Common Feeds

| Feed | URL |
|------|-----|
| AppInn | https://www.appinn.com/feed/ |
| Hacker News | https://hnrss.org/frontpage |
| GitHub Releases | https://github.com/chneukirchen/sfeed/releases.atom |
| TechCrunch | https://techcrunch.com/feed/ |
| Ars Technica | https://feeds.arstechnica.com/arstechnica/index |

## OpenClaw Integration

This is the core feature: automatically monitor RSS feeds and send updates to OpenClaw for AI-powered notifications.

### 1. Feed Monitoring with Notification

Create `~/bin/rss_notify.sh`:

```bash
#!/bin/bash
# Monitor RSS feeds and send updates to OpenClaw

FEEDS=(
    "https://www.appinn.com/feed/"
    "https://github.com/chneukirchen/sfeed/releases.atom"
    "https://hnrss.org/frontpage"
)

CACHE_DIR="$HOME/.sfeed/feeds"
mkdir -p "$CACHE_DIR"

for feed in "${FEEDS[@]}"; do
    feed_name=$(echo "$feed" | md5)
    cache_file="$CACHE_DIR/$feed_name"
    
    # Fetch and parse feed
    content=$(curl -sL "$feed" | sfeed)
    
    # Compare with cached version to get new items
    if [[ -f "$cache_file" ]]; then
        new_items=$(diff "$cache_file" <(echo "$content") | grep "^>" | sed 's/^> //')
    else
        new_items="$content"
    fi
    
    # Save current state
    echo "$content" > "$cache_file"
    
    # Send new items to OpenClaw
    if [[ -n "$new_items" ]]; then
        echo "$new_items" | sfeed_plain | while read -r line; do
            # Send to OpenClaw (adjust based on your setup)
            echo "📰 $line"
        done
    fi
done
```

Make it executable:
```bash
chmod +x ~/bin/rss_notify.sh
```

### 2. Real-time Feed Watch

Create `~/bin/watch_feed.sh` for continuous monitoring:

```bash
#!/bin/bash
# Watch a feed and output new items in real-time

FEED_URL="${1:-https://www.appinn.com/feed/}"
POLL_INTERVAL="${2:-300}"  # Default: 5 minutes

echo "Watching $FEED_URL every $POLL_INTERVAL seconds..."
echo "Press Ctrl+C to stop"
echo ""

while true; do
    data=$(curl -sL "$FEED_URL" | sfeed)
    title=$(echo "$data" | cut -f2 | head -1)
    url=$(echo "$data" | cut -f3 | head -1)
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 📰 $title"
    echo "   ↳ $url"
    echo ""
    
    sleep "$POLL_INTERVAL"
done
```

Usage:
```bash
./watch_feed.sh "https://www.appinn.com/feed/" 600
```

### 3. OpenClaw AI Summary Integration

Create `~/bin/rss_openclaw_summary.sh` to use OpenClaw for AI summarization:

```bash
#!/bin/bash
# Get RSS feed and use OpenClaw to summarize

FEED_URL="${1:-https://www.appinn.com/feed/}"

# Get latest 5 items
items=$(curl -sL "$FEED_URL" | sfeed | sfeed_plain | head -5)

# Send to OpenClaw for processing
# This assumes OpenClaw is configured with a command that accepts stdin
echo "$items" | openclaw --print-only << 'EOF'
Please summarize these RSS feed updates in Chinese:
{input}
EOF
```

### 4. cron Job for Automatic Updates

Add to crontab (`crontab -e`):

```bash
# Check feeds every hour
0 * * * * /Users/fwmbam4/bin/rss_notify.sh >> /Users/fwmbam4/.sfeed/logs/notify.log 2>&1

# Check every 30 minutes
*/30 * * * * /Users/fwmbam4/bin/watch_feed.sh "https://www.appinn.com/feed/" 1800 >> /Users/fwmbam4/.sfeed/logs/watch.log 2>&1
```

Create log directory:
```bash
mkdir -p ~/.sfeed/logs
```

## sfeed_update Configuration

The recommended way to manage multiple feeds. Create `~/.sfeed/sfeedrc`:

```bash
#!/bin/sh
# ~/.sfeed/sfeedrc - Feed configuration

# Feed definition function
feeds() {
    # format: feed "name" "url" "encoding"
    feed "appinn" "https://www.appinn.com/feed/" "UTF-8"
    feed "github" "https://github.com/chneukirchen/sfeed/releases.atom" "UTF-8"
    feed "hn" "https://hnrss.org/frontpage" "UTF-8"
    feed "techcrunch" "https://techcrunch.com/feed/" "UTF-8"
}

# Custom merge function to keep only latest items
merge() {
    awk -F'\t' '!seen[$1]++ { print }' "$1" "$2"
}
```

Initialize and run:
```bash
mkdir -p ~/.sfeed/feeds
cp /opt/homebrew/Cellar/sfeed/*/sfeedrc.example ~/.sfeed/sfeedrc
$EDITOR ~/.sfeed/sfeedrc
sfeed_update
```

Format output:
```bash
# Plain text
sfeed_plain ~/.sfeed/feeds/* > ~/.sfeed/feeds.txt

# HTML
sfeed_html ~/.sfeed/feeds/* > ~/.sfeed/feeds.html

# JSON (for programmatic use)
sfeed_json ~/.sfeed/feeds/* > ~/.sfeed/feeds.json
```

## Filter Examples

```bash
# Get only titles from all feeds
cat ~/.sfeed/feeds/* | cut -f2

# Filter by keyword
curl -sL "https://www.appinn.com/feed/" | sfeed | sfeed_plain | grep -i "OpenClaw"

# Extract URLs only
curl -sL "FEED_URL" | sfeed | cut -f3

# Get items newer than timestamp
curl -sL "FEED_URL" | sfeed | awk -F'\t' '$1 > 1773289469'

# Show only unread (new) items
curl -sL "FEED_URL" | sfeed | sfeed_plain | grep "^N"
```

## Advanced Usage

### HTML Output with Styles

```bash
# Generate HTML with default style
curl -sL "FEED_URL" | sfeed | sfeed_html > feeds.html

# Copy style.css for better presentation
cp /opt/homebrew/Cellar/sfeed/*/share/doc/sfeed/style.css ./
```

### OPML Import/Export

```bash
# Import from other readers (e.g., newsboat)
newsboat -e | sfeed_opml_import > ~/.sfeed/sfeedrc

# Export to OPML
sfeed_opml_export ~/.sfeed/feeds/* > subscriptions.opml
```

### mbox Format for Email

```bash
# Convert feed to mbox format
curl -sL "FEED_URL" | sfeed | sfeed_mbox > feed.mbox

# Import to email client
```

## Troubleshooting

- **SSL errors**: Use `curl -ksL` instead of `curl -sL`
- **Encoding issues**: Specify encoding in sfeedrc: `feed "name" "url" "GB2312"`
- **Debug**: Run `curl -sL "FEED_URL" | sfeed` to see raw parsed output
- **Missing items**: Check cache files in `~/.sfeed/feeds/`
- **Man pages**: `man sfeed`, `man sfeed_update`, `man sfeedrc`
