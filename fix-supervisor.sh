#!/bin/bash
for svc in karakeep n8n immich; do
  ini="$HOME/.config/supervisord/conf.d/$svc.ini"
  # Replace the closing quote of the command line to add sleep infinity
  sed -i 's|podman-compose up -d"$|podman-compose up -d; sleep infinity"|' "$ini"
  echo "=== $svc ==="
  grep ^command "$ini"
done
