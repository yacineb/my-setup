#!/usr/bin/env bash
# Shared helpers for setup scripts

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
RESET='\033[0m'

info()  { echo -e "${GREEN}[+]${RESET} $1"; }
warn()  { echo -e "${YELLOW}[!]${RESET} $1"; }
err()   { echo -e "${RED}[x]${RESET} $1"; }
header(){ echo -e "\n${BOLD}=== $1 ===${RESET}\n"; }
