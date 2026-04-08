#!/bin/bash
set -ex

# Build all PSMDB build images
# Usage: ./build-images.sh [el8|el9|amzn2023|jammy|noble|bullseye|bookworm|all]

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMAGE_PREFIX="psmdb-build"

build_image() {
    local target=$1
    echo "=== Building ${IMAGE_PREFIX}:${target} ==="
    docker build \
        -f "${SCRIPT_DIR}/Dockerfile.${target}" \
        -t "${IMAGE_PREFIX}:${target}" \
        "${SCRIPT_DIR}"
}

case "${1:-all}" in
    # Generic
    el8)              build_image el8 ;;
    el9)              build_image el9 ;;
    # Specific distros
    rockylinux8)      build_image rockylinux8 ;;
    rockylinux9)      build_image rockylinux9 ;;
    almalinux8)       build_image almalinux8 ;;
    almalinux9)       build_image almalinux9 ;;
    oraclelinux8)     build_image oraclelinux8 ;;
    oraclelinux9)     build_image oraclelinux9 ;;
    amzn2023)         build_image amzn2023 ;;
    # DEB
    focal)            build_image focal ;;
    jammy)            build_image jammy ;;
    noble)            build_image noble ;;
    bullseye)         build_image bullseye ;;
    bookworm)         build_image bookworm ;;
    # Groups
    rpm-all)
        for t in el8 el9 rockylinux8 rockylinux9 almalinux8 almalinux9 oraclelinux8 oraclelinux9 amzn2023; do
            build_image $t
        done
        ;;
    deb-all)
        for t in focal jammy noble bullseye bookworm; do
            build_image $t
        done
        ;;
    all)
        for t in el8 el9 rockylinux8 rockylinux9 almalinux8 almalinux9 oraclelinux8 oraclelinux9 amzn2023 focal jammy noble bullseye bookworm; do
            build_image $t
        done
        ;;
    *)
        echo "Usage: $0 [target|rpm-all|deb-all|all]"
        echo "RPM targets: el8 el9 rockylinux8 rockylinux9 almalinux8 almalinux9 oraclelinux8 oraclelinux9 amzn2023"
        echo "DEB targets: focal jammy noble bullseye bookworm"
        exit 1
        ;;
esac

echo ""
echo "=== Images built ==="
docker images | grep ${IMAGE_PREFIX}
