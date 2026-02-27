# National Blockchain Property Register

A blockchain-based property registry system using Hyperledger Fabric, Rust backend, and Next.js frontend.

## Overview

This project implements a national-scale property registration system on a permissioned blockchain network. It provides transparent, tamper-proof property ownership records with support for transfers, disputes, and comprehensive audit trails.

## Tech Stack

| Layer | Technology |
|-------|------------|
| Blockchain | Hyperledger Fabric 2.5+ (Go chaincode) |
| Backend | Rust with Axum framework |
| Frontend | Next.js 14, TypeScript, TailwindCSS, ShadCN UI |
| Database | PostgreSQL 15+, IPFS, MinIO |
| Auth | Keycloak with JWT |
| DevOps | Docker, Kubernetes, Nginx |

## Project Structure

```
/
├── chaincode/          # Go smart contracts (Hyperledger Fabric)
├── backend/           # Rust Axum API server
├── frontend/          # Next.js application
├── network/           # Fabric network configuration
├── k8s/               # Kubernetes manifests
├── docker/            # Dockerfiles
├── README.md          # Project documentation
├── AGENTS.md          # Agent/dev instructions
└── progress.md        # Development task tracking
```

## Architecture

### Layers

```
PRESENTATION      → Admin Dashboard, Citizen Portal (Next.js)
API GATEWAY       → Nginx Reverse Proxy
BACKEND           → Rust Axum API
INTEGRATION       → Fabric SDK, Keycloak, PostgreSQL
BLOCKCHAIN        → Hyperledger Fabric (Orderers, Peers, CA)
STORAGE           → IPFS, MinIO, PostgreSQL
```

### Key Principles

1. **Chaincode-First**: All blockchain state changes must go through chaincode. Never write directly to CouchDB.
2. **Atomic Transactions**: Use Fabric transactions for atomic operations. Implement double-sale prevention in chaincode.
3. **Off-Chain Storage**: Store large files in IPFS/MinIO, keep only hashes on-chain.
4. **Role-Based Access**: JWT from Keycloak maps to Fabric CA identities. Maintain role-based access control.
5. **Testing Strategy**: Unit tests for logic, integration tests for API, E2E for flows.

## Modules

| Module | Description |
|--------|-------------|
| Network Setup | Fabric 3-org network with Raft consensus, Fabric CA |
| Chaincode | PropertyContract, OwnershipContract, TransactionContract, DisputeContract |
| Identity | Keycloak + Fabric CA integration, JWT auth, RBAC |
| Document Storage | IPFS cluster + MinIO for documents/assets |
| Backend API | Rust/Axum REST API |
| Frontend | Next.js Admin Dashboard + Citizen Portal |

## Security

### Roles

| Role | Permissions |
|------|-------------|
| `sysadmin` | Network config, CA management |
| `registrar` | Property registration, dispute resolution |
| `notary` | Transaction verification |
| `owner` | Property viewing, transfer, upload |
| `viewer` | Public search, verification |

### Double-Sale Prevention
Chaincode implements atomic check-then-update pattern using Fabric's GetStateAndMetadata for optimistic locking.

## Development Phases

- **Phase 1**: Network Setup (MVP) - Fabric network config
- **Phase 2**: Core Chaincode (MVP) - Smart contracts
- **Phase 3**: Backend Integration (MVP) - Rust API
- **Phase 4**: Identity & Access Control - Keycloak
- **Phase 5**: Frontend Development - Next.js
- **Phase 6**: IPFS Integration - Document storage
- **Phase 7**: Deployment & DevOps
- **Phase 8**: Testing & Audit Logging
- **Phase 9**: Optimization & Security

See `progress.md` for detailed task tracking.

## Prerequisites

- Docker 24.0+ & Docker Compose 2.20+
- Go 1.21+ (for chaincode)
- Rust 1.75+ (for backend)
- Node.js 20+ (for frontend)
- PostgreSQL 15+

## Development Commands

### Go (Chaincode)

```bash
# Build chaincode
cd chaincode && go build -o property-chaincode .

# Run single test
go test -v -run TestPropertyRegistration ./...

# Run all tests with coverage
go test -v -coverprofile=coverage.out ./...

# Lint
go vet ./...
golangci-lint run

# Format
gofmt -w .
```

### Rust (Backend)

```bash
# Build
cd backend && cargo build --release

# Run single test
cargo test test_name_here

# Run all tests
cargo test

# Lint
cargo clippy -- -D warnings

# Format
cargo fmt
```

### Next.js (Frontend)

```bash
# Install dependencies
npm install

# Build
npm run build

# Run development server
npm run dev

# Lint
npm run lint

# Type check
npm run typecheck
```

### Docker

```bash
# Build all images
docker-compose build

# Run tests in container
docker-compose run backend cargo test
```

## License

This project is for educational and development purposes.
