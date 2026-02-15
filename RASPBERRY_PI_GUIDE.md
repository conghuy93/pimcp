# 🥧 HƯỚNG DẪN CÀI ĐẶT TRÊN RASPBERRY PI

**Repository:** https://github.com/conghuy93/pimcp

Hướng dẫn deploy miniZ MCP FastAPI server trên Raspberry Pi bằng Docker.

---

## 📋 YÊU CẦU HỆ THỐNG

### Raspberry Pi
- **Model:** Pi 3B+, Pi 4, Pi 5 (đề xuất Pi 4 trở lên)
- **RAM:** Tối thiểu 1GB (đề xuất 2GB+)
- **Storage:** 8GB+ (đề xuất 16GB+)
- **OS:** Raspberry Pi OS (64-bit đề xuất)

### Phần mềm cần thiết
- Docker Engine
- Docker Compose
- Git

---

## 🚀 BƯỚC 1: CÀI ĐẶT DOCKER TRÊN PI

### 1.1. Cập nhật hệ thống

```bash
sudo apt update && sudo apt upgrade -y
```

### 1.2. Cài Docker

```bash
# Cài Docker bằng script chính thức
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Thêm user vào docker group (không cần sudo)
sudo usermod -aG docker $USER

# Khởi động Docker
sudo systemctl enable docker
sudo systemctl start docker

# Logout và login lại để áp dụng group
```

### 1.3. Cài Docker Compose

```bash
# Cài Docker Compose v2 (plugin)
sudo apt install docker-compose-plugin -y

# Hoặc standalone version
sudo apt install docker-compose -y

# Kiểm tra
docker --version
docker compose version
```

**Kết quả mong đợi:**
```
Docker version 24.0+
Docker Compose version v2.20+
```

---

## 📥 BƯỚC 2: TẢI CODE TỪ GITHUB

### 2.1. Cài Git (nếu chưa có)

```bash
sudo apt install git -y
```

### 2.2. Clone repository

```bash
# Tạo thư mục cho project
mkdir -p ~/apps
cd ~/apps

# Clone code
git clone https://github.com/conghuy93/pimcp.git
cd pimcp

# Kiểm tra cấu trúc
ls -la
```

**Bạn sẽ thấy:**
```
docker/
xiaozhi_final.py
config_manager.py
README.md
```

---

## ⚙️ BƯỚC 3: CẤU HÌNH API KEYS

### 3.1. Vào thư mục docker

```bash
cd docker
```

### 3.2. Tạo file .env từ template

```bash
cp .env.example .env
```

### 3.3. Sửa file .env

```bash
nano .env
```

**Nội dung cần điền:**
```bash
# Gemini API Key (BẮT BUỘC)
GEMINI_API_KEY=AIzaSy...your_actual_key_here

# OpenAI (Tùy chọn)
OPENAI_API_KEY=sk-...your_openai_key

# Serper (Tùy chọn - cho Google Search)
SERPER_API_KEY=your_serper_key
```

**Lưu file:** `Ctrl+O`, Enter, `Ctrl+X`

### 3.4. Lấy Gemini API Key

1. Truy cập: https://makersuite.google.com/app/apikey
2. Đăng nhập Google
3. Click "Create API Key"
4. Copy key và paste vào file `.env`

---

## 🐳 BƯỚC 4: CHẠY DOCKER

### 4.1. Build và Start (Cách 1 - Dùng script)

```bash
# Cho phép chạy script
chmod +x docker-build.sh

# Chạy script
./docker-build.sh
```

**Menu hiện ra, chọn:**
- `1` - Build & Start

### 4.2. Build và Start (Cách 2 - Docker Compose trực tiếp)

```bash
# Build image và start container
docker compose up -d --build

# Hoặc dùng docker-compose (version cũ)
docker-compose up -d --build
```

**Flag giải thích:**
- `-d`: Chạy background (detached mode)
- `--build`: Build lại image nếu có thay đổi

