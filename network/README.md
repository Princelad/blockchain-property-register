# Hyperledger Fabric Network Configuration

This directory contains the configuration and setup scripts for the National Blockchain Property Register Hyperledger Fabric network.

## Network Topology

### Organizations

| Organization | Domain | MSP ID | Purpose |
|-------------|--------|--------|---------|
| Government Authority | gov.example.com | Org1MSP | Government oversight |
| Notary Services | notary.example.com | Org2MSP | Notary verification |
| Property Registry | registry.example.com | Org3MSP | Property registration |

### Peers

Each organization has 2 peers:
- `peer0.{org}.example.com` - Primary peer
- `peer1.{org}.example.com` - Secondary peer

### Orderer

- **Hostname**: orderer.example.com
- **Port**: 7050
- **Type**: Solo (for development)
- **MSP ID**: OrdererMSP

### Certificate Authorities

| CA | Port | Organization |
|----|------|---------------|
| ca.gov | 7054 | Government |
| ca.notary | 7054 | Notary |
| ca.registry | 7054 | Registry |
| ca.orderer | 7054 | Orderer |

## Prerequisites

1. **Docker & Docker Compose** installed
2. **Fabric Binaries** downloaded:
   - cryptogen
   - configtxgen
   - peer
   - orderer
   - fabric-ca-tools

Download Fabric binaries:
```bash
mkdir -p bin
curl -sSL https://raw.githubusercontent.com/hyperledger/fabric/main/scripts/bootstrap.sh | bash -s -- 2.5.4 1.5.7
```

## Quick Start

### 1. Start the Network

```bash
cd network
./scripts/network-up.sh
```

This will:
- Generate cryptographic certificates
- Create the genesis block
- Start all Docker containers (orderer, peers, CAs)

### 2. Create Channel

```bash
./scripts/create-channel.sh
```

### 3. Join Peers to Channel

```bash
./scripts/join-channel.sh
```

### 4. Install Chaincode

```bash
./scripts/install-chaincode.sh
```

### 5. Stop the Network

```bash
./scripts/network-down.sh
```

## Configuration Files

| File | Description |
|------|-------------|
| `config.yaml` | Network topology definition |
| `crypto-config.yaml` | Cryptogen configuration |
| `docker-compose.yaml` | Docker services |
| `configtx.yaml` | Channel transaction configuration |
| `.env` | Environment variables |

## Endorsement Policies

### Property Registration
Requires all 3 organizations to approve:
```
AND('Org1MSP.peer','Org2MSP.peer','Org3MSP.peer')
```

### Property Transfer
Requires 2 of 3 organizations to approve:
```
OR('Org1MSP.peer','Org2MSP.peer','Org3MSP.peer')
```

### Ownership Verification
Any organization can verify:
```
OR('Org1MSP.peer','Org2MSP.peer','Org3MSP.peer')
```

## Channel Information

- **Channel Name**: property-channel
- **Genesis Block**: channel-artifacts/genesis.block
- **Channel Transaction**: channel-artifacts/channel.tx

## Ports

| Service | Port |
|---------|------|
| Orderer | 7050 |
| Org1 CA | 7054 |
| Org1 Peer0 | 7051 |
| Org1 Peer1 | 8051 |
| Org2 CA | 8054 |
| Org2 Peer0 | 9051 |
| Org2 Peer1 | 10051 |
| Org3 CA | 9054 |
| Org3 Peer0 | 11051 |
| Org3 Peer1 | 12051 |
| Orderer CA | 10054 |

## Directory Structure

```
network/
├── config.yaml              # Network topology
├── crypto-config.yaml       # Cryptogen config
├── docker-compose.yaml      # Docker services
├── configtx.yaml           # Channel config
├── .env                    # Environment variables
├── README.md               # This file
├── channel-artifacts/      # Channel configuration
│   ├── genesis.block       # System channel genesis
│   ├── channel.tx         # Channel creation tx
│   └── *Anchor.tx         # Anchor peer updates
├── crypto-config/         # Generated certificates
└── scripts/               # Setup scripts
    ├── generate-certs.sh
    ├── create-channel.sh
    ├── join-channel.sh
    ├── install-chaincode.sh
    ├── network-up.sh
    └── network-down.sh
```

## Troubleshooting

### Containers not starting

Check Docker status:
```bash
docker-compose ps
docker-compose logs <service-name>
```

### Certificate errors

Regenerate certificates:
```bash
rm -rf crypto-config channel-artifacts
./scripts/generate-certs.sh
```

### Peer connection issues

Verify containers are on the same network:
```bash
docker network inspect fabric-network
```

## Next Steps

After setting up the network:
1. Deploy the property chaincode (Phase 2)
2. Connect the Rust backend (Phase 3)
3. Set up authentication (Phase 4)
4. Build the frontend (Phase 5)
