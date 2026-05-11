# 🐾 Pajé — Biological Data Platform(WIP)
## Development & Architecture Guide

**Go Module:** `github.com/seu-usuario/animal-wiki`

---

## 📌 Index

- [Overview](#-overview)
- [Architecture Design](#-architecture-design)
- [Database Schema](#-database-schema)
- [Prerequisites](#-prerequisites)
- [Environment Setup](#-environment-setup)
- [Project Structure](#-project-structure)
- [Development Workflow](#-development-workflow)

---

## 📖 Overview

**Animal Wiki** is a scalable encyclopedia designed for biological data management. Unlike traditional wikis, it uses a **dynamic taxonomic model** that allows for infinite levels of classification (Kingdom, Phylum, Class, etc.) without requiring database schema changes.

### Core Strengths:
* **Dynamic Taxonomy:** Recursive self-referencing hierarchy.
* **Biomes & Habitats:** Dedicated ecosystem pages with rich descriptions.
* **Flexible Metadata:** PostgreSQL **JSONB** for species-specific traits (diet, lifespan, etc.).

---

## 🏗️ Architecture Design

The project follows **Clean Architecture** principles to ensure the business logic remains decoupled from external drivers (Database/API).

```text
HTTP (Chi Router)
└── internal/apiserver/          # API Handlers, Requests & Responses
    └── internal/core/           # Domain Logic & Port Interfaces
        ├── models/              # Data Structs
        └── coredb/              # Postgres Adapters (pgx)
```
**Key principle:** The `apiserver` only knows the `core` interfaces, never the database implementation directly.

---

## 🗄️ Database Schema

The system is built on a relational foundation optimized for hierarchical navigation.



| Table | Responsibility |
| :--- | :--- |
| **`taxonomy`** | Manages the "Tree of Life" (Recursive `parent_id`). |
| **`animals`** | Primary animal data and `JSONB` characteristics. |
| **`habitats`** | Detailed info about Biomes (Amazon, Savanna, etc.). |
| **`animal_habitats`** | Link table for Many-to-Many relationship. |

---

## 🛠️ Prerequisites

Make sure you have the following tools installed:

| Tool | Purpose |
| :--- | :--- |
| **Go 1.2x+** | Language Runtime |
| **PostgreSQL 14+** | Relational Database |
| **Migrate / Goose** | Database Migrations |
| **Postman/Insomnia** | API Testing |

---

## ⚙️ Environment Setup

### 1. Security First (`.gitignore`)
This project uses a `.env` file for credentials. **Never commit your `.env`!**

```bash
cp .env.example .env
# Edit .env with your local DB credentials
```
📁 Project Structure
```text
internal/
├── core/             # Business Logic (The Brain)
│   ├── model.go      # Data structures
│   ├── ports.go      # Repository interfaces
│   └── service.go    # Use cases
├── coredb/           # Database Implementation (The Hands)
│   └── postgres.go   # pgx adapters
└── apiserver/        # Delivery Mechanism (The Voice)
    ├── handler.go    # HTTP Handlers
    └── router.go     # Route definitions
```

🔄 Development Workflow
To add a new feature (e.g., adding a "Conservation Status" filter):

1.Database: Update the schema or add a migration.

2.Core Model: Update the Animal struct in internal/core/model.go.

3.Core Interface: Add the necessary method to the interface in ports.go.

4.Implementation: Write the SQL logic in internal/coredb/postgres.go.

5.API: Create/Update the handler in internal/apiserver/handler.go.

6.Routes: Map the new endpoint in router.go.

```bash
# Run unit tests
go test ./internal/core/...

# Run database integration tests
go test ./internal/coredb/...
```
