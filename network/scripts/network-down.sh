#!/bin/bash

set -e

echo "========================================="
echo "Stopping Fabric Network"
echo "========================================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "Stopping and removing containers..."
docker-compose down -v

echo "Removing generated files? (y/n)"
read -r response

if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
    echo "Removing crypto-config and channel-artifacts..."
    rm -rf crypto-config
    rm -rf channel-artifacts
    mkdir -p channel-artifacts
fi

echo "========================================="
echo "Fabric Network Stopped"
echo "========================================="
