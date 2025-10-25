#!/bin/sh
set -e

echo "Importing Keycloak realm with Google OIDC credentials..."

# Create a temporary writable file
TMP_REALM_FILE="/tmp/realm-final.json"

# Replace placeholders with environment variables
envsubst < /opt/keycloak/data/import/realm-export.json > "$TMP_REALM_FILE"

# Run Keycloak with the processed realm
exec /opt/keycloak/bin/kc.sh start-dev --import-realm --import-path "$TMP_REALM_FILE"
