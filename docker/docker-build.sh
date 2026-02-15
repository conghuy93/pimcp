#!/bin/bash
# ============================================================
# miniZ MCP Docker - Build & Run Script
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "🐳 miniZ MCP Docker Builder"
echo "================================"

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker không được cài đặt!"
    echo "   Vui lòng cài Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check .env
if [ ! -f .env ]; then
    echo "⚠️  File .env chưa tồn tại"
    echo "   Đang tạo từ .env.example..."
    cp .env.example .env
    echo "📝 Vui lòng cập nhật API keys trong docker/.env"
    echo ""
fi

# Menu
echo ""
echo "Chọn hành động:"
echo "  1) Build & Start"
echo "  2) Start (không build lại)"
echo "  3) Stop"
echo "  4) Restart"
echo "  5) Logs"
echo "  6) Status"
echo "  0) Exit"
echo ""
read -p "Lựa chọn [1]: " choice
choice=${choice:-1}

case $choice in
    1)
        echo "🔨 Building Docker image..."
        docker-compose up -d --build
        echo ""
        echo "✅ Done! API đang chạy tại: http://localhost:8000"
        ;;
    2)
        echo "▶️  Starting containers..."
        docker-compose up -d
        echo "✅ Started!"
        ;;
    3)
        echo "⏹️  Stopping containers..."
        docker-compose down
        echo "✅ Stopped!"
        ;;
    4)
        echo "🔄 Restarting containers..."
        docker-compose restart
        echo "✅ Restarted!"
        ;;
    5)
        echo "📋 Showing logs (Ctrl+C to exit)..."
        docker-compose logs -f
        ;;
    6)
        echo "📊 Container Status:"
        docker-compose ps
        ;;
    0)
        echo "👋 Bye!"
        exit 0
        ;;
    *)
        echo "❌ Lựa chọn không hợp lệ"
        exit 1
        ;;
esac
