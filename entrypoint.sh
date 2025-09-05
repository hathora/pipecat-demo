#!/usr/bin/env bash

set -e

APP=${APP:-runner}

if [ "$APP" = "runner" ]; then
    exec uv run bot_runner.py --port ${FAST_API_PORT:-7860}
elif [ "$APP" = "bot" ]; then
    exec uv run bot.py "$@"
else
    echo "Error: APP must be either 'runner' or 'bot', got: $APP"
    exit 1
fi
