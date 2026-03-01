# 🔄 CẬP NHẬT BACKUP API KEYS - RASPBERRY PI

**Ngày cập nhật:** 01/03/2026  
**Tính năng mới:** Backup API Keys với Auto-Failover cho Gemini & Serper

---

## 📋 TỔNG QUAN TÍNH NĂNG MỚI

### 1. **Backup API Keys**
- ✅ Gemini API Key Backup (dự phòng)
- ✅ Serper API Key Backup (dự phòng)
- ✅ Auto-fallback khi key chính bị lỗi:
  - Invalid API key
  - Quota exceeded
  - Rate limit (429, 403, 401)
  - Permission errors

### 2. **Riddles & Fairy Tales**
- 40 câu đố vui (6 chủ đề)
- 15 truyện cổ tích Việt Nam
- Tích hợp RAG system

### 3. **Port mới: 9000** (thay vì 8000)

---

## 🚀 HƯỚNG DẪN CẬP NHẬT

### **Bước 1: SSH vào Raspberry Pi**

```bash
ssh huy123@<raspberry-pi-ip>
# Ví dụ: ssh huy123@192.168.1.100
```

### **Bước 2: Dừng container hiện tại**

```bash
cd ~/apps/pimcp/docker
docker compose down
```

### **Bước 3: Pull code mới**

```bash
cd ~/apps/pimcp
git pull origin main
```

**Kết quả mong đợi:**
```
Updating abc1234..def5678
Fast-forward
 xiaozhi_final.py | 350 insertions(+), 125 deletions(-)
```

### **Bước 4: Rebuild Docker image**

```bash
cd docker
docker compose build --no-cache
```

⏱️ **Thời gian build:** 3-5 phút (tùy Pi model)

### **Bước 5: Start container mới**

```bash
docker compose up -d
```

### **Bước 6: Xem logs khởi động**

```bash
docker compose logs -f
```

**Tìm các dòng này để xác nhận:**
```
✅ [RAG] RAG System loaded - DuckDuckGo + Local KB
🚀 miniZ MCP - Sidebar UI
🌐 Web: http://localhost:9000
📡 MCP: Multi-device ready
INFO:     Uvicorn running on http://0.0.0.0:9000
```

**Nhấn Ctrl+C để thoát logs**

---

## ⚙️ CẤU HÌNH BACKUP API KEYS

### **Cách 1: Qua Web UI (Đề xuất)**

1. Truy cập: `http://<raspberry-pi-ip>:9000`
2. Click nút **⚙️ Cấu hình**
3. Cuộn xuống mục **API KEYS**
4. Điền các ô:

   **Bên trái (Gemini):**
   - 🤖 **Gemini API Key** → Key chính
   - 🔄 **Gemini API Key (Dự phòng)** → Key backup (viền cam)

   **Bên phải (Serper):**
   - 🔍 **Serper API Key** → Key chính
   - 🔄 **Serper API Key (Dự phòng)** → Key backup (viền cam)

5. Hệ thống **tự động lưu** sau 1 giây

### **Cách 2: Edit file config trực tiếp**

```bash
# Vào container
docker compose exec miniz-mcp-api /bin/bash

# Edit config file
nano /app/config/xiaozhi_endpoints.json
```

**Thêm 2 dòng này:**
```json
{
  "endpoints": [...],
  "gemini_api_key": "AIzaSy...primary",
  "gemini_api_key_backup": "AIzaSy...backup",
  "openai_api_key": "sk-...",
  "serper_api_key": "abc123...primary",
  "serper_api_key_backup": "def456...backup"
}
```

**Lưu:** Ctrl+O, Enter, Ctrl+X

**Restart container:**
```bash
exit
docker compose restart
```

---

## 🔍 KIỂM TRA BACKUP KEYS

### Test 1: View logs khi fallback xảy ra

```bash
docker compose logs -f | grep -i "backup"
```

**Kết quả mong đợi khi key chính fail:**
```
🔄 [Gemini] Primary key failed: quota exceeded
🔄 [Gemini] Switching to BACKUP key: ...abc12345
✅ [Gemini] Backup key saved to config
🔄 [Gemini] Đang retry với backup key...
✅ [Gemini] Backup key thành công!
```

### Test 2: Kiểm tra config file

```bash
docker compose exec miniz-mcp-api cat /app/config/xiaozhi_endpoints.json | grep backup
```

**Nên thấy:**
```json
"gemini_api_key_backup": "AIzaSy...",
"serper_api_key_backup": "abc..."
```

### Test 3: API health check

```bash
curl http://localhost:9000/api/endpoints | jq '.gemini_api_key_backup'
```

**Nên trả về:** Key backup của bạn (hoặc rỗng nếu chưa cấu hình)

---

