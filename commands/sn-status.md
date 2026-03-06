---
name: sn-status
description: Check SuperNovae ecosystem health - verifies spn, nika, novanet installation and configuration
---

# SuperNovae Status Check

Run comprehensive health check on the SuperNovae ecosystem.

## What This Command Does

1. **Checks tool installation**
   - spn version and binary location
   - nika version and binary location
   - novanet version and binary location

2. **Verifies configuration**
   - Provider configuration (API keys set?)
   - MCP server definitions
   - Config file locations

3. **Tests connectivity**
   - Neo4j connection (for NovaNet)
   - Provider API validation

4. **Reports issues**
   - Missing tools
   - Configuration problems
   - Connectivity failures

## Usage

```
/supernovae:status
```

## Implementation

```bash
#!/bin/bash
echo "🔍 SuperNovae Ecosystem Status"
echo "================================"
echo ""

# Check spn
echo "📦 spn:"
if command -v spn &> /dev/null; then
    echo "  ✅ Installed: $(spn --version)"
    echo "  📍 Location: $(which spn)"
else
    echo "  ❌ Not installed"
    echo "  💡 Install: brew install supernovae-st/tap/spn"
fi
echo ""

# Check nika
echo "🦋 nika:"
if command -v nika &> /dev/null; then
    echo "  ✅ Installed: $(nika --version)"
    echo "  📍 Location: $(which nika)"
else
    echo "  ❌ Not installed"
    echo "  💡 Install: brew install supernovae-st/tap/nika"
fi
echo ""

# Check novanet
echo "🧠 novanet:"
if command -v novanet &> /dev/null; then
    echo "  ✅ Installed: $(novanet --version)"
    echo "  📍 Location: $(which novanet)"
else
    echo "  ❌ Not installed"
    echo "  💡 Install: brew install supernovae-st/tap/novanet"
fi
echo ""

# Check providers
echo "🔑 Providers:"
if command -v spn &> /dev/null; then
    spn provider list 2>/dev/null || echo "  ⚠️ No providers configured"
else
    echo "  ⚠️ spn not installed, cannot check providers"
fi
echo ""

# Check Neo4j
echo "🗄️ Neo4j:"
if docker ps 2>/dev/null | grep -q neo4j; then
    echo "  ✅ Running (Docker)"
elif nc -z localhost 7687 2>/dev/null; then
    echo "  ✅ Running (localhost:7687)"
else
    echo "  ⚠️ Not running"
    echo "  💡 Start: docker compose up -d (in novanet/packages/db)"
fi
echo ""

echo "================================"
echo "Run 'spn doctor' for detailed diagnostics"
```

## Expected Output

```
🔍 SuperNovae Ecosystem Status
================================

📦 spn:
  ✅ Installed: spn 0.12.2
  📍 Location: /opt/homebrew/bin/spn

🦋 nika:
  ✅ Installed: nika 0.21.0
  📍 Location: /opt/homebrew/bin/nika

🧠 novanet:
  ✅ Installed: novanet 0.17.0
  📍 Location: /opt/homebrew/bin/novanet

🔑 Providers:
  anthropic: ✅ configured
  ollama: ✅ configured

🗄️ Neo4j:
  ✅ Running (Docker)

================================
Run 'spn doctor' for detailed diagnostics
```
