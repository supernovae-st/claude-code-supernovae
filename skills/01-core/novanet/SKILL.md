---
name: novanet
description: NovaNet knowledge graph reference - 14 MCP tools for context assembly, content generation, and SEO operations. Use when user asks about novanet_generate, novanet_write, MCP tools, schema, or knowledge graph queries.
argument-hint: "[topic]"
---

# NovaNet Knowledge Graph

The brain of the SuperNovae ecosystem. A Neo4j-powered knowledge graph that provides rich context for AI content generation.

## Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  NOVANET ARCHITECTURE                                                       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  AI Agent (Claude Code, Nika)                                               │
│         │                                                                   │
│         │ MCP Protocol (stdio)                                              │
│         ▼                                                                   │
│  ┌─────────────────────────────────────────────────────────────────┐       │
│  │                    NOVANET MCP SERVER                            │       │
│  │                      (14 tools)                                  │       │
│  ├─────────────────────────────────────────────────────────────────┤       │
│  │  READ TOOLS                    │  WRITE TOOLS                    │       │
│  │  ├── novanet_query            │  ├── novanet_write              │       │
│  │  ├── novanet_describe         │  ├── novanet_check              │       │
│  │  ├── novanet_search           │  └── novanet_audit              │       │
│  │  ├── novanet_traverse         │                                 │       │
│  │  ├── novanet_assemble         │  CACHE TOOLS                    │       │
│  │  ├── novanet_atoms            │  ├── novanet_cache_stats        │       │
│  │  ├── novanet_generate         │  └── novanet_cache_invalidate   │       │
│  │  ├── novanet_introspect       │                                 │       │
│  │  └── novanet_batch            │                                 │       │
│  └─────────────────────────────────────────────────────────────────┘       │
│         │                                                                   │
│         │ Cypher                                                            │
│         ▼                                                                   │
│  ┌─────────────────────────────────────────────────────────────────┐       │
│  │                         NEO4J                                    │       │
│  │  61 NodeClasses │ 182 ArcClasses │ 2 Realms │ 10 Layers          │       │
│  └─────────────────────────────────────────────────────────────────┘       │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## 14 MCP Tools

### Read Tools

| Tool | Purpose | Key Params |
|------|---------|------------|
| `novanet_query` | Execute Cypher | `cypher`, `params`, `limit` |
| `novanet_describe` | Schema bootstrap | `describe`: schema/entity/locales/stats |
| `novanet_search` | Fulltext search | `query`, `mode`, `kinds` |
| `novanet_traverse` | Graph traversal | `start_key`, `max_depth`, `direction` |
| `novanet_assemble` | Context assembly | `focus_key`, `locale`, `token_budget` |
| `novanet_atoms` | Knowledge atoms | `locale`, `atom_type` |
| `novanet_generate` | RLM-on-KG context | `focus_key`, `locale`, `mode` |
| `novanet_introspect` | Schema introspection | `target`: classes/arcs |
| `novanet_batch` | Bulk operations | `operations[]`, `parallel` |

### Write Tools

| Tool | Purpose | Key Params |
|------|---------|------------|
| `novanet_write` | Data mutations | `operation`, `class`, `key`, `properties` |
| `novanet_check` | Pre-write validation | `operation`, `class`, `properties` |
| `novanet_audit` | Quality audit | `target`: coverage/orphans/integrity |

### Cache Tools

| Tool | Purpose |
|------|---------|
| `novanet_cache_stats` | Cache hit rate, entry count |
| `novanet_cache_invalidate` | Clear cache by pattern |

## Core Tool: `novanet_generate`

The primary tool for content generation context:

```yaml
# In Nika workflow
- id: load_context
  invoke: novanet_generate
  params:
    focus_key: "homepage"
    locale: "fr-FR"
    mode: "page"              # page or block
    token_budget: 50000
    spreading_depth: 2
  use.ctx: generation_context
```

**Returns:**
- `prompt` - Assembled context for LLM
- `evidence_summary` - Sources used
- `locale_context` - Voice, formality, culture
- `context_anchors` - Cross-page links
- `denomination_forms` - Entity name forms (text/title/abbrev/url)

## Schema Overview

### 2 Realms
| Realm | Purpose | Writable? |
|-------|---------|-----------|
| **shared** | Universal definitions, locale knowledge | READ-ONLY |
| **org** | Organization-specific content | YES |

### 10 Layers
| Layer | Realm | Examples |
|-------|-------|----------|
| config | shared | BCP47, OrgConfig |
| locale | shared | Locale, LocaleVoice |
| geography | shared | Country, Region |
| knowledge | shared | Term, Expression, Pattern |
| config | org | OrgConfig |
| foundation | org | Project, Brand |
| structure | org | Page, Block |
| semantic | org | Entity, EntityNative |
| instruction | org | PageStructure, PageInstruction |
| output | org | PageNative, BlockNative |

### 5 Traits (Data Origin)
| Trait | Who Creates | Examples |
|-------|-------------|----------|
| `defined` | Human, once | Page, Block, Entity |
| `authored` | Human, per locale | EntityNative, ProjectNative |
| `imported` | External data | SEOKeyword, Term |
| `generated` | LLM | PageNative, BlockNative |
| `retrieved` | External APIs | GEOAnswer |

## RLM-on-KG Pattern

**R**ecursive **L**anguage **M**odel on **K**nowledge **G**raph:

```
1. START at focus node (Page, Block)
2. TRAVERSE graph following relevant arcs
3. ASSEMBLE evidence packets (token-aware)
4. INCLUDE locale knowledge (terms, expressions)
5. FORMAT context with denomination_forms
6. RETURN optimized prompt for LLM
```

## Write Philosophy

```
SCHEMA (Thibaut)              DATA (Nika)
────────────────              ──────────
YAML files                    novanet_write MCP
NodeClass definitions         Node instances
ArcClass definitions          Arc instances
Human review required         Automated via workflows
```

**Rule**: Nika creates DATA within SCHEMA that Thibaut defined.

## Common Patterns

### Query Entities
```cypher
MATCH (e:Entity)-[:HAS_NATIVE]->(en:EntityNative)
WHERE en.locale = "fr-FR"
RETURN e.key, en.name
```

### Check Locale Coverage
```cypher
MATCH (e:Entity)
WHERE NOT EXISTS {
  MATCH (e)-[:HAS_NATIVE]->(en:EntityNative {locale: "fr-FR"})
}
RETURN e.key AS missing_french
```

### Get Entity Context
```yaml
- invoke: novanet_assemble
  params:
    focus_key: "qr-code"
    locale: "fr-FR"
    token_budget: 10000
    strategy: "relevance"
```

## See Also

- `/supernovae:novanet/tools/*` - Tool-by-tool documentation
- `/supernovae:novanet/schema/*` - Schema deep-dive
- `/supernovae:novanet/patterns/*` - RLM-on-KG patterns
- `/supernovae:novanet/philosophy/*` - Write philosophy
