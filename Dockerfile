FROM alpine:3.18
LABEL maintainer="Matthew Baggett <matthew@baggett.me>"

# Copy JDK from Eclipse Temurin
ENV JAVA_HOME=/opt/java/openjdk
COPY --from=eclipse-temurin:11 $JAVA_HOME $JAVA_HOME
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Install dependencies
RUN apk add --no-cache \
    bash \
    wget

# Install IntelliJ IDEA
RUN wget -q -O "ijhttp.zip" "https://jb.gg/ijhttp/latest" && \
    unzip -q "ijhttp.zip" -d "/opt" && \
    rm "ijhttp.zip"

WORKDIR /action/workspace
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
