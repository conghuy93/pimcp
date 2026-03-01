# 🔄 CẬP NHẬT NGAY PI VỚI BACKUP API KEYS

**Ngày:** 01/03/2026  
**Vấn đề:** Pi đang chạy Docker với code cũ (port 8000, không có backup keys)  
**Pi IP:** 192.168.0.174

---

## ⚡ QUICK FIX - 3 PHÚT

### Bước 1: SSH vào Pi

```bash
ssh huy123@192.168.0.174
```

**Password:** [nhập password của Pi]

---

### Bước 2: Dừng Docker container

```bash
cd ~/apps/pimcp/docker
docker compose down
```

**Output mong đợi:**
```
[+] Running 2/2
 ✔ Container miniz-mcp-api Removed
 ✔ Network docker_miniz-network Removed
```

---

### Bước 3: Pull code mới từ GitHub

```bash
cd ~/apps/pimcp
git pull origin main
```

**Output mong đợi:**
```
remote: Enumerating objects: 8, done.
remote: Counting objects: 100% (8/8), done.
remote: Compressing objects: 100% (5/5), done.
Unpacking objects: 100% (5/5), done.
From https://github.com/conghuy93/pimcp
   abc1234..def5678  main -> origin/main
Updating abc1234..def5678
Fast-forward
 xiaozhi_final.py | 120 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 100 insertions(+), 20 deletions(-)
```

**❌ Nếu gặp lỗi "uncommitted changes":**
```bash
git stash
git pull origin main
git stash pop
```

---

### Bước 4: Rebuild Docker image

```bash
cd docker
docker compose build --no-cache
```

**⏱️ Thời gian:** 3-5 phút (tùy Pi model)

**Output cuối cùng sẽ thấy:**
```
[+] Building 120.5s (19/19) FINISHED
 => exporting to image
 => naming to docker.io/library/docker-miniz-api:latest
```

---

### Bước 5: Start container mới

```bash
docker compose up -d
```

**Output:**
```
[+] Running 2/2
 ✔ Network docker_miniz-network Created
 ✔ Container miniz-mcp-api Started
```

---

### Bước 6: Xem logs để xác nhận

```bash
docker compose logs -f
```

**Tìm các dòng này để xác nhận thành công:**
```
🌐 Web: http://localhost:9000
✅ [RAG] RAG System loaded - DuckDuckGo + Local KB
INFO:     Uvicorn running on http://0.0.0.0:9000 (Press CTRL+C to quit)
```

**✅ Thấy port 9000 = SUCCESS!**

**Nhấn Ctrl+C để thoát logs**

---

### Bước 7: Test Web UI

Mở trình duyệt trên máy tính:

**Port mới:** http://192.168.0.174:9000

**❌ Xóa cache nếu vẫn thấy giao diện cũ:**
- **Windows:** `Ctrl + Shift + R`
- **Mac:** `Cmd + Shift + R`
- **Hoặc:** Mở tab ẩn danh (Incognito)

---

## 🔍 KIỂM TRA BACKUP API KEYS

### Test 1: Web UI có 2 ô dự phòng

1. Mở http://192.168.0.174:9000
2. Click nút **⚙️ Cấu hình**
3. Cuộn xuống **API KEYS**
4. Xác nhận thấy:
   - **🔄 Gemini API Key (Dự phòng)** - viền cam
   - **🔄 Serper API Key (Dự phòng)** - viền cam

### Test 2: API endpoint trả về backup keys

```bash
curl http://192.168.0.174:9000/api/endpoints | jq '.gemini_api_key_backup, .serper_api_key_backup'
```

**Nếu chưa cấu hình, sẽ trả về:**
```json
""
""
```

**Sau khi nhập backup keys qua Web UI, sẽ trả về:**
```json
"AIzaSy...your_backup_key"
"abc123...serper_backup"
```

---

## 🐛 XỬ LÝ LỖI

### ❌ "Port 8000 already in use" (Container cũ chưa dừng)

```bash
docker ps -a
docker rm -f miniz-mcp-api
docker compose up -d
```

### ❌ "Cannot connect to Docker daemon"

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

### ❌ Git pull bị conflict

```bash
# Backup file local
cp xiaozhi_final.py xiaozhi_final.py.backup

# Reset về version GitHub
git reset --hard origin/main

# Pull lại
git pull origin main
```

### ❌ Docker build thất bại

```bash
# Xóa images cũ
docker image prune -a -f

# Xóa volumes
docker volume prune -f

# Build lại
docker compose build --no-cache
```

### ❌ Container start rồi lại crash

```bash
# Xem logs chi tiết
docker compose logs --tail=100

# Xem lỗi cụ thể
docker compose logs | grep -i error

# Restart với force recreate
docker compose down -v
docker compose up -d --force-recreate
```

---

## 📊 KIỂM TRA SAU KHI UPDATE

### Health Check Script

Chạy script này để kiểm tra toàn bộ:

```bash
echo "=== 1. Docker Status ===" && \
docker compose ps && \
echo -e "\n=== 2. Port Listening ===" && \
sudo lsof -i :9000 && \
echo -e "\n=== 3. Container Logs (last 10 lines) ===" && \
docker compose logs --tail=10 && \
echo -e "\n=== 4. API Test ===" && \
curl -s http://localhost:9000/api/system_info | jq '.status' && \
echo -e "\n=== 5. Backup Keys ===" && \
curl -s http://localhost:9000/api/endpoints | jq '{gemini_backup: .gemini_api_key_backup, serper_backup: .serper_api_key_backup}'
```

