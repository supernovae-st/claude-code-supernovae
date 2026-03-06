---
name: nika
description: Nika workflow engine reference - YAML-first AI orchestration with 5 semantic verbs (infer, exec, fetch, invoke, agent), DAG execution, and MCP integration. Use when user asks about Nika workflows, verbs, bindings, or YAML syntax.
argument-hint: "[topic]"
---

# Nika Workflow Engine

The body of the SuperNovae ecosystem. Execute multi-step AI workflows defined in simple YAML.

## Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  NIKA ARCHITECTURE                                                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  workflow.nika.yaml                                                         │
│         │                                                                   │
│         ▼                                                                   │
│  ┌─────────────────┐                                                        │
│  │   YAML Parser   │───► AST with dependencies                              │
│  └────────┬────────┘                                                        │
│           │                                                                 │
│           ▼                                                                 │
│  ┌─────────────────┐     ┌─────────────────────────────────────────┐       │
│  │  DAG Executor   │────►│  Parallel execution where possible      │       │
│  └────────┬────────┘     └─────────────────────────────────────────┘       │
│           │                                                                 │
│           ▼                                                                 │
│  ┌─────────────────────────────────────────────────────────────────┐       │
│  │                        5 VERBS                                   │       │
│  ├─────────────────────────────────────────────────────────────────┤       │
│  │  infer:  │  exec:   │  fetch:  │  invoke:  │  agent:            │       │
│  │  LLM     │  Shell   │  HTTP    │  MCP      │  Multi-turn        │       │
│  └─────────────────────────────────────────────────────────────────┘       │
│           │                                                                 │
│           ▼                                                                 │
│  ┌─────────────────┐                                                        │
│  │ Context Store   │───► Variables available to subsequent tasks            │
│  └─────────────────┘                                                        │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## 5 Semantic Verbs

### `infer:` - LLM Generation
```yaml
- id: generate
  infer: "Write a blog post about $topic"
  model: claude-sonnet-4          # Optional: override default
  temperature: 0.7                # Optional: 0-1
  max_tokens: 4000                # Optional
  system: "You are a tech writer" # Optional: system prompt
  use.ctx: blog_post              # Store result
```

### `exec:` - Shell Commands
```yaml
- id: build
  exec: "npm run build"
  working_dir: ./frontend         # Optional
  env:                            # Optional
    NODE_ENV: production
  timeout: 300                    # Optional: seconds
  use.ctx: build_output
```

### `fetch:` - HTTP Requests
```yaml
- id: get_data
  fetch: "https://api.example.com/data"
  method: POST                    # Optional: GET, POST, PUT, DELETE
  headers:                        # Optional
    Authorization: "Bearer $token"
  body:                           # Optional (for POST/PUT)
    query: "$search_term"
  use.ctx: api_response
```

### `invoke:` - MCP Tool Calls
```yaml
- id: query_graph
  invoke: novanet_generate
  params:
    focus_key: "homepage"
    locale: "fr-FR"
    mode: "page"
  use.ctx: page_context
```

### `agent:` - Multi-Turn Agents
```yaml
- id: research
  agent: "Research competitor pricing strategies"
  tools:                          # Optional: available tools
    - web_search
    - fetch
  max_turns: 10                   # Optional: limit iterations
  model: claude-opus-4            # Optional: use stronger model
  use.ctx: research_results
```

## Bindings

### `use.ctx:` - Store Result
```yaml
- id: step1
  infer: "Generate content"
  use.ctx: content    # Result stored as $content
```

### `for_each:` - Iteration
```yaml
- id: process_items
  for_each: $items    # Array to iterate
  infer: "Process: $item"
  use.ctx: processed
```

### `when:` - Conditional Execution
```yaml
- id: optional_step
  when: $should_run == true
  exec: "npm run optional-task"
```

### `depends:` - Explicit Dependencies
```yaml
- id: step2
  depends: [step1, step3]   # Wait for these to complete
  infer: "Combine $step1_result and $step3_result"
```

## Workflow Structure

```yaml
workflow: my-workflow
version: "1.0"

description: |
  What this workflow does

# Global configuration
config:
  model: claude-sonnet-4
  timeout: 600

# MCP servers to connect
mcp:
  servers:
    novanet:
      command: "novanet-mcp"

# Input parameters
inputs:
  topic:
    type: string
    required: true
    description: "Topic to write about"

# Tasks (DAG nodes)
tasks:
  - id: research
    infer: "Research $topic"
    use.ctx: research

  - id: outline
    depends: [research]
    infer: "Create outline based on: $research"
    use.ctx: outline

  - id: write
    depends: [outline]
    infer: "Write full article following: $outline"
    use.ctx: article

# Output definition
outputs:
  article: $article
```

## Providers (7)

| Provider | Model Examples | Local? |
|----------|----------------|--------|
| **anthropic** | claude-sonnet-4, claude-opus-4 | No |
| **openai** | gpt-4o, o3 | No |
| **mistral** | mistral-large | No |
| **groq** | llama-3.3-70b | No |
| **deepseek** | deepseek-chat | No |
| **gemini** | gemini-2.0-flash | No |
| **ollama** | llama3.2, qwen2.5 | Yes |

## TUI (8 Views)

```bash
nika            # Home view
nika chat       # Chat mode
nika studio     # Workflow editor
nika monitor    # Job monitoring
```

| Key | View |
|-----|------|
| `1` | Home |
| `2` | Chat |
| `3` | Studio |
| `4` | Monitor |
| `5` | Split |
| `6` | Workspace |
| `7` | Settings |
| `?` | Help |

## CLI Commands

```bash
nika run <file> [--watch]         # Execute workflow
nika check <file>                 # Validate syntax
nika studio                       # Open TUI editor
nika chat                         # Interactive chat
nika jobs start                   # Start job daemon
nika jobs status                  # Check daemon status
nika jobs stop                    # Stop daemon
```

## Error Handling

```yaml
- id: risky_step
  exec: "might-fail.sh"
  on_error: continue              # continue, fail, retry
  retry:
    attempts: 3
    delay: 5                      # seconds
```

## See Also

- `/supernovae:nika/verbs/*` - Detailed verb documentation
- `/supernovae:nika/bindings/*` - Context and iteration
- `/supernovae:nika/dag/*` - Execution engine internals
- `/supernovae:nika/tui/*` - TUI views reference
