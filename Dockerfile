FROM matomo:5-fpm-alpine

# Run as www-data (UID 82) instead of root
USER 82

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Use the existing entrypoint from the base image
CMD ["php-fpm"]
