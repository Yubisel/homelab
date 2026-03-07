#!/usr/bin/env bash
# Download favicons for Homepage bookmarks into the current directory.
# Run from: core/homepage/icons/
# Uses Google's favicon API; each file is saved as slug.png.

set -e
ICONS_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$ICONS_DIR"

# slug:domain (one per bookmark; domain used for favicon fetch)
while IFS=: read -r slug domain; do
  [[ -z "$slug" || "$slug" =~ ^# ]] && continue
  out="${slug}.png"
  url="https://www.google.com/s2/favicons?domain=${domain}&sz=128"
  echo "Fetching $slug -> $out"
  curl -sfL -o "$out" "$url" || echo "  (failed)"
done << 'LIST'
github:github.com
gitlab:gitlab.com
stackoverflow:stackoverflow.com
mdn:developer.mozilla.org
dockerhub:hub.docker.com
npm:npmjs.com
google:google.com
gmail:mail.google.com
translate:translate.google.com
gemini:gemini.google.com
drive:drive.google.com
calendar:calendar.google.com
contacts:contacts.google.com
youtube:youtube.com
linkedin:linkedin.com
facebook:facebook.com
instagram:instagram.com
whatsapp:whatsapp.com
reddit:reddit.com
x:x.com
netflix:netflix.com
spotify:spotify.com
twitch:twitch.tv
imdb:imdb.com
outlook:outlook.live.com
discord:discord.com
notion:notion.so
trello:trello.com
animeflv:animeflv.net
crunchyroll:crunchyroll.com
apollcomics:apollcomics.xyz
vermanhwa:vermanhwa.com
m440:m440.in
mercadolibre:mercadolibre.com.uy
amazon:amazon.com
ebay:ebay.com
itau:itau.com.uy
scotiabank:scotiabank.com.uy
LIST

echo "Done. Icons in: $ICONS_DIR"
