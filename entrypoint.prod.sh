#!/bin/sh
set -e

rm -f /app/tmp/pids/server.pid

rails db:migrate RAILS_ENV=production

exec "$@"