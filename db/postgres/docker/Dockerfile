FROM postgres:16.4-alpine

# Copy custom configuration
COPY postgresql.conf /etc/postgresql.conf

# Set the configuration file as the default
CMD ["postgres", "-c", "config_file=/etc/postgresql.conf"]

