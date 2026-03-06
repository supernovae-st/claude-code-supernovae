# SuperNovae Ecosystem Plugin

This plugin provides comprehensive Claude Code integration for the SuperNovae AI ecosystem.

## Ecosystem Overview

SuperNovae consists of three complementary tools that work together:

| Tool | Role | Key Capability |
|------|------|----------------|
| **spn** | Conductor | Package manager, secrets, config sync |
| **nika** | Body | YAML workflow execution, LLM orchestration |
| **novanet** | Brain | Knowledge graph, context assembly, MCP tools |

## Quick Reference

### spn Commands (50+)
```bash
spn setup                    # Interactive wizard
spn provider set anthropic   # Store API key in OS Keychain
spn mcp add neo4j            # Add MCP server
spn sync                     # Sync to .claude/, .cursor/
spn nk run <file>            # Run Nika workflow
spn nv query "<cypher>"      # Query NovaNet
```

### Nika Verbs (5)
```yaml
infer: "Generate text"           # LLM generation
exec: "npm test"                 # Shell command
fetch: "https://api.example.com" # HTTP request
invoke: novanet_generate         # MCP tool
agent: "Research this topic"     # Multi-turn agent
```

### NovaNet MCP Tools (14)
| Tool | Purpose |
|------|---------|
| `novanet_query` | Execute Cypher |
| `novanet_describe` | Schema bootstrap |
| `novanet_search` | Fulltext search |
| `novanet_traverse` | Graph traversal |
| `novanet_assemble` | Context assembly |
| `novanet_atoms` | Knowledge atoms |
| `novanet_generate` | RLM-on-KG context |
| `novanet_introspect` | Schema introspection |
| `novanet_batch` | Bulk operations |
| `novanet_cache_stats` | Cache info |
| `novanet_cache_invalidate` | Cache control |
| `novanet_write` | Data mutations |
| `novanet_check` | Pre-write validation |
| `novanet_audit` | Quality audit |

## Plugin Skills (4 Tiers)

### Tier 0: Onboarding
- `quickstart` - 5-minute first workflow
- `installation` - Homebrew, cargo, docker
- `first-workflow` - Step-by-step guide

### Tier 1: Core References
- `spn/*` - All spn commands and features
- `nika/*` - DSL, verbs, bindings, DAG
- `novanet/*` - MCP tools, schema, patterns

### Tier 2: Workflows
- `content-generation` - Blog, landing pages
- `seo-pipeline` - Keyword research, entity bootstrap
- `agent-building` - Multi-turn agents
- `data-import` - External data to NovaNet
- `localization` - Multi-locale workflows

### Tier 3: Architecture
- `ecosystem` - Brain+Body architecture
- `internals` - Runtime, cache, daemon
- `extension` - Custom verbs, MCP servers

## Agents

Use `/supernovae:<agent>` to invoke:
- `workflow-builder` - Create workflows from descriptions
- `cypher-expert` - Write Cypher queries
- `seo-analyst` - SEO recommendations
- `content-generator` - Generate content
- `debugger` - Debug workflows
- `migrator` - Migrate from other tools

## Auto-Sync

This plugin auto-syncs from:
- `spn-cli` repository
- `nika` repository
- `novanet` repository

Updates are pulled weekly via GitHub Actions.
