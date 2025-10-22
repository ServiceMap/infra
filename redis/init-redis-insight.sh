#!/bin/sh
set -e

echo "Starting RedisInsight..."

# Find and start the actual RedisInsight binary
if [ -f "/app/bin/redisinsight" ]; then
  /app/bin/redisinsight &
elif [ -f "/usr/local/bin/redisinsight" ]; then
  /usr/local/bin/redisinsight &
elif [ -x "/docker-entrypoint.sh" ]; then
  /docker-entrypoint.sh &
else
  # Fallback: try to find node and run the app
  cd /app && node main.js &
fi

REDISINSIGHT_PID=$!

echo "Waiting for RedisInsight to be ready..."
sleep 15

# Wait for RedisInsight API to respond
READY=0
for i in $(seq 1 30); do
  if wget -q --spider http://localhost:5540 2>/dev/null; then
    echo "RedisInsight is ready!"
    READY=1
    break
  fi
  echo "Waiting... ($i/30)"
  sleep 2
done

if [ $READY -eq 0 ]; then
  echo "⚠️ RedisInsight didn't start in time, but continuing anyway..."
fi

sleep 5

echo "Configuring Redis database..."

# Add Redis database via API
wget --post-data='{"name":"ServiceMap Redis","host":"servicemap-redis","port":6379,"connectionType":"STANDALONE"}' \
  --header='Content-Type: application/json' \
  -O - \
  http://localhost:5540/api/instance 2>/dev/null && echo "✅ Database configured!" || echo "⚠️ Database might already exist or API not ready"

echo "Setup complete!"

# Keep the container running
wait $REDISINSIGHT_PID