#!/bin/bash
nginx
cd /opt/app
tmux new -s backend -d ./scripts/start-backend-dev.sh
tmux new -s frontend -d ./scripts/start-frontend-dev.sh
sleep infinity