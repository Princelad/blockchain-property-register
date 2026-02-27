# AGENTS.md - National Blockchain Property Register

## Project Overview

This is a blockchain-based property registry system using Hyperledger Fabric, Rust backend, and Next.js frontend.

## Tech Stack

- **Blockchain**: Hyperledger Fabric 2.5+ (Go chaincode)
- **Backend**: Rust with Axum framework
- **Frontend**: Next.js 14, TypeScript, TailwindCSS, ShadCN UI
- **Database**: PostgreSQL 15+, IPFS, MinIO
- **Auth**: Keycloak with JWT
- **DevOps**: Docker, Kubernetes, Nginx

---

## Build, Lint, and Test Commands

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

# Run with output
cargo test -- --nocapture

# Lint
cargo clippy -- -D warnings

# Format
cargo fmt

# Check types
cargo check

# Doc check
cargo doc --no-deps
```

### Next.js (Frontend)

```bash
# Install dependencies
npm install

# Build
npm run build

# Run single test
npm test -- --testNamePattern="test name"

# Run tests in watch mode
npm test -- --watch

# Lint
npm run lint

# Format
npm run format

# Type check
npm run typecheck
```

### Docker

```bash
# Build all images
docker-compose build

# Run tests in container
docker-compose run backend cargo test

# Lint Dockerfiles
hadolint Dockerfile
```

---

## Code Style Guidelines

### Go (Chaincode)

- **Imports**: Group stdlib, external, then internal. Use `go fmt` automatically.
- **Naming**: `camelCase` for functions/variables, `PascalCase` for exported. Interfaces: `Reader`, `Writer` pattern.
- **Error Handling**: Always check errors. Return meaningful errors with context.
- **Context**: Use `contractapi.TransactionContextInterface` for chaincode context.
- **JSON Tags**: Always include JSON tags on structs.
- **Testing**: Use table-driven tests. Name test functions `Test<Method>_<Scenario>`.

```go
// Good example
type Property struct {
    PropertyID   string `json:"property_id"`
    ParcelNumber string `json:"parcel_number"`
    Status       string `json:"status"`
}

func (p *PropertyContract) RegisterProperty(ctx contractapi.TransactionContextInterface, 
    propertyID, parcelNumber string) error {
    // Validation
    if propertyID == "" {
        return fmt.Errorf("property ID required")
    }
    // Implementation
    return nil
}
```

### Rust (Backend)

- **Imports**: Use absolute paths with `crate::`, `super::` for relative. Group: std, external, local.
- **Naming**: `snake_case` for variables/functions, `PascalCase` for types, `SCREAMING_SNAKE_CASE` for constants.
- **Error Handling**: Use `anyhow` for application errors, `thiserror` for custom error types. Always propagate with `?`.
- **Async**: Use `async`/`await`. Prefer `tokio` runtime.
- **Types**: Enable all Clippy lints. Use type aliases for clarity.
- **Testing**: Use `#[tokio::test]` for async tests. Unit tests in same module with `#[cfg(test)]`.

```rust
// Good example
use anyhow::Result;
use axum::{extract::Path, routing::get, Router};
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
pub struct Property {
    pub property_id: String,
    pub parcel_number: String,
    pub status: String,
}

pub async fn get_property(Path(id): Path<String>) -> Result<Json<Property>> {
    // Implementation
}
```

### TypeScript/React (Frontend)

- **Imports**: Absolute imports from `@/` alias. Order: React, external, internal.
- **Naming**: `PascalCase` for components/files, `camelCase` for variables/functions. Components: `PropertyCard.tsx`.
- **Types**: Always define interfaces/types. Avoid `any`. Use `unknown` then narrow.
- **React**: Use functional components with hooks. Prefer composition over inheritance.
- **State**: Use `useState` for local, `useReducer` for complex, context for global.
- **Testing**: Name test files `ComponentName.test.tsx`. Use `@testing-library/react`.

```typescript
// Good example
import { useState } from 'react';
import { Card, CardHeader, CardTitle } from '@/components/ui/card';

interface PropertyCardProps {
  property: Property;
  onSelect?: (id: string) => void;
}

export function PropertyCard({ property, onSelect }: PropertyCardProps) {
  const [isLoading, setIsLoading] = useState(false);
  
  return (
    <Card>
      <CardHeader>
        <CardTitle>{property.address}</CardTitle>
      </CardHeader>
    </Card>
  );
}
```

### General

- **Commits**: Use conventional commits: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`.
- **PRs**: Keep under 400 lines. Reference issues.
- **Secrets**: Never commit secrets. Use `.env.example` template.
- **Docs**: Document public APIs. Use doc comments `///` in Rust, JSDoc in TS.

---

## Project Structure

```
/
├── chaincode/          # Go smart contracts
├── backend/           # Rust Axum API
├── frontend/          # Next.js application
├── network/           # Fabric network config
├── k8s/               # Kubernetes manifests
├── docker/            # Dockerfiles
└── progress.md        # Project tracking
```

---

## Key Development Notes

1. **Chaincode**: All state changes must go through chaincode. Never write directly to CouchDB.
2. **Transactions**: Use Fabric transactions for atomic operations. Implement double-sale prevention.
3. **Documents**: Store large files in IPFS/MinIO, keep hashes on-chain.
4. **Auth**: JWT from Keycloak maps to Fabric CA identities. Maintain role-based access.
5. **Testing**: Unit tests for logic, integration tests for API, E2E for flows.
