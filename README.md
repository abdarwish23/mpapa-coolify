# mPAPA — Coolify Deployment

**mPAPA** (my Personal Artificial Patent Attorney) — AI patent drafting with prior art search across 5 databases.

> "Your invention. Your machine. Your patent. Zero data leaks."

## Features

- 🔍 **Prior Art Search** — EPO, Google Patents, Google Scholar, ArXiv, PubMed
- 💬 **AI Chat** — RAG-powered Q&A over your research
- ⚡ **9-Step Workflow** — Disclosure → Claims → Prior Art → Novelty → Review → Market → Legal → Summary → Full Draft
- 📄 **Export** — DOCX & LaTeX
- 🎭 **Personality Modes** — Critical, Neutral, Innovation-Friendly

## Quick Deploy on Coolify

### 1. Deploy

1. **New Project → Docker Compose**
2. URL: `https://github.com/abdarwish23/mpapa-coolify`
3. Set **Port** to `8080`
4. Set environment variable `OPENROUTER_API_KEY`
5. **Deploy!**

### 2. Access

```
http://your-coolify-domain:8080/
```

## LLM Models (via OpenRouter)

Default: **Gemini 2.5 Flash** — great balance of quality and cost.

| Model | Input/1M | Output/1M | Quality | Best For |
|---|---|---|---|---|
| `google/gemini-2.5-flash-lite` | $0.10 | $0.40 | ⭐⭐ | Budget drafts |
| `meta-llama/llama-4-scout` | $0.10 | $0.30 | ⭐⭐ | Cheapest option |
| `deepseek/deepseek-chat-v3` | $0.20 | $0.77 | ⭐⭐⭐ | Best value |
| `google/gemini-2.5-flash` | $0.30 | $2.50 | ⭐⭐⭐⭐ | **Recommended** |
| `openai/gpt-4.1-mini` | $0.40 | $1.60 | ⭐⭐⭐⭐ | Best OpenAI value |
| `anthropic/claude-sonnet-4` | $3.00 | $15.00 | ⭐⭐⭐⭐⭐ | Best quality |

Change models in Coolify env vars:
```
PATENT_MODEL_DISCLOSURE=deepseek/deepseek-chat-v3
PATENT_MODEL_CLAIMS=deepseek/deepseek-chat-v3
...
```

## Environment Variables

| Variable | Required | Default | Description |
|---|---|---|---|
| `OPENROUTER_API_KEY` | ✅ | — | Your OpenRouter API key |
| `PATENT_MODEL_*` | ❌ | `google/gemini-2.5-flash` | Model per agent task |
| `MPAPA_PORT` | ❌ | `8080` | Web UI port |
| `PATENT_EPO_OPS_KEY` | ❌ | — | EPO API key (optional) |

## Architecture

```
┌──────────────┐     ┌──────────────┐
│   mPAPA      │────▶│  OpenRouter   │──▶ LLM
│  (NiceGUI)   │     │  (API)        │
│   Port 8080  │     └──────────────┘
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   SQLite     │  ← All data persisted
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
- [OpenRouter](https://openrouter.ai/)
- [EPO/OPS Registration](https://developers.epo.org/)
