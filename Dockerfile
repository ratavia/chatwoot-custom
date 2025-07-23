# Imagen base de Chatwoot
FROM chatwoot/chatwoot:latest

# Crear script de limpieza simple
RUN echo '#!/bin/bash\necho "🚀 Iniciando Chatwoot personalizado..."\nrm -f /app/tmp/pids/server.pid 2>/dev/null || true\nrm -f /app/tmp/pids/*.pid 2>/dev/null || true\nmkdir -p /app/tmp/pids\ncd /app\necho "✅ Archivos PID limpiados"\nif [ "$RAILS_ENV" = "production" ]; then\n  echo "📊 Preparando base de datos..."\n  bundle exec rails db:chatwoot_prepare\nfi\necho "🎉 Iniciando servidor..."\nexec bundle exec rails server -b 0.0.0.0 -p ${PORT:-3000}' > /start.sh && chmod +x /start.sh

# Variables de entorno
ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true

# Puerto
EXPOSE 3000

# Ejecutar script
ENTRYPOINT ["/start.sh"]
