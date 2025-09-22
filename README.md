````markdown
# Whisper.cpp 字幕流程

## 0. 建立虛擬環境與安裝工具
```bash
python3 -m venv venv
source venv/bin/activate

pip install -U yt-dlp
````

```bash
./downloadBest.sh
```

---

## 1. 編譯 whisper.cpp

```bash
git clone https://github.com/ggml-org/whisper.cpp.git
cd whisper.cpp
mkdir build
cmake -DGGML_CUDA=1 -DCMAKE_BUILD_TYPE=Release ..
make
```

alan314159/Breeze-ASR-25-whispercpp 
https://huggingface.co/alan314159/Breeze-ASR-25-whispercpp/tree/main
ggml-model.bin模型放在 `models` 目錄，例如：

```
models/ggml-model.bin
```

---

## 2. 抽取音訊並轉錄

### 抽音訊

```bash
ffmpeg -i test.mp4 -ac 1 -ar 16000 test.wav
```

### 語音轉文字

```bash
./build/bin/whisper-cli -m models/ggml-model.bin -f test.wav -osrt -of test -l zh -t 8
```

會輸出 `test.srt`

---

## 3. 產生軟字幕影片（可開關）


 硬字幕（燒錄進畫面）：
```bash
ffmpeg -i jserv.mp4 -vf "subtitles=jserv.srt" -c:a copy output.mp4
```

完成後 `test_with_sub.mp4` 影片就有內嵌可開關的中文字幕。
