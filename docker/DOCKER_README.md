# 🐳 miniZ MCP Docker - Hướng Dẫn Cài Đặt

## 📋 Yêu Cầu Hệ Thống

- Docker Engine 20.10+
- Docker Compose v2.0+
- RAM: tối thiểu 512MB
- Disk: 500MB+

## 🚀 Cài Đặt Nhanh

### Bước 1: Vào thư mục docker
```bash
cd docker
```

### Bước 2: Tạo file .env từ template
```bash
# Linux/Mac
cp .env.example .env

# Windows PowerShell
Copy-Item .env.example .env
```

### Bước 3: Cập nhật API keys trong file .env
```bash
# Mở file .env và điền các API keys
GEMINI_API_KEY=your_real_api_key
OPENAI_API_KEY=your_openai_key  # tùy chọn
```

### Bước 4: Build và chạy
```bash
docker-compose up -d --build
```

### Bước 5: Kiểm tra
```bash
# Xem logs
docker-compose logs -f

# Kiểm tra health
curl http://localhost:8000/api/system_info
```

## 📌 Các Lệnh Thường Dùng

```bash
# Khởi động
docker-compose up -d

# Dừng
docker-compose down

# Restart
docker-compose restart

# Xem logs
docker-compose logs -f miniz-api

# Rebuild
docker-compose up -d --build --force-recreate

# Vào container
docker-compose exec miniz-api /bin/bash
```

## 🔧 Build Thủ Công (Không dùng docker-compose)

```bash
# Build image
docker build -t miniz-mcp:latest -f docker/Dockerfile .

# Chạy container
docker run -d \
  --name miniz-api \
  -p 8000:8000 \
  -e GEMINI_API_KEY=your_key \
  -v $(pwd)/xiaozhi_endpoints.json:/app/xiaozhi_endpoints.json \
  miniz-mcp:latest
```

## 🌐 API Endpoints

Sau khi chạy, truy cập:

| Endpoint | Mô tả |
|----------|-------|
| http://localhost:8000 | Web UI chính |
| http://localhost:8000/docs | Swagger API docs |
| http://localhost:8000/api/system_info | System info |
| http://localhost:8000/api/resources | Resource monitor |

## 📁 Cấu Trúc Files

```
docker/
├── Dockerfile              # Image definition
├── docker-compose.yml      # Service orchestration
├── requirements-docker.txt # Python dependencies
├── .env.example           # Environment template
├── .dockerignore          # Build exclusions
└── DOCKER_README.md       # Hướng dẫn này
```

## ⚙️ Cấu Hình Nâng Cao

### Thay đổi port
Sửa trong docker-compose.yml:
```yaml
ports:
  - "3000:8000"  # Đổi từ 8000 sang 3000
```

### Thêm Redis cache
Bỏ comment phần redis trong docker-compose.yml

### Mount thêm volumes
```yaml
volumes:
  - ./custom_config:/app/config
```

## 🔒 Bảo Mật

1. **Không commit file .env** - File này chứa API keys
2. **Dùng Docker secrets** cho production
3. **Restrict network** nếu không cần expose public

## 🆘 Troubleshooting

### Container không start
```bash
docker-compose logs miniz-api
```

### Port đã được dùng
```bash
# Tìm process đang dùng port
netstat -tulpn | grep 8000

# Hoặc đổi port trong docker-compose.yml
```

### Permission denied
```bash
# Đặt quyền cho volumes
chmod -R 755 ./data ./logs
```

## 📞 Hỗ Trợ

- Issues: https://github.com/miniz/mcp/issues
- Email: support@miniz.team
