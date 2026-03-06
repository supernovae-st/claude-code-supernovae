---
name: quickstart
description: Get started with SuperNovae in 5 minutes - install spn, nika, novanet, configure providers, and run your first AI workflow. Use when user asks how to get started, install, or setup SuperNovae.
argument-hint: "[topic]"
---

# SuperNovae Quickstart

Get from zero to running AI workflows in 5 minutes.

## Prerequisites

- macOS, Linux, or WSL2
- Homebrew (recommended) or Cargo
- An LLM API key (Anthropic, OpenAI, or use Ollama for free local)

## Step 1: Install (1 minute)

```bash
# Add SuperNovae tap
brew tap supernovae-st/tap

# Install all three tools
brew install spn nika novanet
```

**Verify installation:**
```bash
spn --version    # Should show v0.12.x
nika --version   # Should show v0.21.x
novanet --version # Should show v0.17.x
```

## Step 2: Configure (2 minutes)

```bash
# Run interactive setup wizard
spn setup
```

The wizard will:
1. Ask for your preferred LLM provider (Claude recommended)
2. Store your API key securely in OS Keychain
3. Configure default settings
4. Sync to Claude Code automatically

**Or configure manually:**
```bash
# Set provider API key (stored in OS Keychain)
spn provider set anthropic
# Paste your API key when prompted

# Verify
spn provider list
```

## Step 3: Run Your First Workflow (2 minutes)

Create `hello.nika.yaml`:

```yaml
workflow: hello-supernovae

description: My first SuperNovae workflow

tasks:
  - id: greet
    infer: |
      Say hello in French, then briefly explain:
      1. What is Nika (the workflow engine)
      2. What is NovaNet (the knowledge graph)
      Keep it friendly and concise.
    use.ctx: greeting

  - id: show
    exec: echo "$greeting"
```

Run it:
```bash
nika run hello.nika.yaml
```

## What Just Happened?

1. **Nika** parsed your YAML workflow
2. The `infer:` verb called your LLM (Claude/OpenAI/etc.)
3. The response was stored in `$greeting` context
4. The `exec:` verb printed the result

## Next Steps

| Want to... | Use this |
|------------|----------|
| Learn Nika DSL | `/supernovae:nika` skill |
| Query knowledge graph | `/supernovae:novanet` skill |
| Build content pipelines | `/supernovae:content-generation` skill |
| Understand architecture | `/supernovae:ecosystem` skill |

## Common Issues

**"Provider not configured"**
```bash
spn provider set anthropic  # Or openai, ollama, etc.
```

**"Command not found: nika"**
```bash
brew reinstall nika
# Or add to PATH: export PATH="$HOME/.spn/bin:$PATH"
```

**Want to use free local LLMs?**
```bash
# Install Ollama
brew install ollama
ollama pull llama3.2

# Configure spn to use Ollama
spn provider set ollama
```

## Quick Reference

```bash
# Essential commands
spn setup                 # First-time setup
spn provider list         # Show configured providers
nika run <file>           # Run workflow
nika check <file>         # Validate workflow syntax
spn doctor                # Diagnose issues
```
