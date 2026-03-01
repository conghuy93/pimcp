# 🚀 HƯỚNG DẪN CẬP NHẬT DOCKER TRÊN RASPBERRY PI

## ✅ ĐÃ HOÀN THÀNH
- Commit `5f58247`: Xóa 120+ desktop/GUI tools, chỉ giữ 37 tools Docker-compatible
- Đã push lên: https://github.com/conghuy93/pimcp.git

---

## 📦 CẬP NHẬT NHANH (Git Pull + Rebuild)

### Bước 1: SSH vào Raspberry Pi
```bash
ssh huy123@<raspberry-pi-ip>
```

### Bước 2: Dừng Docker container hiện tại
```bash
cd ~/apps/pimcp/docker
docker compose down
```

### Bước 3: Pull code mới từ GitHub
```bash
cd ~/apps/pimcp
git pull origin main
```
**Kết quả mong đợi:**
```
remote: Enumerating objects: 5, done.
remote: Counting objects: 100% (5/5), done.
remote: Compressing objects: 100% (3/3), done.
remote: Total 3 (delta 2), reused 3 (delta 2)
Unpacking objects: 100% (3/3), done.
From https://github.com/conghuy93/pimcp
   175d87b..5f58247  main       -> origin/main
Updating 175d87b..5f58247
Fast-forward
 xiaozhi_final.py | 1403 +++-------------------------------------------
 1 file changed, 150 insertions(+), 1253 deletions(-)
```

### Bước 4: Rebuild Docker image với code mới
```bash
cd ~/apps/pimcp/docker
docker compose up -d --build
```
*Docker sẽ build lại image với xiaozhi_final.py mới (37 tools thay vì 155)*

### Bước 5: Xem logs để kiểm tra
```bash
docker compose logs -f miniz-api
```
**Tìm dòng này để xác nhận thành công:**
```
✅ RAG System initialized successfully
INFO:     Uvicorn running on http://0.0.0.0:9000
```

### Bước 6: Kiểm tra Web UI
Mở trình duyệt: `http://<raspberry-pi-ip>:9000`

---

## 🔧 TOOLS MỚI (37 tools Docker-compatible)

### 📨 Core Tools (5)
- send_message_to_llm, broadcast_to_all_llm
- get_system_resources, get_current_time, calculator

### 📁 File/System Tools (6)
- create_file, read_file, list_files
- get_network_info, get_disk_usage, check_internet_connection

### 🧠 Task Memory (4)
- remember_task, recall_tasks, get_task_summary, forget_all_tasks

### 📰 News & Vietnam APIs (14)
- get_vnexpress_news, get_news_summary, search_news
- get_gold_price, get_weather_vietnam, get_exchange_rate_vietnam
- get_fuel_price_vietnam, get_daily_quote, get_joke, get_horoscope
- get_today_in_history, get_news_vietnam, what_to_eat, get_lunar_date

### 🤖 AI Tools (5)
- ask_gemini, ask_gpt4, gemini_agent
- analyze_gold_price_with_ai, gemini_smart_analyze

### 📚 Knowledge Base (4)
- search_knowledge_base, get_knowledge_context
- doc_reader_gemini_rag, gemini_smart_kb_filter

### 🌐 RAG/Web Search (4)
- web_search, get_realtime_info, rag_search, smart_answer

### 💬 Conversation Tools (6)
- save_text_to_file, export_conversation, get_user_context
- save_user_message, save_assistant_response, list_conversation_files

**✅ KHÔNG CÒN CÁC TOOLS:**
- ❌ Desktop (open_application, screenshot, wallpaper, theme...)
- ❌ Volume/Audio controls (set_volume, mute...)
- ❌ Music (VLC, WMP, Spotify, YouTube music...)
- ❌ Browser automation (Selenium, open_facebook, open_google...)
- ❌ Windows-only (clipboard, lock_computer, shutdown...)
- ❌ TTS/STT (gemini_text_to_speech, speech_to_text...)

---

## 🧪 TEST SAU KHI CẬP NHẬT

### 1. Test API Health
```bash
curl http://localhost:8000/health
```
**Kết quả mong đợi:**
```json
{"status":"ok","rag_available":true}
```

### 2. Test Tool Count
Mở Web UI → Xem số lượng tools trong dropdown
- Trước: ~155 tools
- **Sau: 37 tools** ✅

### 3. Test RAG Search
Trong Web UI, thử tool `web_search`:
```json
{
  "query": "giá vàng hôm nay"
}
```

### 4. Test News API
Thử tool `get_vnexpress_news`:
```json
{
  "category": "thoi-su",
  "max_articles": 5
}
```

---

## 🐛 XỬ LÝ LỖI

### Lỗi: "rag_system.py not found"
**Giải pháp:** Code mới đã có rag_system.py, chỉ cần rebuild:
```bash
docker compose down
docker compose up -d --build
```

### Lỗi: "Tool handler is None"
**Nguyên nhân:** RAG tools chưa init
**Giải pháp:** Restart container:
```bash
docker compose restart miniz-api
```

### Lỗi: Container không chạy
```bash
docker compose ps
docker compose logs miniz-api
```

### Xóa volumes cũ (nếu cần reset hoàn toàn)
```bash
docker compose down -v
docker compose up -d --build
```

---

## 📊 THAY ĐỔI CHI TIẾT

### File Size
- **Trước:** 24,058 dòng
- **Sau:** 23,013 dòng
- **Giảm:** 1,045 dòng (-4.3%)

### TOOLS Dictionary
- **Trước:** Lines 12577-13936 (1,360 dòng, 155 tools)
- **Sau:** Lines 12577-12833 (257 dòng, 37 tools)
- **Giảm:** 1,103 dòng (-81%)

### Commit History
```
5f58247 (HEAD -> main, origin/main) Remove 120+ desktop/GUI tools, keep 37 Docker-compatible tools only
175d87b Add None handler guards for RAG tools at 4 crash points
442fb51 Copy rag_system.py and crypto_api.py to pimcp-deploy, update Dockerfile
...
```

---

## 🎯 KẾT LUẬN

✅ **Code đã được tối ưu cho Docker/Raspberry Pi**
- Loại bỏ toàn bộ dependencies không cần thiết (pyautogui, pywin32, VLC...)
- Chỉ giữ tools hoạt động qua HTTP API và Gemini AI
- Kích thước nhỏ gọn, build nhanh hơn
- Ít lỗi runtime do các tools Windows-only

🚀 **Sẵn sàng triển khai production trên Raspberry Pi!**

---

## 📞 HỖ TRỢ

Nếu gặp lỗi, gửi logs:
```bash
docker compose logs miniz-api --tail=100 > error.log
```

GitHub Issues: https://github.com/conghuy93/pimcp/issues
