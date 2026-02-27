#!/bin/bash

set -e

echo "========================================="
echo "Starting Fabric Network"
echo "========================================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if [ ! -d "crypto-config" ]; then
    echo "Crypto config not found. Running generate-certs.sh..."
    ./scripts/generate-certs.sh
fi

echo "Starting Docker containers..."
docker-compose up -d

echo "Waiting for containers to be ready..."
sleep 10

echo "Checking container status..."
docker-compose ps

echo "========================================="
echo "Fabric Network Started"
echo "========================================="
echo ""
echo "Services running:"
echo "  - Orderer: orderer.example.com:7050"
echo "  - CAs: ca.gov, ca.notary, ca.registry, ca.orderer"
echo "  - Peers: 6 peers across 3 organizations"
echo "  - CLI: For running Fabric commands"
echo ""
echo "Next steps:"
echo "  1. Create channel: ./scripts/create-channel.sh"
echo "  2. Join peers: ./scripts/join-channel.sh"
echo "  3. Install chaincode: ./scripts/install-chaincode.sh"
