# Usar la imagen base oficial de Chatwoot
FROM chatwoot/chatwoot:latest

# Cambiar a usuario root temporalmente
USER root

# Crear script de inicio
RUN echo '#!/bin/bash' > /start.sh && \
    echo 'set -e' >> /start.sh && \
    echo 'echo "🚀 Iniciando Chatwoot..."' >> /start.sh && \
    echo 'echo "🧹 Limpiando archivos PID..."' >> /start.sh && \
    echo 'rm -f /app/tmp/pids/server.pid' >> /start.sh && \
    echo 'rm -f /app/tmp/pids/*.pid' >> /start.sh && \
    echo 'mkdir -p /app/tmp/pids' >> /start.sh && \
    echo 'chmod 755 /app/tmp/pids' >> /start.sh && \
    echo 'echo "🗑️ Limpiando cache..."' >> /start.sh && \
    echo 'rm -rf /app/tmp/cache/* 2>/dev/null || true' >> /start.sh && \
    echo 'cd /app' >> /start.sh && \
    echo 'if [ "$RAILS_ENV" = "production" ]; then' >> /start.sh && \
    echo '  echo "📊 Ejecutando migraciones..."' >> /start.sh && \
    echo '  bundle exec rails db:chatwoot_prepare' >> /start.sh && \
    echo 'fi' >> /start.sh && \
    echo 'if [ "$RAILS_ENV" = "production" ] && [ ! -d "/app/public/packs" ]; then' >> /start.sh && \
    echo '  echo "🎨 Precompilando assets..."' >> /start.sh && \
    echo '  bundle exec rails assets:precompile' >> /start.sh && \
    echo 'fi' >> /start.sh && \
    echo 'export PORT=${PORT:-3000}' >> /start.sh && \
    echo 'echo "✅ Iniciando servidor en puerto $PORT..."' >> /start.sh && \
    echo 'exec bundle exec rails server -b 0.0.0.0 -p $PORT' >> /start.sh

# Hacer el script ejecutable
RUN chmod +x /start.sh

# Volver al usuario chatwoot
USER chatwoot

# Directorio de trabajo
WORKDIR /app

# Crear directorios necesarios
RUN mkdir -p tmp/pids tmp/cache

# Exponer puerto
EXPOSE 3000

# Variables de entorno
ENV RAILS_ENV=production
ENV NODE_ENV=production
ENV PORT=3000
ENV RAILS_LOG_TO_STDOUT=true

# Punto de entrada
ENTRYPOINT ["/start.sh"]
