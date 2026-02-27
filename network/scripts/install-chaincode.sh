#!/bin/bash

set -e

echo "========================================="
echo "Installing Chaincode"
echo "========================================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

export PATH=$PWD/bin:$PATH

CHANNEL_NAME=${CHANNEL_NAME:-property-channel}
CHAINCODE_NAME=${CHAINCODE_NAME:-property-cc}
CHAINCODE_VERSION=${CHAINCODE_VERSION:-1.0}
CHAINCODE_LANGUAGE=${CHAINCODE_LANGUAGE:-golang}

install_on_peer() {
    ORG=$1
    PEER=$2
    DOMAIN=$3
    
    FULL_PEER_NAME="${PEER}.${DOMAIN}.com"
    
    echo "Installing chaincode on $FULL_PEER_NAME..."
    
    docker-compose run --rm cli sh -c "
        CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/${DOMAIN}.com/users/Admin@${DOMAIN}.com/msp \
        CORE_PEER_ADDRESS=${FULL_PEER_NAME}:7051 \
        CORE_PEER_LOCALMSPID=${ORG}MSP \
        peer chaincode install \
            -n $CHAINCODE_NAME \
            -v $CHAINCODE_VERSION \
            -l $CHAINCODE_LANGUAGE \
            -p github.com/hyperledger/fabric-samples/chaincode/abstore/go
    "
}

echo "Installing chaincode on all peers..."

echo "Installing on Org1 (Gov) peers..."
install_on_peer "Org1" "peer0" "gov"
install_on_peer "Org1" "peer1" "gov"

echo "Installing on Org2 (Notary) peers..."
install_on_peer "Org2" "peer0" "notary"
install_on_peer "Org2" "peer1" "notary"

echo "Installing on Org3 (Registry) peers..."
install_on_peer "Org3" "peer0" "registry"
install_on_peer "Org3" "peer1" "registry"

echo "========================================="
echo "Chaincode Installation Complete"
echo "========================================="
