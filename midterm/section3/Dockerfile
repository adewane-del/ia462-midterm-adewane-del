
# Stage 1: Install verified Python dependencies
FROM python:3.14-slim@sha256:9aaa474097d094040649f2162a627c0049b408f52138d980916788d80f04802f AS builder

ENV PIP_NO_CACHE_DIR=1
WORKDIR /build

COPY requirements.txt .

RUN python -m venv /opt/venv && \
    /opt/venv/bin/pip install --require-hashes -r requirements.txt


# Stage 2: Minimal runtime image
FROM python:3.14-slim@sha256:9aaa474097d094040649f2162a627c0049b408f52138d980916788d80f04802f AS runtime

ENV PATH="/opt/venv/bin:$PATH" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Create a non-root application user
RUN groupadd --gid 10001 appgroup && \
    useradd --uid 10001 --gid appgroup \
    --no-create-home --shell /usr/sbin/nologin appuser

COPY --from=builder /opt/venv /opt/venv
COPY --chown=10001:10001 app.py /app/app.py

USER 10001:10001

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "1", "--worker-tmp-dir", "/tmp", "app:app"]
