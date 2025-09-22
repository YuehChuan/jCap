yt-dlp \
  -o "%(title)s_%(upload_date)s_%(timestamp)s.%(ext)s" \
  -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best" \
  --merge-output-format mp4 \
  --live-from-start \
  --hls-use-mpegts \
  https://www.youtube.com/watch?v=EruTyovsEzM
