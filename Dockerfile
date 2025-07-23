# Usar imagen base de Chatwoot
FROM chatwoot/chatwoot:latest

# Variables de entorno para Railway
ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true

# Limpiar PID y arrancar directamente
CMD rm -f /app/tmp/pids/*.pid 2>/dev/null || true && \
    mkdir -p /app/tmp/pids && \
    cd /app && \
    bundle exec rails db:chatwoot_prepare && \
    bundle exec rails server -b 0.0.0.0 -p ${PORT:-3000}
