#!/bin/bash

set -x

# ==========================================================
# 2026 OLLAMA MODELS FOR 16GB VRAM
# ==========================================================

export OLLAMA_HOST="${OLLAMA_HOST:-127.0.0.1:11434}"

# --- GENERAL ---

# Use Case: Your primary daily driver for chat and general queries.
# Strength: Meta's most capable 8B; high tokens-per-second. (llama4 has no 8b/17b—only 16x17b/67GB+)
ollama pull llama3.1:8b

# Use Case: Quick, low-resource tasks or when you need to keep many other apps open.
# Strength: Extremely fast; uses less than 9GB of VRAM even at high precision.
ollama pull llama3.2:3b

# Use Case: Meta's latest multimodal MoE; best quality when you have the VRAM.
# Strength: Native vision + text; 10M context. Needs ~67GB (16x17b active). Omit if you only have 16GB.
#ollama pull llama4:scout

# Use Case: Highly polished prose, summaries, and creative writing.
# Strength: Google's optimization for NVIDIA cards makes this feel very snappy.
ollama pull gemma3:12b


# --- DEV ---

# Use Case: Main coding model for snippets, refactoring, and logic.
# Strength: Strong code generation; 32K context. (qwen3-coder has 30b/480b only; 14b is qwen2.5-coder)
ollama pull qwen2.5-coder:14b

# Use Case: Complex debugging or "Thinking" through architectural problems.
# Strength: Native reasoning chain; explains its logic before outputting code. (v3.2 is cloud-only; use local deepseek-r1)
ollama pull deepseek-r1:14b


# --- ADVANCED REASONING ---

# Use Case: Agentic tasks or deep logical analysis (math/science).
# Strength: Advanced Mixture-of-Experts (MoE) that mimics much larger cloud models.
ollama pull gpt-oss:20b
