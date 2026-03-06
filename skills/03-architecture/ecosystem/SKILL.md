---
name: ecosystem
description: SuperNovae Brain+Body architecture - how spn (conductor), nika (body), and novanet (brain) work together as an integrated AI system. Use when user asks about architecture, data flow, MCP integration, or how the tools connect.
argument-hint: "[topic]"
---

# SuperNovae Ecosystem Architecture

Understanding how the three tools work together as a unified AI system.

## The Brain + Body Model

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  BRAIN + BODY ARCHITECTURE                                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│                           ┌─────────────────┐                               │
│                           │       SPN       │                               │
│                           │   (Conductor)   │                               │
│                           │                 │                               │
│                           │ • Secrets       │                               │
│                           │ • Config        │                               │
│                           │ • Sync          │                               │
│                           └────────┬────────┘                               │
│                                    │                                        │
│              ┌─────────────────────┼─────────────────────┐                  │
│              │                     │                     │                  │
│              ▼                     ▼                     ▼                  │
│  ┌───────────────────┐  ┌───────────────────┐  ┌───────────────────┐       │
│  │      NOVANET      │  │       NIKA        │  │    AI EDITORS     │       │
│  │      (Brain)      │  │      (Body)       │  │                   │       │
│  │                   │  │                   │  │ • Claude Code     │       │
│  │ • Knowledge       │  │ • Workflows       │  │ • Cursor          │       │
│  │ • Memory          │  │ • Execution       │  │ • Windsurf        │       │
│  │ • Context         │  │ • Orchestration   │  │                   │       │
│  └─────────┬─────────┘  └─────────┬─────────┘  └───────────────────┘       │
│            │                      │                                         │
│            │    MCP Protocol      │                                         │
│            └──────────────────────┘                                         │
│                                                                             │
│  ANALOGY:                                                                   │
│  ┌─────────────────────────────────────────────────────────────────┐       │
│  │  NovaNet = Brain   │ Stores knowledge, provides context         │       │
│  │  Nika = Body       │ Executes actions, orchestrates workflows   │       │
│  │  SPN = Conductor   │ Manages secrets, syncs configuration       │       │
│  └─────────────────────────────────────────────────────────────────┘       │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Data Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  CONTENT GENERATION FLOW                                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  1. DEFINE (Human)                                                          │
│     └─► Entity, Page, Block structure in NovaNet                            │
│                                                                             │
│  2. ENRICH (Nika + External)                                                │
│     └─► SEO keywords, Terms, Expressions imported via novanet_write         │
│                                                                             │
│  3. ASSEMBLE (NovaNet)                                                      │
│     └─► novanet_generate assembles context with token budget                │
│                                                                             │
│  4. GENERATE (Nika + LLM)                                                   │
│     └─► infer: verb creates content using assembled context                 │
│                                                                             │
│  5. STORE (NovaNet)                                                         │
│     └─► novanet_write saves BlockNative, PageNative                         │
│                                                                             │
│  6. LOOP                                                                    │
│     └─► Content informs next iteration (virtuous cycle)                     │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## MCP Protocol Integration

```yaml
# Nika workflow using NovaNet via MCP
workflow: generate-landing-page

mcp:
  servers:
    novanet:
      command: "novanet-mcp"

tasks:
  # 1. Load context from brain
  - id: load_context
    invoke: novanet_generate
    params:
      focus_key: "landing-page"
      locale: "fr-FR"
      mode: "page"
      token_budget: 50000
    use.ctx: context

  # 2. Generate content with body
  - id: generate_content
    infer: |
      Using the following context, generate the landing page content:

      $context
    use.ctx: content

  # 3. Store back in brain
  - id: save_content
    invoke: novanet_write
    params:
      operation: "upsert_node"
      class: "PageNative"
      key: "landing-page@fr-FR"
      properties:
        content: "$content"
        locale: "fr-FR"
```

## Component Responsibilities

### NovaNet (Brain)
| Responsibility | Implementation |
|----------------|----------------|
| **Knowledge storage** | Neo4j graph with 61 NodeClasses |
| **Context assembly** | `novanet_generate` with RLM-on-KG |
| **Schema enforcement** | Write validation via traits |
| **Locale knowledge** | Terms, Expressions, Patterns per locale |
| **SEO intelligence** | Keywords, rankings, search data |

### Nika (Body)
| Responsibility | Implementation |
|----------------|----------------|
| **Workflow execution** | DAG-based task scheduling |
| **LLM orchestration** | 7 providers, model selection |
| **Tool calling** | MCP integration for external tools |
| **Agent loops** | Multi-turn reasoning with `agent:` verb |
| **Output generation** | Content creation via `infer:` |

### SPN (Conductor)
| Responsibility | Implementation |
|----------------|----------------|
| **Secret management** | OS Keychain integration |
| **Config distribution** | 3-level config (global/team/local) |
| **Editor sync** | Auto-sync to Claude Code, Cursor |
| **Package management** | Workflow/skill registry |
| **Tool orchestration** | Unified CLI for all tools |

## Key Design Principles

### 1. Separation of Concerns
```
WHAT to generate  → NovaNet (schema, structure)
HOW to generate   → Nika (workflows, LLM calls)
WHERE credentials → SPN (secrets, config)
```

### 2. Generation, Not Translation
```
Source → Translate → Target        ❌ Traditional
Entity → Generate → EntityNative   ✅ SuperNovae
```

### 3. Schema vs Data
```
SCHEMA (Human-defined)     DATA (AI-generated)
├── NodeClass definitions  ├── Node instances
├── ArcClass definitions   ├── Arc instances
└── Property schemas       └── Property values
```

### 4. Token-Aware Context
```
Request: "Generate fr-FR landing page"
         ↓
NovaNet: Assemble 50K tokens of relevant context
         ├── Entity definitions
         ├── Locale voice/culture
         ├── SEO keywords
         └── Cross-references
         ↓
Nika:    Send to LLM with assembled context
```

## Virtuous Cycle

```
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│    ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐ │
│    │  WRITE   │───►│  STORE   │───►│   READ   │───►│ GENERATE │ │
│    │(novanet_ │    │ (Neo4j)  │    │(novanet_ │    │ (Nika    │ │
│    │  write)  │    │          │    │ generate)│    │  infer)  │ │
│    └──────────┘    └──────────┘    └──────────┘    └────┬─────┘ │
│          ▲                                              │       │
│          │                                              │       │
│          └──────────────────────────────────────────────┘       │
│                                                                  │
│    Each iteration:                                               │
│    • Graph grows with real data                                  │
│    • Context becomes richer                                      │
│    • Generation quality improves                                 │
│    • SEO optimization refines                                    │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

## See Also

- `/supernovae:novanet` - Brain details
- `/supernovae:nika` - Body details
- `/supernovae:spn` - Conductor details
- `/supernovae:mcp-integration` - Protocol deep-dive
