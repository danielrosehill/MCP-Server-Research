# MCP Gateway Research: Dynamic Tool Discovery Solutions

**Research Date:** January 2, 2026
**Research Agent:** Claude Code (Claude Opus 4.5)
**Research Type:** Point-in-time analysis

---

## Executive Summary

This research investigates MCP (Model Context Protocol) gateways that specifically address **context pollution**—the problem where MCP servers flood agents with extensive tool schemas before any conversation begins. The ideal solution involves **dynamic tool discovery** where gateways present minimal tools upfront and use semantic routing to expose relevant tools on-demand.

### Key Finding

The most promising approaches for your use case are:

1. **MCP-Zero Framework** - Academic research demonstrating 98% token reduction through hierarchical vector routing
2. **IBM Context Forge** - Open-source gateway with federation, semantic discovery, and admin UI
3. **Amazon Bedrock AgentCore Gateway** - Managed service with semantic tool selection
4. **Agentgateway (Linux Foundation)** - High-performance Rust implementation with built-in UI

---

## The Context Pollution Problem

Current MCP implementations inject comprehensive tool schemas into system prompts, forcing agents into passive selection from pre-defined options. This creates massive context overhead:

- GitHub MCP server alone: **4,600+ tokens** for 26 tools
- Comprehensive ecosystems: **248,000+ tokens** before first turn
- Result: Degraded performance, slower responses, higher costs

### The Solution: Dynamic Tool Discovery

The emerging best practice is to present **one or two meta-tools** that interface with a vector store of tool descriptions. The agent requests capabilities semantically, and only relevant tools are injected into context.

---

## Detailed Gateway Analysis

### Tier 1: Best Matches for Your Requirements

#### 1. IBM MCP Context Forge
**Repository:** https://github.com/IBM/mcp-context-forge
**Documentation:** https://ibm.github.io/mcp-context-forge/

| Criteria | Assessment |
|----------|------------|
| Dynamic Tool Discovery | Yes - mDNS auto-discovery, health monitoring, capability merging |
| Context Pollution Solution | Federates and filters tools across gateways |
| Web UI | Yes - Admin UI (HTMX + Alpine.js) with real-time logs |
| Docker Support | Yes - Docker/Podman, Redis-backed caching |
| Streamable HTTP | Yes - HTTP, JSON-RPC, WebSocket, SSE, stdio, streamable-HTTP |
| Project Maturity | IBM community project, FastAPI-based |
| Unique Features | REST-to-MCP adaptation, A2A agent integration, OpenTelemetry |

**Key Advantage:** Federation model allows multiple gateways to work together with automatic registry merging. This solves the local vs. remote MCP challenge by bridging environments transparently.

**Best For:** Complex deployments spanning local and cloud environments.

---

#### 2. Agentgateway (Linux Foundation)
**Repository:** https://github.com/agentgateway/agentgateway
**Website:** https://agentgateway.dev/

| Criteria | Assessment |
|----------|------------|
| Dynamic Tool Discovery | Yes - A2A and MCP protocol support for dynamic communication |
| Context Pollution Solution | RBAC-based tool filtering and access control |
| Web UI | Yes - Built-in UI for exploring agent-to-agent/agent-to-tool |
| Docker Support | Yes - Multiple Dockerfiles, Kubernetes via Gateway API |
| Streamable HTTP | Yes - Modern protocol support |
| Project Maturity | **Linux Foundation project**, 1.5k stars, 606 commits, 59 contributors |
| Unique Features | Rust-based (high performance), legacy API transformation (OpenAPI to MCP) |

**Key Advantage:** Strong governance through Linux Foundation backing. Dynamic configuration updates via xDS without downtime. Can transform existing REST APIs into MCP resources.

**Best For:** Long-term stability, performance-critical deployments, enterprise adoption.

---

#### 3. Amazon Bedrock AgentCore Gateway
**Documentation:** https://aws.amazon.com/blogs/machine-learning/transform-your-mcp-architecture-unite-mcp-servers-through-agentcore-gateway/

| Criteria | Assessment |
|----------|------------|
| Dynamic Tool Discovery | Yes - **Semantic Tool Selection** is core capability |
| Context Pollution Solution | Intelligent tool routing based on query semantics |
| Web UI | AWS Console integration |
| Docker Support | Managed service (not self-hosted) |
| Streamable HTTP | Full AWS integration |
| Project Maturity | **AWS managed service** - production-grade backing |
| Unique Features | Native MCP server target type, multi-server aggregation |

**Key Advantage:** Purpose-built semantic tool selection. Can group multiple task-specific MCP servers behind single interface.

**Limitation:** Cloud-managed only, not self-hostable. Best as reference for desired behavior.

---

