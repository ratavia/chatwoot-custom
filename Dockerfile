FROM ghcr.io/railwayapp-templates/chatwoot:Community

ENV ENABLE_FACEBOOK_CHANNEL=true

# Esto asegura que se borre el archivo .pid antes de iniciar el servidor
CMD ["sh", "-c", "rm -f /app/tmp/pids/server.pid && bundle exec rails s -e production"]
