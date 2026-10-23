#!/usr/bin/env sh
# Generates all secrets into ./secrets (git-ignored). Run once before `docker compose up`.
set -eu
cd "$(dirname "$0")/.."
mkdir -p secrets && chmod 700 secrets
# Use local ssh-keygen if present, otherwise the one inside the pinned agent image.
if command -v ssh-keygen >/dev/null 2>&1; then KEYGEN=ssh-keygen
else KEYGEN="docker run --rm -u $(id -u):$(id -g) -v $PWD/secrets:/secrets -w / --entrypoint ssh-keygen jenkins/ssh-agent:6.11.1-jdk21"; fi
[ -f secrets/agent_ssh_key ] || $KEYGEN -q -t ed25519 -N '' -C jenkins-controller -f secrets/agent_ssh_key
for a in debian alpine; do
  [ -f secrets/agent_${a}_host_key ] || $KEYGEN -q -t ed25519 -N '' -C agent-$a -f secrets/agent_${a}_host_key
  printf '%s' "$(cut -d' ' -f1,2 secrets/agent_${a}_host_key.pub)" > secrets/agent_${a}_host_key_pub  # no trailing newline
done
if [ ! -f .env ]; then
  printf 'JENKINS_ADMIN_ID=admin\nJENKINS_ADMIN_PASSWORD=%s\n' "$(head -c 18 /dev/urandom | base64 | tr -d '/+=')" > .env
  chmod 600 .env
fi
# Containers run as other UIDs; make the files readable to them (directory stays private).
chmod 644 secrets/*
echo "Secrets in ./secrets, admin login in ./.env"
