FROM python:3.9-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    netcat-traditional \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /app

# Copy requirements file
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy configuration files
COPY label_studio_config.py .
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# Create directories for data with proper permissions
RUN mkdir -p /app/data /app/media

# Set environment variables
ENV LABEL_STUDIO_HOST=0.0.0.0
ENV LABEL_STUDIO_PORT=8080
ENV LABEL_STUDIO_DATA_DIR=/app/data
ENV LABEL_STUDIO_MEDIA_DIR=/app/media

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/health/ || exit 1

# Use entrypoint script
ENTRYPOINT ["./entrypoint.sh"]
CMD ["label-studio", "start", "--host", "0.0.0.0", "--port", "8080", "--data-dir", "/app/data"]