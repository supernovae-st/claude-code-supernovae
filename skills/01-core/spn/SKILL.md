---
name: spn
description: SuperNovae CLI reference - unified package manager for AI workflows. 50+87+ commands, 7 providers, 48 MCP aliases, OS Keychain security. Use when user asks about spn87+ commands, provider config, MCP aliases, or package management.
argument-hint: "[command]"
---

# SuperNovae CLI (spn)

The conductor of the SuperNovae ecosystem. Manages packages, providers, secrets, and syncs configuration across all your AI tools.

## Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  SPN ARCHITECTURE                                                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐       │
│  │  Claude Code    │     │     Cursor      │     │    Windsurf     │       │
│  └────────┬────────┘     └────────┬────────┘     └────────┬────────┘       │
│           │                       │                       │                │
│           └───────────────────────┼───────────────────────┘                │
│                                   │                                        │
│                           ┌───────▼───────┐                                │
│                           │  spn sync     │                                │
│                           └───────┬───────┘                                │
│                                   │                                        │
│  ┌────────────────────────────────┼────────────────────────────────────┐   │
│  │                         ~/.spn/                                     │   │
│  │  ├── config.toml       (user preferences)                          │   │
│  │  ├── mcp.yaml          (MCP server definitions)                    │   │
│  │  └── providers/        (encrypted via OS Keychain)                 │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                   │                                        │
│           ┌───────────────────────┼───────────────────────┐                │
│           │                       │                       │                │
│  ┌────────▼────────┐     ┌────────▼────────┐     ┌────────▼────────┐       │
│  │      Nika       │     │     NovaNet     │     │   MCP Servers   │       │
│  │  (reads config) │     │  (reads config) │     │   (48 aliases)  │       │
│  └─────────────────┘     └─────────────────┘     └─────────────────┘       │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Key Features

| Feature | Description |
|---------|-------------|
| **7 LLM Providers** | Claude, OpenAI, Mistral, Groq, DeepSeek, Gemini, Ollama |
| **48 MCP Aliases** | Pre-configured MCP servers (neo4j, github, slack, etc.) |
| **OS Keychain** | Secrets stored securely, never in files |
| **3-Level Config** | Global → Team → Local (like git) |
| **Auto-Sync** | Changes propagate to all editors automatically |
| **Direct Nika Integration** | Nika reads ~/.spn/mcp.yaml directly |

## Command Groups

### Provider Management
```bash
spn provider list [--show-source]     # List configured providers
spn provider set <name>               # Store API key in Keychain
spn provider get <name> [--unmask]    # Retrieve key
spn provider delete <name>            # Remove from Keychain
spn provider migrate [--yes]          # Move env vars → Keychain
spn provider test <name|all>          # Validate key
```

### Package Management
```bash
spn add @nika/workflow-name           # Add workflow package
spn remove @nika/workflow-name        # Remove package
spn install [--frozen]                # Install from spn.yaml
spn update [package]                  # Update to latest
spn list                              # Show installed
spn search <query>                    # Search registry
spn info @nika/package                # Package details
spn outdated                          # Show available updates
```

### MCP Server Management
```bash
spn mcp add <alias> [--global|--project]   # Add MCP server
spn mcp remove <alias>                      # Remove server
spn mcp list [--global|--project]           # List servers
spn mcp test <alias>                        # Test connection
```

### Configuration
```bash
spn config show [section]             # Show merged config
spn config where                      # Show file locations
spn config get <key>                  # Get specific value
spn config set <key> <value>          # Set value
spn config edit [--local|--user]      # Open in $EDITOR
```

### Model Management (Ollama)
```bash
spn model list [--running]            # List local models
spn model pull <name>                 # Download model
spn model load <name>                 # Load into memory
spn model unload <name>               # Unload from memory
spn model delete <name>               # Delete model
spn model status                      # Show VRAM usage
```

### Sync & Editors
```bash
spn sync [--dry-run]                  # Sync to all editors
spn sync --enable <editor>            # Enable auto-sync
spn sync --disable <editor>           # Disable auto-sync
spn sync --status                     # Show sync config
```

### Nika & NovaNet Integration
```bash
spn nk run <file>                     # Run Nika workflow
spn nk check <file>                   # Validate workflow
spn nk studio                         # Open Nika TUI

spn nv tui                            # Open NovaNet TUI
spn nv query "<cypher>"               # Query knowledge graph
spn nv mcp start|stop                 # Control MCP server
```

### System
```bash
spn setup [--quick]                   # Interactive wizard
spn doctor                            # System diagnostic
spn init                              # Initialize new project
```

## Configuration Files

### Global: `~/.spn/config.toml`
```toml
[providers.anthropic]
model = "claude-sonnet-4"

[sync]
enabled_editors = ["claude-code", "cursor"]
auto_sync = true
```

### Team: `./mcp.yaml` (committed to git)
```yaml
servers:
  neo4j:
    command: "npx"
    args: ["-y", "@neo4j/mcp-server-neo4j"]
    env:
      NEO4J_URI: "bolt://localhost:7687"
```

### Local: `./.spn/local.yaml` (gitignored)
```yaml
servers:
  neo4j:
    env:
      NEO4J_PASSWORD: "dev-password"
```

## Security

- **OS Keychain**: All secrets stored in native keychain (macOS Keychain, Windows Credential Manager, Linux Secret Service)
- **Zeroizing**: Secrets cleared from memory after use
- **No .env files**: Never write secrets to disk
- **Daemon mode**: Single keychain auth at startup, no popup fatigue

## See Also

- `/supernovae:spn/commands/*` - Detailed command reference
- `/supernovae:spn/providers/*` - Provider-specific guides
- `/supernovae:spn/mcp-aliases/*` - MCP server aliases
- `/supernovae:spn/security/*` - Security deep-dive
