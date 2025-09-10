FROM heartexlabs/label-studio:latest

# Install additional system dependencies
USER root
RUN apt-get update && apt-get install -y \
    postgresql-client \
    libpq-dev \
    gcc \
    python3-dev \
    curl \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV LABEL_STUDIO_HOST=0.0.0.0
ENV DJANGO_DB=default
ENV DJANGO_SETTINGS_MODULE=label_studio_config

# Set working directory
WORKDIR /label-studio

# Copy configuration files
COPY requirements.txt /label-studio/
COPY label_studio_config.py /label-studio/
COPY start.sh /label-studio/

# Install additional dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Make startup script executable
RUN chmod +x /label-studio/start.sh

# Create label-studio user
RUN useradd -m -s /bin/bash labelstudio

# Create directories for persistent storage with proper permissions
RUN mkdir -p /label-studio/data/media && \
    mkdir -p /label-studio/data/static && \
    mkdir -p /label-studio/data/export && \
    chown -R labelstudio:labelstudio /label-studio && \
    chmod -R 755 /label-studio/data && \
    echo "labelstudio ALL=(ALL) NOPASSWD: /bin/mkdir, /bin/chown, /bin/chmod" >> /etc/sudoers

# Switch to non-root user
USER labelstudio

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/health/ || exit 1

# Start Label Studio using the startup script
CMD ["/label-studio/start.sh"]