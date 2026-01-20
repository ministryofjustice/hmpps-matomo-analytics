FROM matomo:5-fpm-alpine

# Install nginx and supervisor
RUN apk add --no-cache nginx supervisor

# Remove user directive from main nginx config since we run as non-root
RUN sed -i '/^user /d' /etc/nginx/nginx.conf

# Copy Matomo files from source to web root.
# This replicates what the base image entrypoint does.
RUN tar cf - --one-file-system -C /usr/src/matomo . | tar xf - -C /var/www/html

# Make matomo.js writable so plugins can extend the JavaScript tracker
RUN chmod +w /var/www/html/matomo.js && \
    chown www-data:www-data /var/www/html/matomo.js

RUN chmod +w /var/www/html/js && \
    chown www-data:www-data /var/www/html/js

# Ensure nginx directories are writable by www-data
RUN mkdir -p /var/lib/nginx/tmp /run/nginx && \
    chown -R www-data:www-data /var/lib/nginx /var/log/nginx /run/nginx

# Copy nginx configuration and supervisord config
COPY nginx.conf /etc/nginx/http.d/default.conf
COPY supervisord.conf /etc/supervisord.conf

# Run as www-data (UID 82) instead of root
USER 82

# Expose port 8080 for nginx
EXPOSE 8080

# Override the base image entrypoint to avoid permission issues
# The base image entrypoint tries to chown files which fails when not running as root
ENTRYPOINT []

# Start supervisord to manage both services
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
