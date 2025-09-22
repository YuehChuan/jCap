yt-dlp -o "%(title)s_%(upload_date)s_%(timestamp)s.%(ext)s" \
       -f best \
       --live-from-start \
       --hls-use-mpegts \
       https://www.youtube.com/watch?v=EruTyovsEzM
#ffmpeg -y -i test.mp4 -ac 1 -ar 16000 test.wav

