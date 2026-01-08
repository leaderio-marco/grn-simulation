# Reproducible container for running analyses in this repository
# Uses a slim Python base image and installs common scientific build deps.

FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

# System dependencies commonly needed for scientific Python stacks
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        git \
        curl \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy repository
COPY . /app

# Install Python dependencies if a requirements file exists
RUN python -m pip install --upgrade pip setuptools wheel \
    && if [ -f requirements.txt ]; then pip install -r requirements.txt; fi

# Default to an interactive Python session; override with `docker run ... <command>`
ENTRYPOINT ["python"]
