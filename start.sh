#!/bin/bash

echo "================================"
echo "  Ubuntu Desktop + Firefox"
echo "  Railway Ready"
echo "================================"

# Virtuellen Display starten
echo "[INFO] Starte Display 1920x1080..."
Xvfb :1 -screen 0 1920x1080x24 &
sleep 3

export DISPLAY=:1

# Desktop starten
echo "[INFO] Starte XFCE Desktop..."
dbus-launch --exit-with-session startxfce4 &
sleep 4

# VNC Server starten
echo "[INFO] Starte VNC Server..."
x11vnc \
    -display :1 \
    -nopw \
    -listen localhost \
    -forever \
    -shared \
    -rfbport 5900 \
    -bg \
    -quiet

# Warte auf VNC
echo "[INFO] Warte auf VNC..."
WAITED=0
while ! nc -z localhost 5900; do
    sleep 1
    WAITED=$((WAITED + 1))
    if [ $WAITED -ge 30 ]; then
        echo "[ERROR] VNC startet nicht!"
        exit 1
    fi
done
echo "[OK] VNC bereit nach ${WAITED}s!"

# Firefox direkt starten
echo "[INFO] Starte Firefox..."
DISPLAY=:1 firefox \
    --no-sandbox \
    about:blank &

sleep 3

echo "================================"
echo " noVNC Browser URL:"
echo " Port: 6080"
echo " /vnc.html?autoconnect=true"
echo "================================"

# noVNC starten
websockify \
    --web=/usr/share/novnc \
    --heartbeat=30 \
    6080 \
    localhost:5900