**Output mong đợi:**
```
=== 1. Docker Status ===
NAME            STATE   PORTS
miniz-mcp-api   Up      0.0.0.0:9000->9000/tcp

=== 2. Port Listening ===
python  1234 appuser   5u  IPv4  ... TCP *:9000 (LISTEN)

=== 3. Container Logs ===
INFO: Uvicorn running on http://0.0.0.0:9000

=== 4. API Test ===
"ok"

=== 5. Backup Keys ===
{
  "gemini_backup": "",
  "serper_backup": ""
}
```

---

## 🎯 CẤU HÌNH BACKUP KEYS QUA WEB UI

### Sau khi update xong:

1. **Mở Web UI:** http://192.168.0.174:9000
2. **Click:** ⚙️ Cấu hình
3. **Cuộn xuống API KEYS section**
4. **Điền backup keys:**

   **Gemini Backup (viền cam):**
   - Lấy key thứ 2 từ: https://aistudio.google.com/apikey
   - Paste vào ô **🔄 Gemini API Key (Dự phòng)**

   **Serper Backup (viền cam):**
   - Đăng ký tài khoản thứ 2: https://serper.dev
   - Paste vào ô **🔄 Serper API Key (Dự phòng)**

5. **Hệ thống tự động lưu** sau 1 giây
6. Xác nhận thấy: **✓ Key dự phòng đã lưu** (màu xanh)

---

## 🔄 AUTO-FALLBACK TEST

### Test tự động chuyển key:

1. **Tạm vô hiệu hóa Gemini key chính** (nhập sai key)
2. **Hỏi AI:** "Thời tiết hôm nay thế nào?"
3. **Xem logs:**
```bash
docker compose logs -f | grep -i backup
```

**Kết quả mong đợi:**
```
🔄 [Gemini] Primary key failed: invalid API key
🔄 [Gemini] Switching to BACKUP key: ...abc12345
✅ [Gemini] Backup key saved to config
🔄 [Gemini] Đang retry với backup key...
✅ [Gemini] Backup key thành công!
```

4. **Xác nhận keys đã swap:**
```bash
curl http://localhost:9000/api/endpoints | jq '.gemini_api_key, .gemini_api_key_backup'
```

**Trước swap:**
```json
"AIzaSy...primary_key"
"AIzaSy...backup_key"
```

**Sau swap:**
```json
"AIzaSy...backup_key"    // Đã đổi chỗ
"AIzaSy...primary_key"   // Đã đổi chỗ
```

---

## 📝 CHECKLIST HOÀN THÀNH

Tick dấu ✓ khi hoàn thành:

- [ ] SSH vào Pi thành công
- [ ] `docker compose down` OK
- [ ] `git pull origin main` đã pull code mới
- [ ] `docker compose build --no-cache` build thành công (3-5 phút)
- [ ] `docker compose up -d` container đã start
- [ ] `docker compose logs -f` thấy **port 9000** và **Uvicorn running**
- [ ] Mở http://192.168.0.174:9000 thấy Web UI
- [ ] Web UI có 2 ô backup keys (viền cam)
- [ ] Nhập Gemini backup key → thấy **✓ Key dự phòng đã lưu**
- [ ] Nhập Serper backup key → thấy **✓ Key dự phòng đã lưu**
- [ ] Test API: `curl http://localhost:9000/api/endpoints` trả về backup keys
- [ ] (Optional) Test auto-fallback bằng cách vô hiệu hóa primary key

---

## 🆘 CẦN HỖ TRỢ?

### Nếu vẫn gặp vấn đề:

**1. Chụp màn hình logs:**
```bash
docker compose logs --tail=50 > /tmp/docker_logs.txt
cat /tmp/docker_logs.txt
```

**2. Kiểm tra version:**
```bash
cd ~/apps/pimcp
git log --oneline -n 3
```

**3. Kiểm tra file đã update chưa:**
```bash
grep -n "port=9000" xiaozhi_final.py
# Nếu có kết quả = file đã mới
# Nếu không có = file chưa update
```

**4. Force update bằng cách copy trực tiếp:**

Nếu git pull không work, có thể copy file từ Windows:

- **Windows:** Mở `\\192.168.0.174\apps\pimcp\` (SMB share)
- Copy file `xiaozhi_final.py` mới từ local vào Pi
- Hoặc dùng `scp`:
  ```bash
  scp xiaozhi_final.py huy123@192.168.0.174:~/apps/pimcp/
  ```

---

## 🎉 SAU KHI UPDATE THÀNH CÔNG

**Pi đã chạy version mới với:**
- ✅ Port 9000 (thay vì 8000)
- ✅ Backup API Keys (Gemini + Serper)
- ✅ Auto-fallback khi key chính fail
- ✅ 40 câu đố vui + 15 truyện cổ tích
- ✅ Smart startup (tiết kiệm RAM)

**Truy cập:** http://192.168.0.174:9000

**Test voice:** "Đố em một câu" hoặc "Kể chuyện cổ tích"

---

**✨ Done! ✨**
