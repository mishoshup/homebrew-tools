#!/usr/bin/env bash
# Refresh Casks/disktree.rb from the latest tobi/disktree release.
# Exits 0 with no changes when already current, 0 with a modified file when bumped.
set -euo pipefail

cd "$(dirname "$0")/.."

repo="tobi/disktree"
cask="Casks/disktree.rb"

current=$(sed -n 's/^  version "\(.*\)"$/\1/p' "$cask" | head -1)
tag=$(curl -fsSL --retry 3 "https://api.github.com/repos/$repo/releases/latest" |
  sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -1)
latest=${tag#v}

if [ -z "$latest" ]; then
  echo "error: could not determine latest release" >&2
  exit 1
fi

if [ "$current" = "$latest" ]; then
  echo "disktree is current at $current"
  exit 0
fi

sums() {
  curl -fsSL --retry 3 \
    "https://github.com/$repo/releases/download/v$latest/disktree-$latest-$1-macos.zip.sha256" |
    awk '{print $1}' | head -1
}

arm=$(sums aarch64)
intel=$(sums x86_64)

for sum in "$arm" "$intel"; do
  if ! printf '%s' "$sum" | grep -Eq '^[0-9a-f]{64}$'; then
    echo "error: bad checksum for $latest: '$sum'" >&2
    exit 1
  fi
done

awk -v ver="$latest" -v arm="$arm" -v intel="$intel" '
  /^  version "/ { sub(/"[^"]*"/, "\"" ver "\""); print; next }
  /sha256 "/ && !seen_arm  { sub(/"[^"]*"/, "\"" arm   "\""); seen_arm=1;  print; next }
  /sha256 "/ && !seen_intel{ sub(/"[^"]*"/, "\"" intel "\""); seen_intel=1; print; next }
  { print }
' "$cask" > "$cask.new"
mv "$cask.new" "$cask"

echo "bumped disktree $current -> $latest"
