FROM chatwoot/chatwoot:latest

ENV ENABLE_FACEBOOK_CHANNEL=true

CMD ["sh", "-c", "rm -f /app/tmp/pids/server.pid && bundle exec rails s -e production"]