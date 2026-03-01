# 🐳 miniZ MCP Docker Edition

[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://www.docker.com/)
[![Python](https://img.shields.io/badge/Python-3.11-green.svg)](https://www.python.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.104-009688.svg)](https://fastapi.tiangolo.com/)

FastAPI-based MCP (Model Context Protocol) server tối giản, chạy trong Docker container.

## ✨ Tính Năng

- 🚀 FastAPI với WebSocket hỗ trợ
- 🔌 30+ MCP Tools tích hợp
- 🤖 Hỗ trợ Gemini & OpenAI API
- 🐳 Docker containerized - deploy dễ dàng
- 📊 API docs tự động (Swagger)
- 🔒 Encryption cho API keys
- 💾 Persistent data với volumes

## 📋 Yêu Cầu

- Docker Engine 20.10+
- Docker Compose v2.0+
- RAM: 512MB+
- Disk: 500MB+

## 🚀 Quick Start

### 1. Clone Repository

```bash
git clone https://github.com/conghuy93/pimcp.git
cd pimcp/docker
```

### 2. Cấu Hình API Keys

```bash
# Copy template
cp .env.example .env

# Sửa file .env, điền API keys
GEMINI_API_KEY=your_gemini_api_key_here
```

### 3. Chạy Docker

**Windows:**
```cmd
docker-build.bat
```

**Linux/Mac:**
```bash
./docker-build.sh
```

**Hoặc dùng docker-compose:**
```bash
docker-compose up -d --build
```

### 4. Truy Cập

- **Web UI:** http://localhost:8000
- **API Docs:** http://localhost:8000/docs
- **Health Check:** http://localhost:8000/api/system_info

## 📁 Cấu Trúc Project

```
pimcp/
├── docker/                    # Docker files
│   ├── Dockerfile
│   ├── docker-compose.yml
│   ├── requirements-docker.txt
│   └── DOCKER_README.md
├── xiaozhi_final.py          # Main FastAPI app
├── config_manager.py         # Config management
├── static/                   # Frontend
└── templates/                # HTML templates
```

## 🔧 Các Lệnh Docker Cơ Bản

```bash
# Start
docker-compose up -d

# Stop
docker-compose down

# Logs
docker-compose logs -f

# Rebuild
docker-compose up -d --build
```

## 🌐 API Endpoints

| Endpoint | Mô tả |
|----------|-------|
| `/` | Web UI chính |
| `/docs` | Swagger API docs |
| `/api/system_info` | System info |
| `/api/resources` | CPU, RAM, Disk |
| `/api/send_message_to_llm` | Gửi message tới LLM |

## 📖 Documentation

Chi tiết xem: [docker/DOCKER_README.md](docker/DOCKER_README.md)

## 👨‍💻 Author

**Nguyen Cong Huy**
- GitHub: [@conghuy93](https://github.com/conghuy93)
- Repository: [conghuy93/pimcp](https://github.com/conghuy93/pimcp)

---

© 2026 miniZ MCP Team
