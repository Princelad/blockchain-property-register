#!/bin/bash

set -e

echo "========================================="
echo "Generating Cryptographic Material"
echo "========================================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

export PATH=$PWD/bin:$PATH

if [ ! -d "bin" ]; then
    echo "Error: Fabric binaries not found. Please download them first."
    exit 1
fi

echo "Removing existing crypto material..."
rm -rf crypto-config
rm -rf channel-artifacts

echo "Generating crypto material using cryptogen..."
cryptogen generate --config=./crypto-config.yaml --output=./crypto-config

if [ $? -eq 0 ]; then
    echo "Crypto material generated successfully!"
else
    echo "Error generating crypto material"
    exit 1
fi

echo "Creating channel-artifacts directory..."
mkdir -p channel-artifacts

echo "Generating genesis block..."
configtxgen -profile SampleMultiNodeEtcdRaft -channelID system-channel -type OrdererGenesis -outputBlock ./channel-artifacts/genesis.block

if [ $? -eq 0 ]; then
    echo "Genesis block generated successfully!"
else
    echo "Error generating genesis block"
    exit 1
fi

echo "Generating channel transaction..."
configtxgen -profile ThreeOrgChannel -channelID property-channel -outputCreateChannelTx ./channel-artifacts/channel.tx

if [ $? -eq 0 ]; then
    echo "Channel transaction generated successfully!"
else
    echo "Error generating channel transaction"
    exit 1
fi

echo "Generating anchor peer updates..."

configtxgen -profile ThreeOrgChannel -channelID property-channel -asOrg Org1MSP -outputAnchorPeersUpdate ./channel-artifacts/GovAnchor.tx
configtxgen -profile ThreeOrgChannel -channelID property-channel -asOrg Org2MSP -outputAnchorPeersUpdate ./channel-artifacts/NotaryAnchor.tx
configtxgen -profile ThreeOrgChannel -channelID property-channel -asOrg Org3MSP -outputAnchorPeersUpdate ./channel-artifacts/RegistryAnchor.tx

echo "========================================="
echo "Cryptographic Material Generation Complete"
echo "========================================="
echo ""
echo "Generated files:"
echo "  - crypto-config/ (certificates)"
echo "  - channel-artifacts/genesis.block"
echo "  - channel-artifacts/channel.tx"
echo "  - channel-artifacts/*Anchor.tx"
