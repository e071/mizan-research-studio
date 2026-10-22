# Source is supplied as a complete, public, editable ZIP because the connected
# GitHub integration is read-only. No credentials or generated models are bundled.
FROM node:22-bookworm-slim AS frontend
WORKDIR /build
RUN apt-get update && apt-get install -y --no-install-recommends unzip && rm -rf /var/lib/apt/lists/*
COPY source-bundle.zip ./
RUN unzip -q source-bundle.zip && rm source-bundle.zip
RUN npm install -g pnpm@11.25.0 && pnpm install --frozen-lockfile --ignore-scripts
RUN pnpm typecheck && pnpm test && pnpm build

FROM python:3.12-slim-bookworm
ENV PYTHONUNBUFFERED=1 PYTHONDONTWRITEBYTECODE=1 OMP_NUM_THREADS=1 OPENBLAS_NUM_THREADS=1 MALLOC_ARENA_MAX=2 PORT=10000
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends libgomp1 fonts-noto-core tesseract-ocr tesseract-ocr-eng tesseract-ocr-tur tesseract-ocr-deu tesseract-ocr-fra tesseract-ocr-spa ca-certificates && rm -rf /var/lib/apt/lists/* && mkdir -p /app/fonts && cp /usr/share/fonts/truetype/noto/NotoSans-Regular.ttf /app/fonts/
COPY --from=frontend /usr/local/bin/node /usr/local/bin/node
COPY --from=frontend /build/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY --from=frontend /build/engine ./engine
RUN python engine/download_models.py
COPY --from=frontend /build/dist ./dist
COPY --from=frontend /build/dist-server ./dist-server
COPY --from=frontend /build/public/fonts/OFL.txt ./fonts/OFL.txt
COPY --from=frontend /build/LICENSE /build/README.md ./
RUN useradd --create-home --uid 10001 mizan && mkdir /tmp/mizan && chown mizan:mizan /tmp/mizan
USER mizan
EXPOSE 10000
CMD ["node","--max-old-space-size=128","dist-server/server.js"]
