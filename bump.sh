#!/usr/bin/env bash
# Usage: ./bump.sh 0.1.1   - point the formula at tag v0.1.1 of krushiraj/edf-tool and update sha256
set -euo pipefail
v="${1:?usage: ./bump.sh <version>}"
url="https://github.com/krushiraj/edf-tool/archive/refs/tags/v${v}.tar.gz"
sha=$(curl -fsSL "$url" | shasum -a 256 | cut -d' ' -f1)
f=Formula/edf-tool.rb
sed -i.bak -E "s|^  url \".*\"|  url \"${url}\"|; s|^  sha256 \".*\"|  sha256 \"${sha}\"|" "$f" && rm -f "$f.bak"
echo "edf-tool ${v}  sha256 ${sha}"
