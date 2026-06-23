#!/bin/bash
KEY=$(cat /home/dotanarchy/.n8n-sync/api-key)
echo "=== workflows with 'sync test' ==="
curl -s http://127.0.0.1:5678/api/v1/workflows -H "X-N8N-API-KEY: $KEY" | jq '.data[] | select(.name | test("sync test")) | {id, name, active, versionId}'
