FROM opensearchproject/opensearch:3.1.0

# Switch to root to make changes
USER root

# Create a custom user (check if group exists first)
RUN if ! getent group opensearch > /dev/null 2>&1; then \
      groupadd -g 1001 opensearch; \
    fi && \
    if ! getent passwd opensearch > /dev/null 2>&1; then \
      useradd -u 1001 -g opensearch -s /bin/bash -m opensearch; \
    fi

# Install additional packages if needed
RUN yum update -y && \
    yum install -y wget

# Create necessary directories and set permissions
RUN mkdir -p /usr/share/opensearch/data && \
    mkdir -p /usr/share/opensearch/logs && \
    chown -R opensearch:opensearch /usr/share/opensearch

# # Copy custom configuration files
# COPY ./config/opensearch.yml /usr/share/opensearch/config/
# COPY ./config/jvm.options /usr/share/opensearch/config/

# # Set proper ownership
# RUN chown opensearch:opensearch /usr/share/opensearch/config/opensearch.yml
# RUN chown opensearch:opensearch /usr/share/opensearch/config/jvm.options

# Switch to non-root user
USER opensearch

# Expose ports
EXPOSE 9200 9600

# Set environment variables
ENV OPENSEARCH_JAVA_OPTS="-Xms512m -Xmx512m"

# Default command
CMD ["/usr/share/opensearch/bin/opensearch"]
