#!/bin/bash
set -e

# Wait for database availability
echo "Waiting for database..."
while ! nc -z $POSTGRES_HOST $POSTGRES_PORT; do
  sleep 0.1
done
echo "Database is ready!"

# Run Django migrations
echo "Running database migrations..."
label-studio migrate

# Create superuser if it doesn't exist
echo "Creating superuser if not exists..."
label-studio shell -c "
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@example.com', 'admin123')
    print('Superuser created: admin/admin123')
else:
    print('Superuser already exists')
"

# Start Label Studio
echo "Starting Label Studio..."
exec "$@"