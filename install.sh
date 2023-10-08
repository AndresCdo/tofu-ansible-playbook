#!/bin/bash

if ! [ "$UID" -eq 0 ]; then
    echo "This script requires superuser privileges. Please run with sudo."
    exit 1
fi

# Commands that require superuser privileges
cd /tmp
git clone https://github.com/opentofu/opentofu.git

VERSION=$(curl --proto '=https' --tlsv1.2 -sSf https://go.dev/dl/ | grep -E 'go[0-9]+\.[0-9]+\.[0-9]+\.linux-amd64.tar.gz' | cut -d' ' -f6 | cut -d'>' -f1 | cut -d"=" -f2 | tail -n 1 | xargs echo | cut -d'/' -f3)

curl -OL https://golang.org/dl/$VERSION
rm -rf /usr/local/go
tar -C /usr/local -xzf "/tmp/$VERSION"

# Set PATH
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.profile
export PATH=$PATH:/usr/local/go/bin

go version

cd opentofu && make
go build -o bin/ ./cmd/tofu
cp bin/tofu /usr/local/bin