## 🎯 CÁCH HOẠT ĐỘNG AUTO-FALLBACK

### Kịch bản 1: Gemini key chính hết quota

```
User: "Hỏi về thời tiết"
  ↓
System gọi ask_gemini() với PRIMARY key
  ↓
ERROR: "quota exceeded"
  ↓
🔄 AUTO-FALLBACK:
  - Switch: PRIMARY ↔ BACKUP
  - Save config
  - Retry request với BACKUP key
  ↓
✅ Response thành công
```

**Lần gọi tiếp theo:** Dùng BACKUP làm PRIMARY

### Kịch bản 2: Serper search bị rate limit

```
User: "Tìm kiếm tin tức mới nhất"
  ↓
google_realtime_search() → Serper API với PRIMARY key
  ↓
ERROR: 429 Rate Limit
  ↓
🔄 AUTO-FALLBACK:
  - Retry với BACKUP key
  - Save swap nếu cần
  ↓
✅ Kết quả search trả về
```

### Error keywords kích hoạt fallback:
- `api key`, `invalid`
- `quota`, `exhausted`
- `rate limit`, `429`, `403`, `401`
- `permission`

---

## 📊 PORTS VÀ ENDPOINTS MỚI

### Thay đổi port
| Phiên bản | Port cũ | Port mới |
|-----------|---------|----------|
| v4.2.x    | 8000    | ~~8000~~ |
| v4.3.x    | ✅ 9000 | 9000     |

### Web UI
- **Trước:** http://192.168.1.100:8000
- **Bây giờ:** http://192.168.1.100:9000

### API Endpoints mới
```
POST /api/gemini-key-backup    - Lưu Gemini backup key
POST /api/serper-key-backup    - Lưu Serper backup key
GET  /api/endpoints             - Trả về tất cả keys (bao gồm backup)
```

---

## 🎲 RIDDLES & FAIRY TALES

### Test câu đố

**Voice command:**
```
"Đố em một câu"
"Hỏi câu đố về động vật"
```

**Response:**
```
🤔 Câu đố: Con gì có 4 chân khi sáng, 2 chân khi trưa, 3 chân khi tối?
```

### Test truyện cổ tích

**Voice command:**
```
"Kể chuyện cổ tích"
"Kể chuyện Tấm Cám"
```

**Response:**
```
📖 Truyện: Tấm Cám
Ngày xửa ngày xưa, có một cô gái tên là Tấm sống với...
(truncated ~450 chars cho TTS)
```

---

## 🐛 TROUBLESHOOTING

### ❌ Port 9000 bị chiếm

```bash
# Kiểm tra process nào đang dùng port 9000
sudo lsof -i :9000

# Kill process
sudo kill -9 <PID>

# Restart container
docker compose restart
```

### ❌ Backup key không tự động lưu

1. Kiểm tra logs:
```bash
docker compose logs -f | grep "Backup"
```

2. Kiểm tra quyền file config:
```bash
docker compose exec miniz-mcp-api ls -la /app/config/
```

3. Xóa và tạo lại config:
```bash
docker compose exec miniz-mcp-api rm /app/config/xiaozhi_endpoints.json
docker compose restart
```

### ❌ Gemini fallback không hoạt động

**Nguyên nhân thường gặp:**
- Cả 2 keys đều hết quota
- Key backup không hợp lệ
- Lỗi network

**Debug:**
```bash
docker compose logs -f | grep -E "Gemini|fallback|backup"
```

---

## 📝 CHECKLIST HOÀN THÀNH

- [ ] SSH vào Pi thành công
- [ ] `git pull` code mới
- [ ] `docker compose down` container cũ
- [ ] `docker compose build --no-cache` thành công
- [ ] `docker compose up -d` start container
- [ ] Truy cập Web UI port 9000 OK
- [ ] Cấu hình Gemini backup key
- [ ] Cấu hình Serper backup key
- [ ] Test câu đố: "Đố em một câu"
- [ ] Test truyện: "Kể chuyện cổ tích"
- [ ] Test fallback: Tạm vô hiệu hóa primary key → xem log backup

---

## 🔗 LINKS THAM KHẢO

- **Repository:** https://github.com/conghuy93/pimcp
- **Gemini API Keys:** https://aistudio.google.com/apikey
- **Serper API:** https://serper.dev
- **Web UI:** http://<your-pi-ip>:9000

---

## 📞 HỖ TRỢ

Nếu gặp vấn đề, kiểm tra logs:

```bash
# Xem 100 dòng logs cuối
docker compose logs --tail=100

# Theo dõi real-time
docker compose logs -f

# Chỉ xem errors
docker compose logs | grep -i error
```

**Hoặc tạo issue tại:** https://github.com/conghuy93/pimcp/issues