### 4.3. Theo dõi quá trình build

```bash
# Xem logs real-time
docker compose logs -f

# Hoặc chỉ xem logs của miniz-api
docker compose logs -f miniz-api
```

**Nhấn Ctrl+C để thoát logs (container vẫn chạy)**

---

## ✅ BƯỚC 5: KIỂM TRA VÀ TRUY CẬP

### 5.1. Kiểm tra container đang chạy

```bash
docker compose ps
```

**Kết quả mong đợi:**
```
NAME            STATE   PORTS
miniz-mcp-api   Up      0.0.0.0:8000->8000/tcp
```

### 5.2. Kiểm tra health

```bash
# Test từ Pi
curl http://localhost:8000/api/system_info

# Xem logs
docker compose logs --tail=50 miniz-api
```

### 5.3. Lấy địa chỉ IP của Pi

```bash
hostname -I
```

Ví dụ: `192.168.1.100`

### 5.4. Truy cập từ máy khác trong mạng

Mở trình duyệt trên máy tính/điện thoại:

- **Web UI:** http://192.168.1.100:8000
- **API Docs (Swagger):** http://192.168.1.100:8000/docs
- **System Info:** http://192.168.1.100:8000/api/system_info

---

## 🔧 CÁC LỆNH QUẢN LÝ

### Xem status
```bash
docker compose ps
```

### Dừng service
```bash
docker compose down
```

### Khởi động lại
```bash
docker compose restart
```

### Xem logs
```bash
# Tất cả logs
docker compose logs

# Real-time logs
docker compose logs -f

# 100 dòng cuối
docker compose logs --tail=100
```

### Vào bên trong container
```bash
docker compose exec miniz-api /bin/bash
```

### Rebuild lại image
```bash
docker compose up -d --build --force-recreate
```

### Xóa tất cả (container + volumes)
```bash
docker compose down -v
```

---

## 📊 GIÁM SÁT TÀI NGUYÊN

### Xem tài nguyên container đang dùng

```bash
docker stats miniz-mcp-api
```

**Bạn sẽ thấy:**
- CPU %
- Memory usage
- Network I/O
- Disk I/O

**Nhấn Ctrl+C để thoát**

### Giám sát Pi

```bash
# CPU temperature
vcgencmd measure_temp

# Memory
free -h

# Disk usage
df -h
```

---

## 🔄 CẬP NHẬT CODE MỚI

Khi có update trên GitHub:

```bash
# Dừng container
cd ~/apps/pimcp/docker
docker compose down

# Pull code mới
cd ~/apps/pimcp
git pull origin main

# Rebuild và start
cd docker
docker compose up -d --build
```

---

## 🌐 TRUY CẬP TỪ INTERNET (Tùy chọn)

### Cách 1: Port Forwarding trên Router

1. Vào trang quản trị router (thường 192.168.1.1)
2. Tìm Port Forwarding / Virtual Server
3. Thêm rule:
   - External Port: `8000`
   - Internal IP: `192.168.1.100` (IP Pi)
   - Internal Port: `8000`
   - Protocol: `TCP`
4. Truy cập: `http://your-public-ip:8000`

### Cách 2: Cloudflare Tunnel (An toàn hơn)

```bash
# Cài cloudflared
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64.deb
sudo dpkg -i cloudflared-linux-arm64.deb

# Login
cloudflared tunnel login

# Tạo tunnel
cloudflared tunnel create pimcp

# Chạy tunnel
cloudflared tunnel --url http://localhost:8000
```

### Cách 3: Ngrok (Nhanh nhất - Free tier)

```bash
# Tải ngrok
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm64.tgz
tar xvf ngrok-v3-stable-linux-arm64.tgz
sudo mv ngrok /usr/local/bin/

# Chạy
ngrok http 8000
```

Ngrok sẽ cho bạn URL public: `https://abc123.ngrok.io`

