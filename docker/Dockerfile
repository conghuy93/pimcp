# ============================================================
# miniZ MCP Docker - Phiên bản tối giản
# ============================================================
FROM python:3.11-slim

# Metadata
LABEL maintainer="miniZ Team"
LABEL version="4.3.0-minimal"
LABEL description="miniZ MCP API - Docker Minimal Edition"

# Environment
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV APP_HOME=/app

# Working directory
WORKDIR $APP_HOME

# Install system dependencies including build tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    gcc \
    g++ \
    python3-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Install Python dependencies
COPY docker/requirements-docker.txt .
RUN pip install --no-cache-dir -r requirements-docker.txt

# Copy application files (core only)
COPY xiaozhi_final.py .
COPY config_manager.py .

# Tạo thư mục cho data, logs và config
# xiaozhi_endpoints.json sẽ tự tạo runtime, static/templates embedded trong xiaozhi_final.py
RUN mkdir -p /app/data /app/logs /app/static /app/templates

# Non-root user cho security
RUN useradd --create-home --shell /bin/bash appuser \
    && chown -R appuser:appuser $APP_HOME
USER appuser

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/api/system_info || exit 1

# Start command
CMD ["uvicorn", "xiaozhi_final:app", "--host", "0.0.0.0", "--port", "8000"]
