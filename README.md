# Label Studio on Railway

This repository contains a production-ready Label Studio deployment optimized for Railway with PostgreSQL database integration.

## Features

- 🚀 **Railway-optimized deployment** with automatic scaling
- 🗄️ **PostgreSQL database** for persistent data storage
- 📁 **Persistent file storage** for images and annotations
- ⚡ **Performance optimized** for fast loading
- 🔒 **Security hardened** for production use
- 🌍 **EU West (Amsterdam)** region deployment
- 💰 **Free-tier database** usage

## Quick Deploy to Railway

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/your-template-id)

## Manual Deployment Steps

### 1. Fork this Repository

1. Fork this repository to your GitHub account
2. Clone your fork locally

### 2. Set up Railway Project

1. Go to [Railway](https://railway.app)
2. Create a new project
3. Connect your GitHub repository
4. Set deployment region to **EU West (Amsterdam)**

### 3. Add PostgreSQL Database

1. In your Railway project, click "+ New"
2. Select "Database" → "PostgreSQL"
3. Railway will automatically create a free PostgreSQL instance
4. Note the connection details (automatically available as environment variables)

### 4. Configure Environment Variables

Railway will automatically set most database variables. You only need to add:

```bash
# Required
SECRET_KEY=your-very-secure-secret-key-here
LABEL_STUDIO_USERNAME=admin
LABEL_STUDIO_PASSWORD=your-secure-password

# Optional (defaults provided)
DEBUG=false
WEB_CONCURRENCY=2
DISABLE_SIGNUP_WITHOUT_LINK=true
```

### 5. Deploy

1. Push your code to GitHub
2. Railway will automatically build and deploy
3. Your Label Studio instance will be available at the provided Railway URL

## Local Development

### Prerequisites

- Docker and Docker Compose
- Git

### Setup

1. Clone the repository:
```bash
git clone https://github.com/BuRRyDuDe/labelstudio.git
cd labelstudio
```

2. Copy environment file:
```bash
cp .env.example .env
```

3. Start the services:
```bash
docker-compose up -d
```

4. Access Label Studio at `http://localhost:8080`

Default credentials:
- Username: `admin`
- Password: `admin123`

## Configuration

### Database

The application uses PostgreSQL with the following optimizations:
- Connection pooling with `CONN_MAX_AGE=600`
- SSL required for security
- Health checks enabled

### Performance

- **Gunicorn** with gevent workers for async processing
- **Database caching** for improved response times
- **Static file optimization** with proper headers
- **Connection pooling** to reduce database overhead

### Security

- Non-root Docker user
- SSL/TLS enforcement in production
- Secure cookie settings
- XSS and CSRF protection
- Rate limiting on API endpoints

## File Storage

All uploaded files and annotations are stored in persistent volumes:
- `/label-studio/data` - Project data and configurations
- `/label-studio/media` - Uploaded images and files
- `/label-studio/static` - Static assets

## Monitoring

### Health Checks

The application includes built-in health checks:
- Docker health check every 30 seconds
- Database connection monitoring
- Application readiness checks

### Logs

View application logs in Railway dashboard or via CLI:
```bash
railway logs
```

## Scaling

Railway automatically handles scaling based on your subscription:
- **Hobby Plan**: Up to 512MB RAM, 1 vCPU
- **Pro Plan**: Up to 8GB RAM, 8 vCPU

The application is configured to work efficiently within these limits.

## Troubleshooting

### Common Issues

1. **Database Connection Failed**
   - Ensure PostgreSQL service is running
   - Check environment variables are set correctly
   - Verify network connectivity

2. **File Upload Issues**
   - Check available disk space
   - Verify file permissions
   - Review file size limits in settings

3. **Performance Issues**
   - Monitor memory usage in Railway dashboard
   - Consider upgrading Railway plan
   - Review database query performance

### Getting Help

- Check Railway logs for error messages
- Review Label Studio documentation
- Open an issue in this repository

## Cost Optimization

- **PostgreSQL**: Free tier (500MB storage)
- **Application**: Runs on your $20 Railway subscription
- **Total monthly cost**: $20 (Railway subscription only)

## Backup and Recovery

Regular backups are recommended:
1. Database: Use Railway's backup features
2. Files: Consider external storage integration
3. Configurations: Keep in version control

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## Support

For issues related to:
- **Railway deployment**: Check Railway documentation
- **Label Studio**: Check official Label Studio docs
- **This setup**: Open an issue in this repository