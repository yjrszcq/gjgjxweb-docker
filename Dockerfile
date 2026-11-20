# syntax=docker/dockerfile:1
ARG NGINX_IMAGE=nginx:1.28-alpine
ARG GJGJXWEB_COMMIT=45bb9337d92d41503f2ad11b288c50ab28d4a94c

FROM --platform=$BUILDPLATFORM ${NGINX_IMAGE} AS download
ARG GJGJXWEB_COMMIT
RUN apk add --no-cache curl
RUN set -eu; \
    printf '%s\n' "$GJGJXWEB_COMMIT" | grep -Eq '^[0-9a-f]{40}$'; \
    curl --fail --location --retry 3 --proto '=https' --proto-redir '=https' \
      "https://codeload.github.com/CzJam/gjgjxweb/tar.gz/${GJGJXWEB_COMMIT}" \
      --output /tmp/upstream.tar.gz; \
    mkdir /tmp/upstream /site; \
    tar -xzf /tmp/upstream.tar.gz --strip-components=1 -C /tmp/upstream; \
    cd /tmp/upstream; \
    test -s index.html; \
    cp -R index.html css js assets LICENSE LICENSE-Tango.txt LICENSE-xterm.txt /site/

FROM ${NGINX_IMAGE}
ARG GJGJXWEB_COMMIT
LABEL org.opencontainers.image.title="gjgjxweb" \
      org.opencontainers.image.description="An unofficial static Docker image for gjgjxweb" \
      org.opencontainers.image.url="https://github.com/CzJam/gjgjxweb/tree/${GJGJXWEB_COMMIT}" \
      org.opencontainers.image.licenses="GPL-3.0-only" \
      io.gjgjxweb.upstream.commit="${GJGJXWEB_COMMIT}"
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=download /site/ /srv/gjgjxweb/
USER nginx
EXPOSE 8080
ENTRYPOINT []
CMD ["nginx", "-g", "daemon off;"]
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget -q -O /dev/null http://127.0.0.1:8080/ || exit 1
