#!/bin/bash

set -e

echo "========================================="
echo "Joining Peers to Channel"
echo "========================================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

export PATH=$PWD/bin:$PATH

CHANNEL_NAME=${CHANNEL_NAME:-property-channel}

if [ ! -f "channel-artifacts/${CHANNEL_NAME}.block" ]; then
    echo "Error: ${CHANNEL_NAME}.block not found. Run create-channel.sh first."
    exit 1
fi

join_peer() {
    ORG=$1
    PEER=$2
    DOMAIN=$3
    
    FULL_PEER_NAME="${PEER}.${DOMAIN}.com"
    
    echo "Joining $FULL_PEER_NAME to channel..."
    
    docker-compose run --rm cli sh -c "
        CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/${DOMAIN}.com/users/Admin@${DOMAIN}.com/msp \
        CORE_PEER_ADDRESS=${FULL_PEER_NAME}:7051 \
        CORE_PEER_LOCALMSPID=${ORG}MSP \
        peer channel join \
            -b /etc/hyperledger/fabric/channel-artifacts/${CHANNEL_NAME}.block \
            --tls=false \
            --cafile /etc/hyperledger/fabric/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
    "
}

echo "Joining Org1 (Gov) peers..."
join_peer "Org1" "peer0" "gov"
join_peer "Org1" "peer1" "gov"

echo "Joining Org2 (Notary) peers..."
join_peer "Org2" "peer0" "notary"
join_peer "Org2" "peer1" "notary"

echo "Joining Org3 (Registry) peers..."
join_peer "Org3" "peer0" "registry"
join_peer "Org3" "peer1" "registry"

echo "========================================="
echo "All Peers Joined to Channel"
echo "========================================="
