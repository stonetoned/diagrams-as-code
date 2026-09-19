FROM docker.io/alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b

ARG TARGETARCH
ARG D2_VERSION=0.9.0
ARG D2_SHA256_AMD64=5669ddc46b99e942cc96078f4a4e36d5e62103348f4c05179ede27802fdd87a9
ARG D2_SHA256_ARM64=ac2c028697199479acb321db1e3d68caee9f2ba492ed73caa3cd13f3829bf913
ARG PLANTUML_VERSION=1.2026.8
ARG PLANTUML_SHA256=5e1ecfa8ecd32c90b03bbf3b1eb6f020943f98ab0fcf4032be31a0002ee2c462

LABEL org.opencontainers.image.title="dgrac — Diagrams as Code" \
      org.opencontainers.image.description="One lean container for Python diagrams, PlantUML, Mermaid, Graphviz and D2" \
      org.opencontainers.image.source="https://github.com/stonetoned/diagrams-as-code" \
      org.opencontainers.image.licenses="CC0-1.0"

ENV LANG=C.UTF-8 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apk add --no-cache \
      ca-certificates \
      curl \
      font-droid \
      font-droid-nonlatin \
      graphviz \
      openjdk17-jre \
      py3-pip \
      python3 \
      rsvg-convert \
      tar \
  && pip3 install --break-system-packages --no-cache-dir --no-compile --no-deps \
       diagrams==0.25.1 \
       graphviz==0.20.3 \
       Jinja2==3.1.6 \
       MarkupSafe==3.0.3 \
  && case "$TARGETARCH" in \
       amd64) d2_sha="$D2_SHA256_AMD64" ;; \
       arm64) d2_sha="$D2_SHA256_ARM64" ;; \
       *) echo "unsupported architecture: $TARGETARCH" >&2; exit 1 ;; \
     esac \
  && curl -fsSL "https://github.com/d2lang/d2/releases/download/v${D2_VERSION}/d2-v${D2_VERSION}-linux-${TARGETARCH}.tar.gz" -o /tmp/d2.tar.gz \
  && echo "$d2_sha  /tmp/d2.tar.gz" | sha256sum -c - \
  && tar -xzf /tmp/d2.tar.gz -C /tmp \
  && install -m 0755 "/tmp/d2-v${D2_VERSION}/bin/d2" /usr/local/bin/d2 \
  && mkdir -p /jars \
  && curl -fsSL "https://github.com/plantuml/plantuml/releases/download/v${PLANTUML_VERSION}/plantuml.jar" -o /jars/plantuml.jar \
  && echo "$PLANTUML_SHA256  /jars/plantuml.jar" | sha256sum -c - \
  && rm -rf /tmp/d2.tar.gz "/tmp/d2-v${D2_VERSION}" /root/.cache

COPY scripts/ /scripts/

WORKDIR /work

ENTRYPOINT ["tail", "-f", "/dev/null"]
