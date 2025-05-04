#!/bin/bash

set -e

mkdir -p "$HOME/.config/Bitwarden CLI"

bw config server "${BW_HOST}"

echo "Using apikey to log in"

bw login --apikey --raw

export BW_SESSION="$(bw unlock --passwordenv BW_PASSWORD --raw)"

bw unlock --check

echo -e "\n"

echo 'Running `bw server` on port 8087'

exec "$@"
