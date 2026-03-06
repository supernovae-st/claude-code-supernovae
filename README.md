# SuperNovae Ecosystem Plugin for Claude Code

The most comprehensive Claude Code plugin for AI-powered content generation, workflow automation, and knowledge graph operations.

## What is SuperNovae?

SuperNovae is an integrated AI ecosystem with three complementary tools:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  SUPERNOVAE ECOSYSTEM                                                       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────┐         MCP Protocol         ┌─────────────────────┐      │
│  │   NOVANET   │◄────────────────────────────►│        NIKA         │      │
│  │   (Brain)   │                              │       (Body)        │      │
│  ├─────────────┤                              ├─────────────────────┤      │
│  │ Knowledge   │    novanet_generate          │ YAML Workflows      │      │
│  │ Graph       │    novanet_query             │ 5 Semantic Verbs    │      │
│  │ 14 MCP Tools│    novanet_write             │ 7 LLM Providers     │      │
│  │ 200+ Locales│◄────────────────────────────►│ DAG Execution       │      │
│  └─────────────┘                              └─────────────────────┘      │
│         ▲                                              ▲                   │
│         │                                              │                   │
│         └──────────────────┬───────────────────────────┘                   │
│                            │                                               │
│                    ┌───────▼───────┐                                       │
│                    │      SPN      │                                       │
│                    │  (Conductor)  │                                       │
│                    ├───────────────┤                                       │
│                    │ Package Mgr   │                                       │
│                    │ 7 Providers   │                                       │
│                    │ 48 MCP Aliases│                                       │
│                    │ OS Keychain   │                                       │
│                    └───────────────┘                                       │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Installation

### Prerequisites

```bash
# Install via Homebrew (recommended)
brew tap supernovae-st/tap
brew install spn nika novanet
```

### Install the Plugin

```bash
# From Claude Code marketplace
claude plugin add supernovae-st/claude-code-supernovae

# Or clone directly
git clone https://github.com/supernovae-st/claude-code-supernovae ~/.claude/plugins/supernovae
```

### Verify Installation

```bash
# In Claude Code, run:
/supernovae:status
```

## Quick Start (5 minutes)

### 1. Setup

```bash
spn setup    # Interactive wizard - configures providers and secrets
```

### 2. Run Your First Workflow

```yaml
# hello.nika.yaml
workflow: hello-supernovae
tasks:
  - id: greet
    infer: "Say hello in French, then explain what NovaNet is"
    use.ctx: greeting
```

```bash
nika run hello.nika.yaml
```

### 3. Query the Knowledge Graph

```bash
# Using the novanet MCP tool
/novanet:query "MATCH (e:Entity) RETURN e.key LIMIT 5"
```

## Plugin Structure

This plugin uses **progressive disclosure** - content loads on-demand based on relevance:

| Tier | Focus | When to Use |
|------|-------|-------------|
| **00-onboarding** | Getting started | First time users |
| **01-core** | Tool references | Daily usage, lookup |
| **02-workflows** | Use-case patterns | Building solutions |
| **03-architecture** | Deep understanding | Extending, debugging |

## Available Commands

| Command | Description |
|---------|-------------|
| `/supernovae:status` | Check ecosystem health |
| `/supernovae:setup` | Interactive setup wizard |
| `/nika:run <file>` | Run a Nika workflow |
| `/nika:new` | Create new workflow interactively |
| `/novanet:query` | Execute Cypher query |
| `/novanet:generate` | Assemble content context |
| `/spn:sync` | Sync config to editors |
| `/supernovae:doctor` | Diagnose issues |

## Available Agents

| Agent | Purpose |
|-------|---------|
| `workflow-builder` | Create Nika workflows from description |
| `cypher-expert` | Write NovaNet Cypher queries |
| `seo-analyst` | SEO analysis and recommendations |
| `content-generator` | Generate content via novanet_generate |
| `debugger` | Debug Nika workflows |
| `migrator` | Migrate from other tools |

## Documentation

- **Skills**: `/supernovae:*` - 56 skills across 4 tiers
- **Agents**: 6 specialized subagents
- **Assets**: 30+ reusable workflows, queries, schemas
- **Rules**: Always-loaded best practices

## Tool Versions

| Tool | Version | Key Features |
|------|---------|--------------|
| **spn** | v0.12.2 | 7 providers, 48 MCP aliases, OS Keychain |
| **nika** | v0.21.0 | 5 verbs, 7 providers, 3,808 tests |
| **novanet** | v0.17.0 | 14 MCP tools, 61 nodes, 182 arcs |

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines.

## License

MIT - See [LICENSE](./LICENSE)

---

**SuperNovae** | [GitHub](https://github.com/supernovae-st)
