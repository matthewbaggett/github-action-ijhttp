# trivy
FROM alpine:3.18

LABEL maintainer="Matthew Baggett <matthew@baggett.me>" \
      org.label-schema.vcs-url="https://github.com/matthewbaggett/github-action-ijhttp" \
      org.opencontainers.image.source="https://github.com/matthewbaggett/github-action-ijhttp"

# Install dependencies
# hadolint ignore=DL3018
RUN apk add --no-cache \
    bash \
    wget

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy JDK from Eclipse Temurin 21 (Alpine)
ENV JAVA_HOME=/opt/java/openjdk
COPY --from=eclipse-temurin:21-alpine $JAVA_HOME $JAVA_HOME
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Install IntelliJ IDEA
RUN wget -q -O "ijhttp.zip" "https://jb.gg/ijhttp/latest" && \
    unzip -q "ijhttp.zip" -d "/opt" && \
    rm "ijhttp.zip"

WORKDIR /action/workspace
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/opt/ijhttp/ijhttp"]

# Add a non-root user
RUN adduser -D ijhttp
USER ijhttp

# Check that ijhttp (and java) are happy.
RUN /opt/ijhttp/ijhttp --version

# Disable healthcheck
HEALTHCHECK NONE
