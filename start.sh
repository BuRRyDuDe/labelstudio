#!/bin/bash

# Ensure data directories exist and have correct permissions
echo "Verifying data directory setup..."
if [ ! -d "/label-studio/data/media" ]; then
    sudo mkdir -p /label-studio/data/media
    sudo chown -R labelstudio:labelstudio /label-studio/data
    sudo chmod -R 755 /label-studio/data
fi
echo "Data directory setup verified"

# Wait for database to be ready (only if PostgreSQL is configured)
if [ -n "$PGHOST" ]; then
  echo "Waiting for PostgreSQL to be ready..."
  while ! pg_isready -h $PGHOST -p $PGPORT -U $PGUSER; do
    echo "PostgreSQL is unavailable - sleeping"
    sleep 2
  done
  echo "PostgreSQL is up - executing command"
else
  echo "Using SQLite database - no connection check needed"
fi

# Run database migrations
echo "Running database migrations..."
label-studio migrate

# Create cache table
echo "Creating cache table..."
label-studio createcachetable

# Collect static files
echo "Collecting static files..."
label-studio collectstatic --noinput

# Create superuser if it doesn't exist
echo "Creating superuser..."
label-studio shell -c "
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@example.com', 'admin123')
    print('Superuser created successfully')
else:
    print('Superuser already exists')
"

# Start Label Studio
echo "Starting Label Studio..."
# Use PORT environment variable provided by Railway, default to 8080 if not set
PORT=${PORT:-8080}
echo "Starting on port: $PORT"
exec label-studio start --host 0.0.0.0 --port $PORT --data-dir /label-studio/data