---

## 🚨 KHẮC PHỤC SỰ CỐ

### Container không start

```bash
# Xem logs chi tiết
docker compose logs miniz-api

# Kiểm tra port có bị chiếm không
sudo netstat -tulpn | grep 8000
```

### Out of Memory

```bash
# Kiểm tra memory
free -h

# Tăng swap
sudo dphys-swapfile swapoff
sudo nano /etc/dphys-swapfile
# Đổi CONF_SWAPSIZE=2048
sudo dphys-swapfile setup
sudo dphys-swapfile swapon
```

### Build quá lâu

Bình thường trên Pi 4, build mất ~5-10 phút lần đầu.

```bash
# Theo dõi progress
docker compose up --build
```

### Permission denied

```bash
# Thêm user vào docker group
sudo usermod -aG docker $USER

# Logout và login lại
logout
```

### Không truy cập được từ máy khác

```bash
# Kiểm tra firewall
sudo ufw status

# Mở port 8000
sudo ufw allow 8000/tcp
```

---

## 🔒 BẢO MẬT

### 1. Đổi port mặc định

Sửa file `docker-compose.yml`:

```yaml
ports:
  - "3000:8000"  # Đổi từ 8000 sang 3000
```

### 2. Chỉ cho phép truy cập local

```yaml
ports:
  - "127.0.0.1:8000:8000"  # Chỉ localhost
```

### 3. Thêm Basic Auth (nginx reverse proxy)

```bash
# Cài nginx
sudo apt install nginx -y

# Cấu hình reverse proxy với authentication
# (Chi tiết xem file nginx-auth-example.conf)
```

---

## 📈 TỐI ÔN HIỆU SUẤT

### 1. Giới hạn tài nguyên container

Sửa `docker-compose.yml`:

```yaml
services:
  miniz-api:
    # ... existing config ...
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 1G
        reservations:
          memory: 512M
```

### 2. Tăng swap cho Pi

```bash
sudo dphys-swapfile swapoff
sudo nano /etc/dphys-swapfile
# CONF_SWAPSIZE=2048
sudo dphys-swapfile setup
sudo dphys-swapfile swapon
```

### 3. Overclock Pi 4 (Cẩn thận!)

```bash
sudo nano /boot/config.txt
# Thêm:
# over_voltage=6
# arm_freq=2000
```

---

## 🔄 TỰ ĐỘNG KHỞI ĐỘNG CÙNG PI

Docker container đã được cấu hình `restart: unless-stopped` nên sẽ tự động start khi Pi reboot.

Kiểm tra:

```bash
# Reboot Pi
sudo reboot

# Sau khi Pi khởi động lại, check container
docker compose ps
```

---

## 📝 CHECKLIST HOÀN CHỈNH

- [ ] Đã cài Docker và Docker Compose
- [ ] Clone code từ GitHub
- [ ] Tạo file .env và điền API keys
- [ ] Build và start container thành công
- [ ] Truy cập được Web UI từ browser
- [ ] Kiểm tra logs không có lỗi
- [ ] Test API endpoints hoạt động
- [ ] Container tự động restart sau khi reboot Pi

---

## 🎉 HOÀN TẤT!

Server MCP của bạn đang chạy trên Raspberry Pi tại:

**🌐 http://[Pi-IP]:8000**

### Các endpoints hữu ích:

| URL | Mô tả |
|-----|-------|
| / | Web UI chính |
| /docs | Swagger API documentation |
| /api/system_info | Thông tin hệ thống |
| /api/resources | CPU, RAM, Disk usage |
| /api/quotas | API quotas |

---

## 📞 HỖ TRỢ

- **GitHub Issues:** https://github.com/conghuy93/pimcp/issues
- **Docker Docs:** https://docs.docker.com/
- **Pi Forums:** https://www.raspberrypi.org/forums/

---

**© 2026 miniZ MCP Team**
