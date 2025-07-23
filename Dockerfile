# Usar imagen original que ya funciona
FROM ghcr.io/railwayapp-templates/chatwoot:Community

# Solo limpiar PID al inicio
CMD ["sh", "-c", "rm -f /app/tmp/pids/server.pid && rm -f /app/tmp/pids/*.pid && mkdir -p /app/tmp/pids && cd /app && exec bundle exec rails server -b 0.0.0.0 -p $PORT"]
