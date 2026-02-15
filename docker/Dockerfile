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

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Install Python dependencies
COPY docker/requirements-docker.txt .
RUN pip install --no-cache-dir -r requirements-docker.txt

# Copy application files
COPY xiaozhi_final.py .
COPY config_manager.py .
COPY xiaozhi_endpoints.json .
COPY xiaozhi_endpoints_template.json .

# Copy static và templates nếu có
COPY static/ static/
COPY templates/ templates/

# Tạo thư mục cho data
RUN mkdir -p /app/data /app/logs

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
