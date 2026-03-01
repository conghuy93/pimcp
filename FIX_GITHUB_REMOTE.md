# 🔗 FIX GITHUB REMOTE - PI CẬP NHẬT ĐÚNG REPO

**Vấn đề:** Pi đang pull từ GitHub repository SAI  
**Pi IP:** 192.168.0.174

---

## ✅ LINK GITHUB ĐÚNG

```
https://github.com/conghuy93/pimcp.git
```

**⚠️ KHÔNG PHẢI:**
- ~~https://github.com/nguyenconghuy2904-source/pimcp.git~~ (repo cũ/sai)

---

## ⚡ FIX NGAY - 5 BƯỚC

### Bước 1: SSH vào Pi

```bash
ssh huy123@192.168.0.174
```

---

### Bước 2: Kiểm tra remote hiện tại

```bash
cd ~/apps/pimcp
git remote -v
```

**Output hiện tại (SAI):**
```
origin  https://github.com/nguyenconghuy2904-source/pimcp.git (fetch)
origin  https://github.com/nguyenconghuy2904-source/pimcp.git (push)
```

**Output đúng (PHẢI THẤY):**
```
origin  https://github.com/conghuy93/pimcp.git (fetch)
origin  https://github.com/conghuy93/pimcp.git (push)
```

---

### Bước 3: Đổi sang remote ĐÚNG

```bash
git remote set-url origin https://github.com/conghuy93/pimcp.git
```

**Xác nhận lại:**
```bash
git remote -v
```

**Phải thấy:**
```
origin  https://github.com/conghuy93/pimcp.git (fetch)
origin  https://github.com/conghuy93/pimcp.git (push)
```

✅ **OK!**

---

### Bước 4: Pull code mới từ repo đúng

```bash
git fetch origin
git reset --hard origin/main
git pull origin main
```

**Output mong đợi:**
```
From https://github.com/conghuy93/pimcp
 * branch            main       -> FETCH_HEAD
Already up to date.
hoặc
Updating abc1234..def5678
Fast-forward
 xiaozhi_final.py | 150 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 120 insertions(+), 30 deletions(-)
```

---

### Bước 5: Rebuild Docker với code mới

```bash
cd docker
docker compose down
docker compose build --no-cache
docker compose up -d
docker compose logs -f
```

**Tìm dòng này để xác nhận:**
```
🌐 Web: http://localhost:9000
INFO: Uvicorn running on http://0.0.0.0:9000
```

**Nhấn Ctrl+C để thoát logs**

---

## 🎯 ONE-LINER FIX (Copy toàn bộ)

```bash
cd ~/apps/pimcp && \
git remote set-url origin https://github.com/conghuy93/pimcp.git && \
git fetch origin && \
git reset --hard origin/main && \
git pull origin main && \
cd docker && \
docker compose down && \
docker compose build --no-cache && \
docker compose up -d && \
docker compose logs -f
```

**Giải thích:**
1. Vào thư mục project
2. Đổi remote sang repo đúng
3. Fetch từ repo mới
4. Reset code về version GitHub
5. Pull code mới
6. Vào thư mục docker
7. Dừng container cũ
8. Build image mới
9. Start container
10. Xem logs (Ctrl+C để thoát)

---

## 🔍 KIỂM TRA SAU KHI FIX

### Test 1: Remote đã đổi chưa

```bash
cd ~/apps/pimcp
git remote -v
```

**Phải thấy:** `conghuy93/pimcp` (ĐÚNG)

---

### Test 2: Code đã mới chưa

```bash
cd ~/apps/pimcp
git log --oneline -n 3
```

**Phải thấy các commit gần đây:**
```
def5678 Fix: Update port from 8000 to 9000
abc1234 Add: Backup API keys with auto-failover
xyz9876 Add: Riddles and Fairy Tales RAG
```

---

### Test 3: Docker đã chạy port 9000 chưa

```bash
docker logs miniz-mcp-api --tail 20 | grep "9000"
```

**Phải thấy:**
```
🌐 Web: http://localhost:9000
INFO: Uvicorn running on http://0.0.0.0:9000
```

---

### Test 4: Web UI mới chưa

Mở trình duyệt: **http://192.168.0.174:9000**

**Hard refresh:** `Ctrl + Shift + R`

Click **⚙️ Cấu hình** → Phải thấy:
- ✅ 2 ô backup keys (viền cam)
- ✅ **🔄 Gemini API Key (Dự phòng)**
- ✅ **🔄 Serper API Key (Dự phòng)**

---

## 🐛 XỬ LÝ LỖI

### ❌ Git pull conflict

```bash
cd ~/apps/pimcp
git stash
git pull origin main
git stash pop
```

### ❌ "fatal: refusing to merge unrelated histories"

```bash
cd ~/apps/pimcp
git fetch origin
git reset --hard origin/main
```

**⚠️ Warning:** Mất toàn bộ thay đổi local! Backup trước nếu cần.

### ❌ Docker build fail

```bash
cd ~/apps/pimcp/docker
docker system prune -a -f
docker compose build --no-cache
```

---

## 📊 SO SÁNH 2 REPOS

| Repo | Status | Sử dụng |
|------|--------|---------|
| `conghuy93/pimcp` | ✅ **ĐÚNG** | Repo chính, code mới nhất |
| `nguyenconghuy2904-source/pimcp` | ❌ **SAI** | Repo cũ, không còn cập nhật |

**Lịch sử:**
- Repo cũ: `nguyenconghuy2904-source` (fork hoặc test repo)
- Repo chính: `conghuy93` (production, có backup keys)

---

## 🎯 CHECKLIST

Tick ✓ khi hoàn thành:

- [ ] SSH vào Pi OK
- [ ] `git remote -v` thấy `conghuy93/pimcp`
- [ ] `git pull origin main` đã pull code mới
- [ ] `docker compose build` build thành công
- [ ] `docker compose logs` thấy **port 9000**
- [ ] Web UI http://192.168.0.174:9000 hoạt động
- [ ] Web UI có 2 ô backup keys (viền cam)
- [ ] Test API: `curl localhost:9000/api/endpoints` OK

---

## 📝 LƯU Ý

### Sau khi đổi remote:

**Clone mới thì dùng:**
```bash
git clone https://github.com/conghuy93/pimcp.git
```

**Update thì dùng:**
```bash
cd ~/apps/pimcp
git pull origin main
```

---

## 🔗 LINKS

- **Repo chính:** https://github.com/conghuy93/pimcp
- **Issues:** https://github.com/conghuy93/pimcp/issues
- **Web UI:** http://192.168.0.174:9000

---

**✨ Done! Pi đã pull từ repo ĐÚNG ✨**
