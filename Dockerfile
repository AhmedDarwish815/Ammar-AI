FROM python:3.11-slim

# System dependencies for OpenCV & MediaPipe
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# ── Step 1: CPU-only PyTorch (saves ~3 GB vs full CUDA version) ───────────────
RUN pip install --no-cache-dir \
    torch torchvision \
    --index-url https://download.pytorch.org/whl/cpu

# ── Step 2: Rest of dependencies ──────────────────────────────────────────────
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ── Step 3: Copy app code ──────────────────────────────────────────────────────
COPY . .

# ── Step 4: Run ───────────────────────────────────────────────────────────────
CMD ["/bin/sh", "-c", "uvicorn app.api:app --host 0.0.0.0 --port ${PORT:-8000}"]
