FROM debian:trixie-slim

# Install uv
RUN apt-get update && apt-get install -y curl && \
    curl -fsSL https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:${PATH}"

COPY . .
RUN uv sync

ENTRYPOINT ["./entrypoint.sh"]
