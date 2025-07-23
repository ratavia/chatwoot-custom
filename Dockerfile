# Imagen base de Chatwoot
FROM chatwoot/chatwoot:latest

# Establecer directorio de trabajo
WORKDIR /app

# Variables de entorno esenciales
ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true
ENV PORT=3000
ENV ACTIVE_JOB_QUEUE_ADAPTER=sidekiq

# Crear script de inicio que ejecuta AMBOS: Rails + Sidekiq
RUN echo '#!/bin/bash\n\
echo "🚀 Starting Chatwoot with Sidekiq..."\n\
\n\
# Limpiar archivos PID\n\
rm -f tmp/pids/server.pid tmp/pids/sidekiq.pid 2>/dev/null || true\n\
mkdir -p tmp/pids\n\
\n\
# Verificar conexión a BD\n\
echo "🔍 Testing database connection..."\n\
timeout 30 bundle exec rails runner "ActiveRecord::Base.connection.execute(\\"SELECT 1\\")" || {\n\
  echo "❌ Database connection failed"\n\
  exit 1\n\
}\n\
echo "✅ Database connection OK"\n\
\n\
# Preparar base de datos\n\
echo "📊 Preparing database..."\n\
bundle exec rails db:chatwoot_prepare\n\
\n\
# Iniciar Sidekiq en background\n\
echo "🔧 Starting Sidekiq worker..."\n\
bundle exec sidekiq -e production -d -P tmp/pids/sidekiq.pid -L log/sidekiq.log\n\
\n\
# Esperar un momento para que Sidekiq inicie\n\
sleep 3\n\
\n\
# Verificar que Sidekiq esté corriendo\n\
if [ -f tmp/pids/sidekiq.pid ]; then\n\
  echo "✅ Sidekiq started successfully"\n\
else\n\
  echo "⚠️ Sidekiq may not have started properly"\n\
fi\n\
\n\
# Iniciar Rails server\n\
echo "🌐 Starting Rails server on port $PORT..."\n\
exec bundle exec rails server -b 0.0.0.0 -p $PORT\n' > /start.sh

# Hacer ejecutable
RUN chmod +x /start.sh

# Exponer puerto
EXPOSE 3000

# Usar script de inicio
ENTRYPOINT ["/start.sh"]
