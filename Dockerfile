FROM matomo:5-fpm-alpine

# Install nginx
RUN apk add --no-cache nginx

# Remove user directive from main nginx config since we run as non-root
RUN sed -i '/^user /d' /etc/nginx/nginx.conf

# Copy nginx configuration and startup script
COPY nginx.conf /etc/nginx/http.d/default.conf
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Ensure nginx directories are writable by www-data
RUN mkdir -p /var/lib/nginx/tmp /run/nginx && \
    chown -R www-data:www-data /var/lib/nginx /var/log/nginx /run/nginx

# Run as www-data (UID 82) instead of root
USER 82

# Expose port 8080 for nginx
EXPOSE 8080

# Override the base image entrypoint to avoid permission issues
# The base image entrypoint tries to chown files which fails when not running as root
ENTRYPOINT []

# Start both services
CMD ["/start.sh"]
