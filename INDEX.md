# 📚 TỔNG HỢP TÀI LIỆU - RASPBERRY PI

**Cập nhật:** 01/03/2026  
**Phiên bản:** v4.3.x - Backup API Keys Edition

---

## 📖 DANH SÁCH TÀI LIỆU

### 1. **RASPBERRY_PI_GUIDE.md** - Hướng dẫn cài đặt từ đầu
   - Cài Docker trên Pi
   - Clone repository từ GitHub
   - Cấu hình API keys
   - Build và chạy Docker lần đầu
   - **📍 Dùng cho:** Người mới setup Pi lần đầu

### 2. **UPDATE_BACKUP_KEYS.md** - Hướng dẫn cập nhật tính năng Backup Keys
   - Pull code mới từ GitHub
   - Rebuild Docker image
   - Cấu hình Gemini/Serper backup keys
   - Test auto-failover
   - **📍 Dùng cho:** Pi đã chạy, cần cập nhật lên v4.3.x

### 3. **DEPLOY_INSTRUCTIONS.md** - Hướng dẫn cập nhật nhanh
   - Các bước git pull + rebuild
   - Tools đã thay đổi (37 tools Docker-compatible)
   - **📍 Dùng cho:** Cập nhật thường xuyên

### 4. **QUICK_REFERENCE.md** - Tra cứu lệnh nhanh
   - 10 lệnh Docker thường dùng
   - One-liner update command
   - Debug & troubleshooting
   - Emergency commands
   - **📍 Dùng cho:** Tra cứu nhanh khi cần

### 5. **README.md** - Tổng quan project
   - Giới thiệu chung
   - Architecture
   - Features list
   - **📍 Dùng cho:** Overview

---

## 🎯 CHỌN TÀI LIỆU PHÙ HỢP

### Bạn chưa cài Docker trên Pi?
→ Đọc: **RASPBERRY_PI_GUIDE.md** (Section 1-3)

### Pi đã chạy Docker, muốn cập nhật code mới?
→ Đọc: **UPDATE_BACKUP_KEYS.md** hoặc **DEPLOY_INSTRUCTIONS.md**

### Cần cấu hình Backup API Keys?
→ Đọc: **UPDATE_BACKUP_KEYS.md** (Section "⚙️ CẤU HÌNH BACKUP API KEYS")

### Quên lệnh Docker?
→ Đọc: **QUICK_REFERENCE.md**

### Gặp lỗi khi chạy?
→ Đọc: **QUICK_REFERENCE.md** (Section "🔍 DEBUG & TROUBLESHOOTING")

---

## ⚡ WORKFLOW CHUẨN

### Lần đầu cài đặt
```
RASPBERRY_PI_GUIDE.md (full)
  ↓
Test truy cập Web UI
  ↓
QUICK_REFERENCE.md (bookmark để tra cứu)
```

### Cập nhật thường xuyên
```
git pull origin main
  ↓
cd docker
  ↓
docker compose down && docker compose up -d --build
  ↓
docker compose logs -f (xem logs khởi động)
```

**Hoặc dùng one-liner:**
```bash
cd ~/apps/pimcp && git pull origin main && cd docker && docker compose down && docker compose up -d --build && docker compose logs -f
```

---

## 🆕 TÍNH NĂNG MỚI v4.3.x

### 1. **Backup API Keys với Auto-Failover**
   - ✅ Gemini API Key Backup
   - ✅ Serper API Key Backup
   - ✅ Tự động swap khi key chính fail
   - ✅ Lưu config sau khi swap

### 2. **Riddles & Fairy Tales**
   - 40 câu đố vui (6 chủ đề)
   - 15 truyện cổ tích Việt Nam
   - Voice trigger: "Đố em một câu", "Kể chuyện cổ tích"

### 3. **Port mới: 9000**
   - Thay đổi từ 8000 → 9000
   - Tránh conflict với services khác

### 4. **Smart Startup**
   - Chỉ start active endpoint + 10 listeners
   - Thay vì start toàn bộ 100 devices
   - Tiết kiệm tài nguyên Pi

---

## 🌐 ENDPOINTS QUAN TRỌNG

| Endpoint | URL | Mô tả |
|----------|-----|-------|
| Web UI | http://pi-ip:9000 | Giao diện chính |
| API Docs | http://pi-ip:9000/docs | Swagger UI |
| System Info | http://pi-ip:9000/api/system_info | Health check |
| Endpoints | http://pi-ip:9000/api/endpoints | GET config + API keys |
| Gemini Backup | http://pi-ip:9000/api/gemini-key-backup | POST backup key |
| Serper Backup | http://pi-ip:9000/api/serper-key-backup | POST backup key |

