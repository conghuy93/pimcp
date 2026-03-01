# 🚀 QUICK START - RASPBERRY PI DOCKER

**Phiên bản:** v4.3.x với Backup API Keys  
**Port:** 9000  
**GitHub:** https://github.com/conghuy93/pimcp

---

## ⚡ CÁC LỆNH THƯỜNG DÙNG

### 1. Dừng container
```bash
cd ~/apps/pimcp/docker
docker compose down
```

### 2. Cập nhật code mới
```bash
cd ~/apps/pimcp
git pull origin main
```

### 3. Build lại image
```bash
cd docker
docker compose build --no-cache
```

### 4. Start container
```bash
docker compose up -d
```

### 5. Xem logs real-time
```bash
docker compose logs -f
```
**Nhấn Ctrl+C để thoát**

### 6. Xem logs cuối cùng
```bash
docker compose logs --tail=50
```

### 7. Restart container
```bash
docker compose restart
```

### 8. Kiểm tra status
```bash
docker compose ps
```

### 9. Vào bên trong container
```bash
docker compose exec miniz-mcp-api /bin/bash
```
**Gõ `exit` để thoát**

### 10. Xóa tất cả và build lại từ đầu
```bash
docker compose down -v
docker compose up -d --build
```

---

## 🔧 ONE-LINER UPDATE COMMAND

**Cập nhật nhanh (Pull + Rebuild + Start):**
```bash
cd ~/apps/pimcp && \
git pull origin main && \
cd docker && \
docker compose down && \
docker compose up -d --build && \
docker compose logs -f
```

Nhấn **Ctrl+C** sau khi thấy: `Uvicorn running on http://0.0.0.0:9000`

---

## 🌐 TRUY CẬP WEB UI

### Lấy IP của Pi
```bash
hostname -I
```
Ví dụ: `192.168.1.100`

### Mở trình duyệt
- **Web UI:** http://192.168.1.100:9000
- **API Docs:** http://192.168.1.100:9000/docs

---

## 🔍 DEBUG & TROUBLESHOOTING

### Xem tất cả errors
```bash
docker compose logs | grep -i error
```

### Xem tài nguyên đang dùng
```bash
docker stats miniz-mcp-api
```

### Kiểm tra port 9000
```bash
sudo lsof -i :9000
```

### Xem config file hiện tại
```bash
docker compose exec miniz-mcp-api cat /app/config/xiaozhi_endpoints.json | jq '.'
```

### Test API từ Pi
```bash
curl http://localhost:9000/api/system_info | jq '.'
```

### Xem backup keys
```bash
curl http://localhost:9000/api/endpoints | jq '.gemini_api_key_backup, .serper_api_key_backup'
```

---

## 📊 GIÁM SÁT CONTAINER

### Real-time stats (CPU, RAM, Network)
```bash
docker stats miniz-mcp-api
```

### Xem disk usage của container
```bash
docker compose exec miniz-mcp-api df -h
```

### Xem processes bên trong container
```bash
docker compose exec miniz-mcp-api ps aux
```

---

## 🔄 BACKUP & RESTORE

### Backup config file
```bash
docker compose exec miniz-mcp-api cat /app/config/xiaozhi_endpoints.json > /tmp/backup_config.json
```

### Restore config file
```bash
cat /tmp/backup_config.json | docker compose exec -T miniz-mcp-api tee /app/config/xiaozhi_endpoints.json > /dev/null
docker compose restart
```

---

## 🆘 EMERGENCY COMMANDS

### Container không start được
```bash
docker compose down -v
docker system prune -f
docker compose up -d --build --force-recreate
```

### Xóa tất cả images cũ
```bash
docker image prune -a -f
```

### Reset Docker hoàn toàn (NGUY HIỂM - mất tất cả container!)
```bash
docker system prune -a --volumes -f
```

---

## 📱 SSH NHANH

### SSH từ Windows
```cmd
ssh huy123@192.168.1.100
```

### SSH từ Mac/Linux
```bash
ssh huy123@192.168.1.100
```

### Copy file từ PC sang Pi
```bash
scp /path/to/file.json huy123@192.168.1.100:~/apps/pimcp/docker/
```

### Copy file từ Pi về PC
```bash
scp huy123@192.168.1.100:~/apps/pimcp/docker/config.json ./
```

---

## 🎯 QUICK HEALTH CHECK

**Chạy lệnh này để kiểm tra toàn bộ:**
```bash
echo "=== Docker Status ===" && \
docker compose ps && \
echo -e "\n=== Latest Logs ===" && \
docker compose logs --tail=10 && \
echo -e "\n=== Container Stats ===" && \
docker stats miniz-mcp-api --no-stream && \
echo -e "\n=== API Test ===" && \
curl -s http://localhost:9000/api/system_info | jq '.status' && \
echo -e "\n=== Backup Keys ===" && \
curl -s http://localhost:9000/api/endpoints | jq '{gemini_backup: .gemini_api_key_backup, serper_backup: .serper_api_key_backup}'
```

---

## 📝 NOTES

- **Port mới:** 9000 (thay vì 8000)
- **Config file:** `/app/config/xiaozhi_endpoints.json` trong container
- **Volume:** `miniz_config:/app/config` (persistent)
- **User trong container:** `appuser` (non-root)
- **Python version:** 3.11

---

## 🔗 LINKS

- **Repository:** https://github.com/conghuy93/pimcp
- **Issues:** https://github.com/conghuy93/pimcp/issues
- **Gemini Keys:** https://aistudio.google.com/apikey
- **Serper Keys:** https://serper.dev
