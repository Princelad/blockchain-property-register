#!/bin/bash

set -e

echo "========================================="
echo "Creating Channel"
echo "========================================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

export PATH=$PWD/bin:$PATH

CHANNEL_NAME=${CHANNEL_NAME:-property-channel}

if [ ! -f "channel-artifacts/channel.tx" ]; then
    echo "Error: channel.tx not found. Run generate-certs.sh first."
    exit 1
fi

echo "Creating channel: $CHANNEL_NAME"

docker-compose run --rm cli sh -c "
    peer channel create \
        -o orderer.example.com:7050 \
        -c $CHANNEL_NAME \
        -f /etc/hyperledger/fabric/channel-artifacts/channel.tx \
        --tls=false \
        --cafile /etc/hyperledger/fabric/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
"

if [ $? -eq 0 ]; then
    echo "Channel '$CHANNEL_NAME' created successfully!"
    mv ${CHANNEL_NAME}.block channel-artifacts/ 2>/dev/null || true
else
    echo "Error creating channel"
    exit 1
fi

echo "========================================="
echo "Channel Creation Complete"
echo "========================================="
