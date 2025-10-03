#!/usr/bin/env bash
set -e

# 配置
WHISPER_BIN="./whisper.cpp/build/bin/whisper-cli"
MODEL_PATH="./whisper.cpp/models/ggml-model.bin"
WORKDIR="./downloads"

# 確保工作目錄存在
mkdir -p "$WORKDIR"

# 輸入 YouTube 影片網址
read -p "請輸入 YouTube 影片網址: " URL
if [ -z "$URL" ]; then
    echo "❌ 未輸入網址，結束。"
    exit 1
fi

echo ">>> [1/4] 下載 YouTube 影片 ..."

yt-dlp \
-o "$WORKDIR/%(title)s_%(upload_date)s_%(timestamp)s.%(ext)s" \
-f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best" \
--merge-output-format mp4 \
--live-from-start \
--hls-use-mpegts "$URL"

# 取得最新下載的 mp4 檔
VIDEO_PATH=$(ls -t "$WORKDIR"/*.mp4 | head -n1)
if [ ! -f "$VIDEO_PATH" ]; then
    echo "❌ 未找到下載的 mp4 檔案"
    exit 1
fi
echo "已下載影片: $VIDEO_PATH"

# 抽音訊
WAV_PATH="${VIDEO_PATH%.*}.wav"
echo ">>> [2/4] 抽取音訊 ..."
ffmpeg -y -i "$VIDEO_PATH" -ac 1 -ar 16000 "$WAV_PATH"

# 語音轉文字
SRT_PATH="${VIDEO_PATH%.*}.srt"
echo ">>> [3/4] 使用 whisper.cpp 轉錄字幕 ..."
$WHISPER_BIN \
    -m "$MODEL_PATH" \
    -f "$WAV_PATH" \
    -osrt \
    -of "${VIDEO_PATH%.*}" \
    -l zh \
    -t 8

if [ ! -f "$SRT_PATH" ]; then
    echo "❌ 字幕檔未產生，請檢查 whisper 模型與輸入檔案。"
    exit 1
fi
echo "已產生字幕檔: $SRT_PATH"

# 燒錄硬字幕
OUT_PATH="${VIDEO_PATH%.*}_hardsub.mp4"
echo ">>> [4/4] 產生帶硬字幕影片 ..."
ffmpeg -y -i "$VIDEO_PATH" -vf "subtitles=$SRT_PATH" -c:a copy "$OUT_PATH"

echo "✅ 完成！輸出影片：$OUT_PATH"

