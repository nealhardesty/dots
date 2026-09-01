#!/usr/bin/env bash
set -e

sudo mkdir -p /etc/systemd/system/ollama.service.d

sudo tee /etc/systemd/system/ollama.service.d/override.conf >/dev/null <<'EOF'
[Service]
Environment="OLLAMA_HOST=0.0.0.0:11434"
Environment="OLLAMA_CONTEXT_LENGTH=131072"
Environment="OLLAMA_MAX_LOADED_MODELS=1"
Environment="OLLAMA_NUM_PARALLEL=1"
EOF

sudo systemctl daemon-reload
sudo systemctl restart ollama

ollama pull qwen3.6:35b-a3b-q8_0
ollama pull qwen3.6:35b-coding
ollama pull gpt-oss:120b
ollama pull glm-4.7-flash:q8_0
