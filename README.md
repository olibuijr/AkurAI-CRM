<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/AkurAI--CRM-0.1.0-6366f1?style=for-the-badge&labelColor=0f172a">
  <img alt="AkurAI-CRM" src="https://img.shields.io/badge/AkurAI--CRM-0.1.0-6366f1?style=for-the-badge&labelColor=f8fafc">
</picture>

# AkurAI-CRM

**Enterprise CRM. Pure Rust. Zero external dependencies.**

AkurAI-CRM is a full-featured customer relationship management system built entirely in Rust on top of the [AkurAI-Framework](https://github.com/olibuijr/AkurAI-Framework). It ships as a single static binary — no Node.js, no Python, no database server, no container runtime. Copy it to a box, run it, done.

> Built for the AkurAI ecosystem. Integrates natively with AkurAI-RustAgent as both a CLI tool and MCP server.

---

## Features

- **Contact Management** — People and companies with rich profiles, relationships, and activity history
- **Sales Pipeline** — Kanban-style opportunity tracking with configurable stages (New → Screening → Meeting → Proposal → Negotiation → Won/Lost)
- **Task Management** — To-dos with status tracking, due dates, and entity linking
- **Rich Notes** — Markdown notes linked to any record
- **Activity Timeline** — Automatic audit trail for every record
- **Full-Text Search** — Cross-entity search across all your data
- **REST API** — Complete CRUD for all entity types at `/api/*`
- **MCP Server** — 10 AI-accessible tools for agent integration (`POST /mcp`)
- **No-Build Frontend** — Native ES modules, zero bundler, zero transpiler, zero npm
- **Self-Contained** — Single binary, embedded B+tree storage, zero external processes

## Quick Start

```bash
# Clone and build
git clone https://github.com/olibuijr/akurai-crm.git
cd akurai-crm
cargo build --release

# Seed with demo data
./target/release/akurai-crm seed

# Start the server
./target/release/akurai-crm serve
```

Open **http://127.0.0.1:8091** in your browser.

## Usage

```
akurai-crm 0.1.0 — Pure Rust CRM

USAGE:
  akurai-crm serve [opts]    Start the CRM web server
  akurai-crm seed [db]       Seed the database with demo data
  akurai-crm version         Print version

SERVE OPTIONS:
  --host <addr>   Bind host (default: 127.0.0.1)
  --port, -p <n>  Bind port (default: 8091)
  --dir <path>    Frontend directory (default: site/frontend)
  --db <path>     Database file (default: crm.db)
```

## API

All entities expose full CRUD via REST:

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/_meta` | GET | Discover all object types and fields |
| `/api/people` | GET/POST | List / Create people |
| `/api/people/:id` | GET/PUT/DELETE | Get / Update / Delete a person |
| `/api/companies` | GET/POST | List / Create companies |
| `/api/companies/:id` | GET/PUT/DELETE | Get / Update / Delete a company |
| `/api/opportunities` | GET/POST | List / Create opportunities |
| `/api/opportunities/:id` | GET/PUT/DELETE | Get / Update / Delete an opportunity |
| `/api/tasks` | GET/POST | List / Create tasks |
| `/api/tasks/:id` | GET/PUT/DELETE | Get / Update / Delete a task |
| `/api/notes` | GET/POST | List / Create notes |
| `/api/notes/:id` | GET/PUT/DELETE | Get / Update / Delete a note |
| `/api/search?q=` | GET | Full-text search across all entities |
| `/api/timeline?entityType=&entityId=` | GET | Activity timeline for a record |

## MCP Tools

For AI agent integration via the Model Context Protocol:

| Tool | Description |
|------|-------------|
| `list_people` | List all contacts |
| `get_person` | Get a person by ID |
| `create_person` | Create a new person |
| `list_companies` | List all companies |
| `get_company` | Get a company by ID |
| `list_opportunities` | List deals, optionally filtered by stage |
| `get_opportunity` | Get a deal by ID |
| `get_pipeline` | Pipeline summary with counts per stage |
| `search_crm` | Search across all entities |
| `list_tasks` | List tasks, optionally filtered by status |

## Architecture

```
┌──────────────────────────────────────────────┐
│                  akurai-crm                    │
│  ┌─────────┐  ┌─────────┐  ┌──────────────┐  │
│  │ crm-core │  │ crm-api │  │   crm-mcp    │  │
│  │ Entities │→│ Handlers │  │  MCP Server  │  │
│  │ Metadata │  │ Router   │  │ 10 Tools     │  │
│  │ Types    │  │ Search   │  │              │  │
│  └─────────┘  └────┬────┘  └──────┬───────┘  │
│                     │              │           │
│  ┌──────────────────┴──────────────┴───────┐  │
│  │         AkurAI-Framework                 │  │
│  │  HTTP · JSON · Router · B+Tree Storage  │  │
│  │  Collections · Template · CSS · Assets  │  │
│  └─────────────────────────────────────────┘  │
│              Zero external crates             │
└──────────────────────────────────────────────┘
```

## Tech Stack

| Layer | Technology |
|-------|-----------|
| **Language** | Rust (edition 2021, `#![forbid(unsafe_code)]`) |
| **Runtime deps** | None — `std` only. **Zero.** |
| **Database** | Embedded B+tree (CoW, crash-safe) |
| **HTTP** | `std::net::TcpListener` — from scratch |
| **JSON** | Custom parser/serializer — from scratch |
| **Frontend** | Native ES modules — no build step |
| **Storage** | Single file, no external process |

## Project Structure

```
akurai-crm/
├── crates/
│   ├── crm-core/     Data model, entities, types, metadata
│   ├── crm-api/      REST handlers, search, timeline
│   ├── crm-cli/      Binary: serve & seed commands
│   └── crm-mcp/      MCP server for AI agent integration
├── site/
│   ├── frontend/     11 HTML pages, CSS design system, JS client
│   ├── backend/      Config, routes, data model declaration, i18n
│   └── content/      Documentation
├── deploy.sh         Release engine (gate → bump → tag → push)
└── VERSION           Lockstep version
```

## Releasing

```bash
./deploy.sh [patch|minor|major]
```

Runs quality gates (fmt → clippy → tests), bumps version across all files, cuts the changelog, tags, and pushes to GitHub.

## License

MIT
