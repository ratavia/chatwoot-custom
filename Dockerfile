FROM ghcr.io/railwayapp-templates/chatwoot:Community

ENV ENABLE_FACEBOOK_CHANNEL=true

ENTRYPOINT []

CMD ["sh", "-c", "rm -f /app/tmp/pids/server.pid && bundle exec rails s -e production"]
