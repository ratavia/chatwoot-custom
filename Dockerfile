# Usar la imagen base oficial de Chatwoot
FROM chatwoot/chatwoot:latest

# Instalar dependencias adicionales si es necesario
USER root

# Crear directorio para scripts
RUN mkdir -p /scripts

# Crear script de limpieza y arranque
RUN cat > /scripts/start.sh << 'EOF'
#!/bin/bash
set -e

echo "🚀 Iniciando Chatwoot..."

# Limpiar archivos PID existentes
echo "🧹 Limpiando archivos PID..."
rm -f /app/tmp/pids/server.pid
rm -f /app/tmp/pids/*.pid
find /app/tmp/pids/ -name "*.pid" -delete 2>/dev/null || true

# Crear directorio tmp/pids si no existe
mkdir -p /app/tmp/pids
chmod 755 /app/tmp/pids

# Limpiar cache si existe
echo "🗑️  Limpiando cache..."
rm -rf /app/tmp/cache/* 2>/dev/null || true

# Verificar conectividad de base de datos
echo "🔍 Verificando conexión a base de datos..."
cd /app
timeout 30 bundle exec rails runner "ActiveRecord::Base.connection.execute('SELECT 1')" || {
    echo "❌ Error: No se puede conectar a la base de datos"
    echo "Esperando 10 segundos antes de reintentar..."
    sleep 10
    bundle exec rails runner "ActiveRecord::Base.connection.execute('SELECT 1')"
}

# Ejecutar migraciones si es necesario
if [ "$RAILS_ENV" = "production" ]; then
    echo "📊 Ejecutando migrac
