#!/bin/bash
# ============================================================
# Install Script for Raspberry Pi - ONE COMMAND INSTALL
# Repository: https://github.com/conghuy93/pimcp
# ============================================================

set -e

echo ""
echo "🥧 =========================================="
echo "   miniZ MCP - Raspberry Pi Installer"
echo "   =========================================="
echo ""

# Kiểm tra quyền root cho một số lệnh
if [ "$EUID" -eq 0 ]; then 
   echo "⚠️  Không nên chạy script này với sudo!"
   echo "   Chạy: ./install-pi.sh"
   exit 1
fi

# Bước 1: Cập nhật hệ thống
echo "📦 [1/6] Updating system..."
sudo apt update

# Bước 2: Cài Docker nếu chưa có
if ! command -v docker &> /dev/null; then
    echo "🐳 [2/6] Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
    echo "✅ Docker installed!"
else
    echo "✅ [2/6] Docker already installed"
fi

# Bước 3: Cài Docker Compose nếu chưa có
if ! command -v docker-compose &> /dev/null; then
    echo "🔧 [3/6] Installing Docker Compose..."
    sudo apt install docker-compose-plugin -y
    echo "✅ Docker Compose installed!"
else
    echo "✅ [3/6] Docker Compose already installed"
fi

# Bước 4: Clone repository
echo "📥 [4/6] Cloning repository..."
INSTALL_DIR="$HOME/apps/pimcp"

if [ -d "$INSTALL_DIR" ]; then
    echo "⚠️  Directory $INSTALL_DIR already exists"
    read -p "   Delete and re-clone? (y/N): " confirm
    if [[ $confirm =~ ^[Yy]$ ]]; then
        rm -rf "$INSTALL_DIR"
    else
        echo "❌ Installation cancelled"
        exit 1
    fi
fi

mkdir -p "$HOME/apps"
cd "$HOME/apps"
git clone https://github.com/conghuy93/pimcp.git
cd pimcp/docker

echo "✅ Repository cloned to $INSTALL_DIR"

# Bước 5: Cấu hình .env
echo ""
echo "⚙️  [5/6] Configuration..."

if [ ! -f .env ]; then
    cp .env.example .env
    echo "📝 Created .env file"
    echo ""
    echo "⚠️  QUAN TRỌNG: Bạn cần điền API keys!"
    echo ""
    read -p "Nhập Gemini API Key (hoặc Enter để bỏ qua): " gemini_key
    
    if [ ! -z "$gemini_key" ]; then
        sed -i "s/your_gemini_api_key_here/$gemini_key/" .env
        echo "✅ Gemini API key đã được lưu"
    else
        echo "⚠️  Bạn cần sửa file .env sau:"
        echo "   nano $INSTALL_DIR/docker/.env"
    fi
else
    echo "✅ .env file already exists"
fi

# Bước 6: Build và Start
echo ""
echo "🚀 [6/6] Building Docker image..."
echo "    (Quá trình này có thể mất 5-10 phút trên Pi...)"
echo ""

docker compose up -d --build

echo ""
echo "=========================================="
echo "   ✅ CÀI ĐẶT THÀNH CÔNG!"
echo "=========================================="
echo ""
echo "📊 Container Status:"
docker compose ps
echo ""
echo "🌐 Truy cập Web UI:"
echo "   Local:  http://localhost:8000"
echo "   Remote: http://$(hostname -I | awk '{print $1}'):8000"
echo ""
echo "📖 Xem logs:"
echo "   docker compose logs -f"
echo ""
echo "🛑 Dừng service:"
echo "   cd $INSTALL_DIR/docker"
echo "   docker compose down"
echo ""
echo "📚 Chi tiết: $INSTALL_DIR/RASPBERRY_PI_GUIDE.md"
echo ""

# Kiểm tra nếu user chưa trong docker group
if ! groups $USER | grep -q '\bdocker\b'; then
    echo "⚠️  QUAN TRỌNG: Bạn cần logout và login lại!"
    echo "   User '$USER' đã được thêm vào docker group"
    echo "   Sau khi login lại, container sẽ tự động chạy"
fi