#### 4. MCP-Zero (Research Framework)
**Paper:** https://arxiv.org/html/2506.01056v3

| Criteria | Assessment |
|----------|------------|
| Dynamic Tool Discovery | Yes - **Hierarchical Vector Routing** (two-stage coarse-to-fine) |
| Context Pollution Solution | **98% token reduction** demonstrated on APIBank |
| Web UI | Research framework, not production service |
| Docker Support | N/A |
| Unique Features | Iterative capability extension, MCP-tools dataset |

**Key Advantage:** Academic validation of the semantic routing approach. Demonstrates that agents can actively request tools via structured format:
```
<tool_assistant>
  server: ...  # Platform/permission domain
  tool: ...    # Operation type + target
</tool_assistant>
```

**Scoring Formula:** `score = (s_server × s_tool) × max(s_server, s_tool)`

**Best For:** Understanding the theoretical foundation; implementing similar patterns in other gateways.

---

### Tier 2: Strong Contenders

#### 5. MetaMCP
**Repository:** https://github.com/metatool-ai/metamcp

| Criteria | Assessment |
|----------|------------|
| Dynamic Tool Discovery | Middleware-based tool filtering |
| Context Pollution Solution | Namespace-level interception, tool overrides |
| Web UI | Yes - Inspector interface, inline tool editing |
| Docker Support | Yes - Docker Compose recommended |
| Project Maturity | 1.8k stars, 759 commits, 32 releases (v2.4.22) |
| Unique Features | Profile/namespace management, OIDC enterprise SSO |

**Note:** You mentioned using MetaMCP already. Its main limitation is lack of semantic/vector-based discovery—it relies on manual namespace configuration.

---

#### 6. Docker MCP Gateway
**Repository:** https://github.com/docker/mcp-gateway

| Criteria | Assessment |
|----------|------------|
| Dynamic Tool Discovery | Real-time tool enumeration from active servers |
| Context Pollution Solution | Container isolation, consistent configs |
| Web UI | **No** - CLI only (`docker mcp`) |
| Docker Support | **Native** - Docker CLI plugin |
| Project Maturity | **Docker-backed**, 1.1k stars, 756 commits |
| Unique Features | Container-based isolation, Docker Desktop integration |

**Limitation:** No web UI; CLI-only management. May not solve context pollution directly.

---

#### 7. MCPJungle
**Repository:** https://github.com/mcpjungle/MCPJungle

| Criteria | Assessment |
|----------|------------|
| Dynamic Tool Discovery | Automatic tool cataloging from registered servers |
| Context Pollution Solution | **Tool Groups** - expose only subsets |
| Web UI | Registry server interface |
| Docker Support | Yes - dev and prod compose configs |
| Unique Features | Cherry-pick specific tools, OpenTelemetry metrics |

**Key Advantage:** Tool Groups directly address context pollution by allowing selective tool exposure.

---

#### 8. Unla
**Repository:** https://github.com/AmoyLab/Unla

| Criteria | Assessment |
|----------|------------|
| Dynamic Tool Discovery | Hot-reload via OS signals, HTTP, or Redis PubSub |
| Context Pollution Solution | Session isolation, multi-tenancy |
| Web UI | Yes - Management interface with built-in MCP chat |
| Docker Support | Yes - K8s/Helm support |
| Unique Features | Zero-code API conversion, persistent sessions |

---

#### 9. Archestra
**Repository:** https://github.com/archestra-ai/archestra

| Criteria | Assessment |
|----------|------------|
| Dynamic Tool Discovery | Private MCP registry with governance |
| Context Pollution Solution | **Dual LLM architecture** isolating dangerous responses |
| Web UI | Yes - ChatGPT-like interface |
| Docker Support | Yes - `docker pull archestra/platform:latest` |
| Unique Features | Non-probabilistic security against prompt injection via MCP |

**Key Advantage:** Unique security model that isolates MCP tool responses to prevent data exfiltration.

---

#### 10. MCP Gateway Registry (Agentic Community)
**Repository:** https://github.com/agentic-community/mcp-gateway-registry

| Criteria | Assessment |
|----------|------------|
| Dynamic Tool Discovery | **Semantic search** via embeddings (sentence-transformers, OpenAI, LiteLLM) |
| Context Pollution Solution | Fine-grained tool/method permissions |
| Web UI | Yes - Interactive Registry dashboard, Grafana observability |
| Docker Support | Yes - Pre-built images, Podman, ECS Fargate |
| Project Maturity | 362 stars, 304 commits, 19 contributors |
| Unique Features | A2A agent registry, Keycloak/Cognito integration |

**Key Advantage:** Semantic search directly addresses dynamic discovery.

---

### Tier 3: Specialized/Partial Solutions