---

## 🔑 API KEYS CẦN CÓ

### Bắt buộc
- ✅ **Gemini API Key** - Lấy tại: https://aistudio.google.com/apikey

### Tùy chọn (nhưng nên có)
- 🔄 **Gemini Backup Key** - Key dự phòng khi key chính hết quota
- 🔍 **Serper API Key** - Miễn phí 2500 queries/tháng: https://serper.dev
- 🔄 **Serper Backup Key** - Key dự phòng cho search

### Trả phí
- 💰 **OpenAI API Key** - GPT-4 (nếu cần)

---

## 📊 TÀI NGUYÊN RASPBERRY PI

### Đề xuất phần cứng
| Model | RAM | Status |
|-------|-----|--------|
| Pi 3B/3B+ | 1GB | ⚠️ Tối thiểu (chậm) |
| Pi 4 (2GB) | 2GB | ✅ OK |
| Pi 4 (4GB) | 4GB | ✅ Tốt |
| Pi 4 (8GB) | 8GB | 🚀 Rất tốt |
| Pi 5 (4GB+) | 4GB+ | 🚀 Xuất sắc |

### RAM usage thực tế
- **Idle:** ~200-300MB
- **Active (1 device):** ~400-600MB
- **Heavy load (10 devices):** ~800MB-1.2GB

### Docker image size
- **Compressed:** ~500MB
- **Extracted:** ~1.5GB

---

## 🐛 LỖI THƯỜNG GẶP

### "Port 9000 already in use"
```bash
sudo lsof -i :9000
sudo kill -9 <PID>
docker compose restart
```

### "Cannot connect to Docker daemon"
```bash
sudo systemctl start docker
sudo systemctl enable docker
```

### Container bị crash liên tục
```bash
docker compose logs | grep -i error
docker compose down -v
docker compose up -d --build --force-recreate
```

### Gemini "quota exceeded"
→ Backup key sẽ tự động được dùng  
Xem logs: `docker compose logs -f | grep -i backup`

### Pi bị lag khi build
→ Bình thường, build Docker mất 3-5 phút  
Giải pháp: Build trên PC, push image lên Docker Hub, pull về Pi

---

## 🎓 HỌC DOCKER CƠ BẢN

### Các lệnh cốt lõi
```bash
docker compose up -d          # Start container (background)
docker compose down           # Stop và xóa container
docker compose logs -f        # Xem logs real-time
docker compose ps             # Xem status
docker compose restart        # Restart container
docker compose exec <svc> sh # Vào bên trong container
```

### File quan trọng
- `docker-compose.yml` - Định nghĩa services, ports, volumes
- `Dockerfile` - Build instructions cho image
- `.env` - Environment variables (API keys)

### Volumes
- `miniz_config:/app/config` - Persistent storage cho config
- Vị trí trên Pi: `/var/lib/docker/volumes/miniz_config/_data/`

---

## 🔗 GITHUB WORKFLOW

### Clone lần đầu
```bash
git clone https://github.com/conghuy93/pimcp.git
```

### Cập nhật code
```bash
cd ~/apps/pimcp
git pull origin main
```

### Xem commit history
```bash
git log --oneline -n 10
```

### Kiểm tra changes
```bash
git status
git diff
```

---

## 📞 HỖ TRỢ

### Cần help?
1. Đọc **QUICK_REFERENCE.md** (troubleshooting section)
2. Xem logs: `docker compose logs -f`
3. Tạo issue: https://github.com/conghuy93/pimcp/issues

### Báo lỗi kèm thông tin:
```bash
# System info
uname -a
docker --version
docker compose version

# Container status
docker compose ps

# Latest logs
docker compose logs --tail=50

# Resource usage
docker stats miniz-mcp-api --no-stream
```

---

## 🎯 NEXT STEPS

1. ✅ Đọc **RASPBERRY_PI_GUIDE.md** để cài đặt
2. ✅ Bookmark **QUICK_REFERENCE.md** cho tra cứu
3. ✅ Cấu hình backup API keys qua Web UI
4. ✅ Test voice commands: "Đố em một câu"
5. ✅ Join Discord/Telegram để nhận updates (nếu có)

---

## 📅 LỊCH SỬ CẬP NHẬT

| Ngày | Version | Thay đổi chính |
|------|---------|----------------|
| 01/03/2026 | v4.3.x | Backup API Keys + Riddles + Fairy Tales |
| 15/02/2026 | v4.2.x | Port 8000→9000 + Smart Startup |
| 01/02/2026 | v4.1.x | RAG improvements + 37 tools Docker-only |
| 15/01/2026 | v4.0.x | Initial Docker deployment |

---

**✨ Happy Deploying! ✨**
