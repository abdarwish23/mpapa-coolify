# mPAPA — Coolify Deployment

**mPAPA** (my Personal Artificial Patent Attorney) is a fully local AI patent drafting system with prior art search across 5 databases.

> "Your invention. Your machine. Your patent. Zero data leaks."

## Features

- 🔍 **Prior Art Search** — Searches EPO, Google Patents, Google Scholar, ArXiv, PubMed simultaneously
- 💬 **AI Chat** — RAG-powered Q&A over your research
- ⚡ **9-Step Workflow** — Disclosure → Claims → Prior Art → Novelty → Review → Market → Legal → Summary → Full Draft
- 📄 **Export** — DOCX & LaTeX output
- 🎭 **Personality Modes** — Critical, Neutral, Innovation-Friendly per agent
- 🔒 **100% Local** — Your data never leaves your server

## Quick Deploy on Coolify

### 1. Deploy via Coolify

1. **Create new project** in Coolify
2. Choose **"Docker Compose"** as deployment type
3. Point to this repository
4. **Deploy!**

### 2. Pull an LLM Model

After deployment, connect to the Ollama container and pull a model:

```bash
# Connect to the Ollama container
docker exec -it mpapa-ollama ollama pull gemma2:2b

# Or for better quality (needs more RAM):
docker exec -it mpapa-ollama ollama pull llama3.1:8b
```

### 3. Access mPAPA

```
http://your-coolify-domain:8080/
```

## ⚠️ GPU Warning

Without a GPU, LLM inference will be **very slow**. Options:

| Option | Speed | Cost |
|---|---|---|
| **Bundled Ollama (no GPU)** | 🐌 Slow | Free |
| **External LM Studio (your PC)** | 🚀 Fast | Free |
| **External Ollama (GPU server)** | 🚀 Fast | Free |
| **Cloud API (OpenAI, etc.)** | 🚀 Fast | Paid |

To use an external LLM backend, set `PATENT_LM_STUDIO_BASE_URL` in Coolify:
- LM Studio: `http://your-pc-ip:1234/v1`
- Ollama: `http://your-server:11434/v1`
- OpenAI: `https://api.openai.com/v1` (set `PATENT_LM_STUDIO_API_KEY` too)

## Environment Variables

| Variable | Default | Description |
|---|---|---|
| `PATENT_LM_STUDIO_BASE_URL` | `http://ollama:11434/v1` | LLM API endpoint |
| `PATENT_LM_STUDIO_API_KEY` | `not-needed` | API key (for cloud providers) |
| `PATENT_MODEL_*` | `default` | Model names per agent task |
| `PATENT_EMBEDDING_MODEL_NAME` | `text-embedding-nomic-embed-text-v1.5` | Embedding model |
| `PATENT_EPO_OPS_KEY` | (empty) | EPO API key (optional) |
| `PATENT_EPO_OPS_SECRET` | (empty) | EPO API secret (optional) |
| `MPAPA_PORT` | `8080` | Web UI port |
| `PATENT_LOG_LEVEL` | `INFO` | Logging level |

## Architecture

```
┌──────────────┐     ┌──────────────┐
│   mPAPA      │────▶│   Ollama     │
│  (NiceGUI)   │     │  (LLM)       │
│   Port 8080  │     │  Port 11434  │
└──────┬───────┘     └──────────────┘
       │
       ▼
┌──────────────┐
│   SQLite     │  ← Persists all data
│   + PDFs     │
└──────────────┘
       │
       ▼
┌──────────────┐
│  5 Sources   │  ← EPO, Google Patents,
│  (External)  │     Google Scholar, ArXiv, PubMed
└──────────────┘
```

## Links

- [mPAPA GitHub](https://github.com/hapi-ds/mPAPA)
- [Ollama](https://ollama.ai/)
- [LM Studio](https://lmstudio.ai/)
- [EPO/OPS Registration](https://developers.epo.org/)