#### Semantic Router (vLLM)
**Reference:** https://joshuaberkowitz.us/blog/github-repos-8/semantic-tool-intelligence-vllm-context-aware-tool-router-solves-the-tool-overload-crisis-1736

Not a gateway but a routing layer that can be integrated:
- Pre-computed embeddings for each tool
- Cosine similarity matching against queries
- Top-K tool selection above similarity threshold
- **Results:** 99.1% token reduction (127,315 → 1,084 tokens), accuracy improved 13.62% → 43.13%

#### Portkey AI Gateway
**Repository:** https://github.com/Portkey-AI/gateway

High-maturity project (10.2k stars, 10B+ tokens processed daily) but focused on LLM routing rather than MCP-specific tool discovery.

---

## Comparison Matrix

| Gateway | Dynamic Discovery | Context Solution | Web UI | Docker | Backing | Stars |
|---------|------------------|------------------|--------|--------|---------|-------|
| IBM Context Forge | Yes (mDNS) | Federation | Yes | Yes | IBM | - |
| Agentgateway | Yes (A2A/MCP) | RBAC | Yes | Yes | Linux Foundation | 1.5k |
| AWS AgentCore | Yes (Semantic) | Native | Console | Managed | AWS | N/A |
| MCP-Zero | Yes (Vector) | 98% reduction | No | No | Academic | N/A |
| MetaMCP | Partial | Namespaces | Yes | Yes | Community | 1.8k |
| Docker MCP Gateway | Yes (Enum) | Isolation | No | Native | Docker | 1.1k |
| MCPJungle | Yes | Tool Groups | Yes | Yes | Community | - |
| Unla | Yes (Hot-reload) | Sessions | Yes | Yes | Community | - |
| Archestra | Yes (Registry) | Dual LLM | Yes | Yes | Archestra AI | - |
| MCP Gateway Registry | Yes (Semantic) | Permissions | Yes | Yes | Community | 362 |

---

## Recommendation

### Primary Choice: IBM Context Forge + Semantic Router Pattern

**Rationale:**
1. **Federation** solves your local/remote MCP bridging challenge
2. **Admin UI** meets your web management requirement
3. **REST-to-MCP adaptation** future-proofs API integration
4. **Open source** with IBM community backing (not a short-lived project)
5. **Streamable HTTP** supported (not deprecated SSE)

**Enhancement:** Integrate the semantic router pattern (from vLLM research or MCP-Zero approach) for true dynamic tool discovery. This would involve:
- Vector store of tool descriptions
- Single "discovery" tool exposed to agent
- Semantic matching returns only relevant tools per query

### Secondary Choice: Agentgateway

If Linux Foundation governance and Rust performance are priorities, Agentgateway offers:
- Long-term project sustainability
- Dynamic configuration without downtime
- Legacy API transformation

### Worth Watching: MCP Gateway Registry

The agentic-community project already implements semantic search with embeddings. Combined with its existing web UI and Docker support, it may evolve into the most complete solution.

---

## Protocol Considerations

### Streamable HTTP vs SSE

You correctly noted that SSE is deprecated. Current status:
- **Streamable HTTP** is the emerging standard
- IBM Context Forge, Agentgateway, and most Tier 1 solutions support it
- MetaMCP supports both SSE and Streamable HTTP

### Local-to-Remote File Transfer

This remains challenging. IBM Context Forge's federation model is the closest solution, allowing local gateways to bridge to remote services. The pattern:

```
Local Files → Local MCP Gateway → Federation → Remote Gateway → Cloud Service
```

---

## Implementation Path

1. **Deploy IBM Context Forge** via Docker with federation enabled
2. **Configure local MCP servers** (Home Assistant, local devices)
3. **Add remote MCPs** (Gemini transcription, File.AI, Context7)
4. **Implement semantic routing** by:
   - Creating tool description embeddings
   - Exposing single "discover_tools" endpoint
   - Using vector similarity for tool selection
5. **Connect Claude Code** to single gateway endpoint

---

## Sources

- [MCP-Zero Paper](https://arxiv.org/html/2506.01056v3)
- [IBM Context Forge](https://ibm.github.io/mcp-context-forge/)
- [Agentgateway](https://agentgateway.dev/)
- [AWS AgentCore Gateway](https://aws.amazon.com/blogs/machine-learning/transform-your-mcp-architecture-unite-mcp-servers-through-agentcore-gateway/)
- [vLLM Semantic Router](https://joshuaberkowitz.us/blog/github-repos-8/semantic-tool-intelligence-vllm-context-aware-tool-router-solves-the-tool-overload-crisis-1736)
- [Awesome MCP Gateways](https://github.com/e2b-dev/awesome-mcp-gateways)
- [Composio MCP Gateway Guide](https://composio.dev/blog/mcp-gateways-guide)
