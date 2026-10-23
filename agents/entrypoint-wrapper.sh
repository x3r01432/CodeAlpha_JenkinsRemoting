#!/usr/bin/env sh
# Installs the pre-generated, pinned host key so the controller can verify this agent,
# then hands over to the stock jenkins/ssh-agent entrypoint.
set -eu
install -m 600 -o root /run/secrets/host_key /etc/ssh/ssh_host_ed25519_key
install -m 644 -o root /run/secrets/host_key.pub /etc/ssh/ssh_host_ed25519_key.pub
JENKINS_AGENT_SSH_PUBKEY="$(cat /run/secrets/authorized_key)"; export JENKINS_AGENT_SSH_PUBKEY
exec setup-sshd "$@"
