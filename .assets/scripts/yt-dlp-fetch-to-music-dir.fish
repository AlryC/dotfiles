#!/usr/bin/env fish

# Directory to move final file
set TARGET_DIR "$HOME/Documents/Music"
set TMP_DIR "$HOME/.cache/ym_temp"

# URL argument
set URL $argv[1]

if test -z "$URL"
    echo "Usage: ym <youtube-url>"
    exit 1
end

# Make sure directories exist
mkdir -p "$TARGET_DIR" "$TMP_DIR"

# Download audio into temporary folder
yt-dlp --extract-audio --audio-format mp3 -o "$TMP_DIR/%(title)s.%(ext)s" "$URL" --cookies "$HOME/dotfiles/.assets/scripts/cookies.txt"

# Get the downloaded mp3 (should be only 1 file in TMP_DIR)
set FILE (ls "$TMP_DIR"/*.mp3 | head -n 1)

if test -z "$FILE"
    echo "Error: MP3 not found in $TMP_DIR"
    exit 1
end

# Optional: remove trailing [videoID] from filename
set BASENAME (basename "$FILE")
set CLEAN_NAME (string replace -r '\s*\[[A-Za-z0-9_-]{11}\](?=\.mp3$)' '' "$BASENAME")

# Move to target directory with cleaned name
mv "$FILE" "$TARGET_DIR/$CLEAN_NAME"

echo "Saved as: $TARGET_DIR/$CLEAN_NAME"

# Clean up temporary folder
rm -rf "$TMP_DIR"
